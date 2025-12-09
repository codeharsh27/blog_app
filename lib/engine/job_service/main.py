# job_service/main.py
import os
import sys
from pathlib import Path

os.makedirs("logs", exist_ok=True)

# Add the project root to Python path
project_root = Path(__file__).parent.parent.parent.parent  # Go up to blog_app directory
sys.path.append(str(project_root))

from fastapi import FastAPI, HTTPException, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from datetime import datetime, timedelta
import uuid
import logging
from dotenv import load_dotenv

# Ensure logs directory exists
log_dir = Path(__file__).parent / 'logs'
log_dir.mkdir(exist_ok=True, parents=True)
log_file = log_dir / 'job_service.log'

# Set up logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(),
        logging.FileHandler(log_file, encoding='utf-8')
    ]
)
logger = logging.getLogger("JOB_SERVICE")

# Load environment variables
env_path = Path(__file__).parent / '.env'
if not env_path.exists():
    env_path = Path(__file__).parent.parent / '.env'
    if not env_path.exists():
        logger.error("Could not find .env file")
        raise RuntimeError("Missing .env file")

load_dotenv(env_path)

# Import after environment variables are loaded
try:
    from job_service.job_engine.job_fetcher import run_job_fetcher
    from job_service.job_engine.save_to_db import get_job_count
    from common.supabase_client import supabase
except ImportError as e:
    logger.error(f"Import error: {e}")
    raise

app = FastAPI(title="Job Aggregation API")

# Allow frontend access
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Store background job status
job_status = {}

# ------------------------------------
# 🚀 TRIGGER JOB FETCHING
# ------------------------------------
@app.get("/fetch-jobs")
async def fetch_jobs(background_tasks: BackgroundTasks, force: bool = False):
    # Prevent duplicate running jobs
    running = [
        jid for jid, j in job_status.items()
        if j["status"] in ["pending", "in_progress"]
    ]

    if running and not force:
        return {
            "status": "already_running",
            "running_job_id": running[0],
            "force_to_override": True
        }

    # Create new job
    job_id = str(uuid.uuid4())
    job_status[job_id] = {
        "status": "pending",
        "started_at": datetime.utcnow(),
        "completed_at": None,
        "result": None,
        "error": None
    }

    background_tasks.add_task(run_job_async, job_id)

    return {
        "status": "started",
        "job_id": job_id,
        "status_url": f"/jobs/{job_id}"
    }

# Background execution wrapper
def run_job_async(job_id: str):
    try:
        job_status[job_id]["status"] = "in_progress"
        result = run_job_fetcher(job_id=job_id)
        job_status[job_id].update({
            "status": "completed",
            "completed_at": datetime.utcnow(),
            "result": result
        })
    except Exception as e:
        job_status[job_id].update({
            "status": "failed",
            "completed_at": datetime.utcnow(),
            "error": str(e)
        })
        logger.error(f"Job failed: {e}")

# ------------------------------------
# 📌 CHECK JOB STATUS
# ------------------------------------
@app.get("/jobs/{job_id}")
async def get_job_status(job_id: str):
    if job_id not in job_status:
        raise HTTPException(status_code=404, detail="Job not found")

    # Convert datetime to ISO
    data = job_status[job_id].copy()
    if data.get("started_at"):
        data["started_at"] = data["started_at"].isoformat()
    if data.get("completed_at"):
        data["completed_at"] = data["completed_at"].isoformat()

    return data

# ------------------------------------
# 📌 GET PAGINATED JOBS
# ------------------------------------
@app.get("/jobs")
async def list_jobs(limit: int = 20, offset: int = 0):
    try:
        response = supabase.table("jobs") \
            .select("*") \
            .order("created_at", desc=True) \
            .range(offset, offset + limit - 1) \
            .execute()

        total_count = get_job_count()

        return {
            "status": "success",
            "count": len(response.data),
            "total": total_count,
            "jobs": response.data
        }
    except Exception as e:
        return {"status": "error", "message": str(e)}

# ------------------------------------
# 🔧 DEBUG SUPABASE CONNECTION
# ------------------------------------
@app.get("/debug/supabase")
async def debug_supabase():
    try:
        resp = supabase.table("jobs").select("*", count="exact").limit(1).execute()
        sample = resp.data[0] if resp.data else None
        return {
            "status": "ok",
            "rows": resp.count,
            "sample": sample
        }
    except Exception as e:
        return {"status": "error", "message": str(e)}

# ------------------------------------
# HEALTH CHECK
# ------------------------------------
@app.get("/health")
def health():
    return {"status": "ok", "time": datetime.utcnow().isoformat()}
