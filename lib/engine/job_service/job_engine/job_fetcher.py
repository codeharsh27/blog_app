# job_fetcher.py
import time
import logging
from datetime import datetime
from typing import Optional

from .fetch_greenhouse import fetch_greenhouse
from .fetch_lever import fetch_lever
from .normalize import normalize_greenhouse, normalize_lever
from .save_to_db import save_jobs_to_db

logger = logging.getLogger("FETCHER")


def run_job_fetcher(job_id: Optional[str] = None):
    start = time.time()
    all_jobs = []

    logger.info("Fetching Greenhouse jobs…")
    gh_raw = fetch_greenhouse()
    gh_norm = [normalize_greenhouse(j) for j in gh_raw]
    all_jobs.extend(gh_norm)

    logger.info("Fetching Lever jobs…")
    lv_raw = fetch_lever()
    lv_norm = [normalize_lever(j) for j in lv_raw]
    all_jobs.extend(lv_norm)

    logger.info(f"Saving {len(all_jobs)} jobs to DB…")
    save_jobs_to_db(all_jobs)

    end = time.time()

    return {
        "status": "success",
        "fetched_total": len(all_jobs),
        "greenhouse": len(gh_norm),
        "lever": len(lv_norm),
        "duration_sec": round(end - start, 2),
    }
