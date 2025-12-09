# tech_news_engine/main.py
import os
import sys
from pathlib import Path

os.makedirs("logs", exist_ok=True)

# Add the project root to Python path
project_root = Path(__file__).parent.parent.parent.parent  # Go up to blog_app directory
sys.path.append(str(project_root))

from fastapi import FastAPI, Query, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from apscheduler.schedulers.background import BackgroundScheduler
from datetime import datetime, timedelta
from dotenv import load_dotenv
import time
import logging

# Ensure logs directory exists
log_dir = Path(__file__).parent / 'logs'
log_dir.mkdir(exist_ok=True, parents=True)
log_file = log_dir / 'tech_news_engine.log'

# Set up logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(),
        logging.FileHandler(log_file, encoding='utf-8')
    ]
)
logger = logging.getLogger("TECH_NEWS_ENGINE")

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
    from common.supabase_client import supabase
    from tech_news_engine.scraper.main_scraper import main as scrape_all_sites

except ImportError as e:
    logger.error(f"Import error: {e}")
    raise

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("NEWS_SERVICE")

app = FastAPI(title="News Service API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

CACHE_TTL = 1800  # 30 minutes

# ------------------------------------
# CACHE HELPERS
# ------------------------------------
def load_cache():
    try:
        r = supabase.table("news_cache") \
            .select("*") \
            .order("updated_at", desc=True) \
            .limit(1) \
            .execute()

        if not r.data:
            return None

        row = r.data[0]
        age = time.time() - row["last_updated"]

        if age < CACHE_TTL:
            return row

        return None
    except Exception as e:
        print(f"Cache read error: {e}")
        return None


def save_cache(data):
    try:
        supabase.table("news_cache").insert({
            "data": data,
            "last_updated": int(time.time()),
            "updated_at": datetime.utcnow().isoformat()
        }).execute()
    except Exception as e:
        print(f"Cache write error: {e}")

# ------------------------------------
# MAIN NEWS ENDPOINT
# ------------------------------------
@app.get("/news")
def get_news(category: str = Query(None)):

    cache = load_cache()
    if cache:
        data = cache["data"]
        # Category filter inside cache too
        if category:
            filtered = [
                a for a in data["articles"]
                if category in a.get("tags", [])
            ]
            return {"articles": filtered, "filtered_by": category}

        return data

    # Cache miss → scrape fresh
    articles = scrape_all_sites()
    data = {
        "articles": articles,
        "last_updated": time.time(),
        "updated_at": datetime.utcnow().isoformat()
    }

    save_cache(data)
    return data

# ------------------------------------
# DEBUG ENDPOINT
# ------------------------------------
@app.get("/debug-cache")
def debug_cache():
    try:
        r = supabase.table("news_cache").select("*").order("updated_at", desc=True).limit(1).execute()
        return {"rows": len(r.data), "sample": r.data[0] if r.data else None}
    except Exception as e:
        return {"error": str(e)}

# ------------------------------------
# BACKGROUND REFRESH
# ------------------------------------
def refresh_news():
    try:
        articles = scrape_all_sites()
        data = {
            "articles": articles,
            "last_updated": time.time(),
            "updated_at": datetime.utcnow().isoformat()
        }
        save_cache(data)
        logger.info("News cache updated.")
    except Exception as e:
        logger.error(f"Failed to refresh news: {e}")

scheduler = BackgroundScheduler()
scheduler.add_job(refresh_news, "interval", minutes=30)
scheduler.start()

# ------------------------------------
# HEALTH CHECK
# ------------------------------------
@app.get("/health")
def health():
    return {"status": "ok", "time": datetime.utcnow().isoformat()}

print("[NEWS SERVICE] Scheduler started")
