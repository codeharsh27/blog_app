import logging
import time
import json
from typing import List, Dict, Any, Optional, Set
from datetime import datetime, timedelta
import os
from pathlib import Path
from dotenv import load_dotenv
from supabase import create_client, Client

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(),
        logging.FileHandler('save_to_db.log')
    ]
)
logger = logging.getLogger(__name__)

# Constants
DEFAULT_BATCH_SIZE = 50
MAX_RETRIES = 3
RETRY_DELAY = 1  # seconds

# Load environment variables
load_dotenv()

class SupabaseManager:
    _instance = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(SupabaseManager, cls).__new__(cls)
            cls._instance._initialize()
        return cls._instance
    
    def _initialize(self):
        """Initialize the Supabase client with retry logic."""
        for attempt in range(MAX_RETRIES):
            try:
                supabase_url = os.getenv("SUPABASE_URL")
                supabase_key = os.getenv("SUPABASE_SERVICE_KEY")
                
                if not supabase_url or not supabase_key:
                    raise ValueError("Missing Supabase URL or Service Key in environment variables")
                
                self.client = create_client(supabase_url, supabase_key)
                
                # Test the connection
                self.client.table('jobs').select('count', count='exact').limit(1).execute()
                logger.info("Successfully connected to Supabase")
                return
                
            except Exception as e:
                if attempt < MAX_RETRIES - 1:
                    wait_time = RETRY_DELAY * (attempt + 1)
                    logger.warning(
                        f"Failed to initialize Supabase client (attempt {attempt + 1}/{MAX_RETRIES}): {e}. "
                        f"Retrying in {wait_time} seconds..."
                    )
                    time.sleep(wait_time)
                else:
                    logger.error(f"Failed to initialize Supabase client after {MAX_RETRIES} attempts: {e}")
                    raise

# Initialize the Supabase client
try:
    supabase = SupabaseManager().client
except Exception as e:
    logger.critical(f"Critical error initializing Supabase: {str(e)}")
    supabase = None

def save_jobs_to_db(jobs: List[Dict[str, Any]], batch_size: int = DEFAULT_BATCH_SIZE) -> Dict[str, Any]:
    """
    Save jobs to the database with duplicate checking and batch processing.
    
    Args:
        jobs: List of job dictionaries to save
        batch_size: Number of jobs to process in each batch (default: 50)
        
    Returns:
        Dictionary with operation status and statistics
    """
    if not supabase:
        error_msg = "Supabase client not initialized. Check your environment variables and logs."
        logger.error(error_msg)
        return {
            "status": "error",
            "message": error_msg,
            "saved_count": 0,
            "duplicate_count": 0,
            "error_count": len(jobs) if jobs else 0,
            "total_processed": len(jobs) if jobs else 0
        }
        
    if not jobs:
        logger.warning("No jobs provided to save")
        return {
            "status": "success",
            "message": "No jobs to save",
            "saved_count": 0,
            "duplicate_count": 0,
            "error_count": 0,
            "total_processed": 0
        }

    total_jobs = len(jobs)
    saved_count = 0
    duplicate_count = 0
    error_count = 0
    errors = []
    
    logger.info(f"Starting to process {total_jobs} jobs in batches of {batch_size}")
    
    try:
        # Process jobs in batches
        for i in range(0, total_jobs, batch_size):
            batch = jobs[i:i + batch_size]
            batch_saved = 0
            batch_duplicates = 0
            batch_errors = 0
            batch_to_insert = []
            
            # Get all job_ids in the current batch
            job_ids = [job['job_id'] for job in batch if job.get('job_id')]
            
            if not job_ids:
                logger.warning(f"Batch {i//batch_size + 1} has no valid job_ids, skipping")
                error_count += len(batch)
                continue
            
            # Check for existing jobs in the current batch
            existing_jobs = set()
            try:
                result = supabase.table('jobs') \
                    .select('job_id') \
                    .in_('job_id', job_ids) \
                    .execute()
                existing_jobs = {job['job_id'] for job in result.data}
            except Exception as e:
                logger.error(f"Error checking for existing jobs: {str(e)}")
                # Continue with an empty set to avoid skipping valid jobs
            
            # Prepare batch for insertion
            now = datetime.utcnow().isoformat()
            for job in batch:
                try:
                    job_id = job.get('job_id')
                    if not job_id:
                        logger.warning("Job missing 'job_id', skipping")
                        batch_errors += 1
                        continue
                    
                    # Check if job already exists
                    if job_id in existing_jobs:
                        batch_duplicates += 1
                        logger.debug(f"Skipping duplicate job: {job_id}")
                        continue
                    
                    # Add/update timestamps
                    job['created_at'] = now
                    job['updated_at'] = now
                    
                    batch_to_insert.append(job)
                    
                except Exception as e:
                    error_msg = f"Error processing job {job.get('job_id', 'unknown')}: {str(e)}"
                    logger.error(error_msg)
                    batch_errors += 1
                    errors.append(error_msg)
            
            # Insert batch if we have valid jobs
            if batch_to_insert:
                try:
                    result = supabase.table('jobs').insert(batch_to_insert).execute()
                    
                    if result.data:
                        batch_saved = len(batch_to_insert)
                        logger.info(f"Batch {i//batch_size + 1}: Inserted {batch_saved} jobs")
                    else:
                        logger.warning(f"Batch {i//batch_size + 1}: No data returned from insert")
                        batch_errors = len(batch_to_insert)
                        
                except Exception as e:
                    error_msg = f"Error inserting batch {i//batch_size + 1}: {str(e)}"
                    logger.error(error_msg)
                    errors.append(error_msg)
                    batch_errors = len(batch_to_insert)
            
            # Update counters
            saved_count += batch_saved
            duplicate_count += batch_duplicates
            error_count += batch_errors
            
            # Log batch summary
            logger.info(
                f"Batch {i//batch_size + 1}/{(total_jobs + batch_size - 1) // batch_size} - "
                f"Saved: {batch_saved}, Duplicates: {batch_duplicates}, Errors: {batch_errors}"
            )
            
            # Small delay between batches to avoid rate limiting
            if i + batch_size < total_jobs:
                time.sleep(0.5)
    
    except Exception as e:
        # Log any unexpected errors during processing
        error_msg = f"Unexpected error processing jobs: {str(e)}"
        logger.error(error_msg, exc_info=True)
        errors.append(error_msg)
        error_count = total_jobs - saved_count - duplicate_count
    
    # Prepare result    
    result = {
        "status": (
            "success" if error_count == 0 else 
            "partial" if saved_count > 0 else 
            "error"
        ),
        "message": (
            f"Processed {total_jobs} jobs. "
            f"Saved: {saved_count}, "
            f"Duplicates: {duplicate_count}, "
            f"Errors: {error_count}"
        ),
        "total_processed": total_jobs,
        "saved_count": saved_count,
        "duplicate_count": duplicate_count,
        "error_count": error_count,
    }
    
    if errors:
        result["error_samples"] = errors[:10]  # Include first 10 errors
        if len(errors) > 10:
            result["total_errors"] = len(errors)
    
    logger.info(f"Job processing completed: {json.dumps(result, indent=2)}")
    return result

def get_job_count() -> int:
    """Get the total number of jobs in the database."""
    if not supabase:
        logger.error("Supabase client not initialized")
        return 0
        
    try:
        result = supabase.table('jobs').select('*', count='exact').execute()
        return result.count if hasattr(result, 'count') else len(result.data or [])
    except Exception as e:
        logger.error(f"Error getting job count: {str(e)}")
        return 0

def cleanup_old_jobs(days_old: int = 30) -> Dict[str, Any]:
    """
    Remove jobs older than the specified number of days.
    
    Args:
        days_old: Remove jobs older than this many days (default: 30)
        
    Returns:
        Dictionary with operation status and statistics
    """
    if not supabase:
        error_msg = "Supabase client not initialized"
        logger.error(error_msg)
        return {"status": "error", "message": error_msg}
    
    try:
        cutoff_date = (datetime.utcnow() - timedelta(days=days_old)).isoformat()
        
        # First get count of jobs to be deleted
        count_result = supabase.table('jobs') \
            .select('*', count='exact') \
            .lt('created_at', cutoff_date) \
            .execute()
            
        total_to_delete = count_result.count if hasattr(count_result, 'count') else len(count_result.data or [])
        
        if total_to_delete == 0:
            return {
                "status": "success",
                "message": f"No jobs older than {days_old} days found",
                "deleted_count": 0,
                "cutoff_date": cutoff_date
            }
        
        logger.info(f"Deleting {total_to_delete} jobs older than {cutoff_date}")
        
        # Delete in batches to avoid timeouts
        batch_size = 1000
        total_deleted = 0
        
        while True:
            # Get a batch of old job IDs
            result = supabase.table('jobs') \
                .select('id') \
                .lt('created_at', cutoff_date) \
                .limit(batch_size) \
                .execute()
                
            batch_ids = [job['id'] for job in result.data]
            
            if not batch_ids:
                break
                
            # Delete the batch
            try:
                delete_result = supabase.table('jobs') \
                    .delete() \
                    .in_('id', batch_ids) \
                    .execute()
                    
                batch_deleted = len(delete_result.data or [])
                total_deleted += batch_deleted
                
                logger.info(f"Deleted {batch_deleted} jobs (total: {total_deleted}/{total_to_delete})")
                
                if batch_deleted < batch_size:
                    break
                    
                # Small delay to avoid overwhelming the database
                time.sleep(1)
                
            except Exception as e:
                error_msg = f"Error deleting batch: {str(e)}"
                logger.error(error_msg)
                return {
                    "status": "error",
                    "message": error_msg,
                    "deleted_count": total_deleted,
                    "total_to_delete": total_to_delete,
                    "cutoff_date": cutoff_date
                }
        
        return {
            "status": "success" if total_deleted == total_to_delete else "partial",
            "message": f"Deleted {total_deleted} jobs older than {days_old} days",
            "deleted_count": total_deleted,
            "total_to_delete": total_to_delete,
            "cutoff_date": cutoff_date
        }
        
    except Exception as e:
        error_msg = f"Error cleaning up old jobs: {str(e)}"
        logger.error(error_msg, exc_info=True)
        return {
            "status": "error",
            "message": error_msg,
            "error": str(e)
        }
