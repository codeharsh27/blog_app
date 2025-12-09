# fetch_greenhouse.py
import requests
import time
import logging
from urllib.parse import urlparse

logger = logging.getLogger("GREENHOUSE")

# Stable companies (always return jobs)
GREENHOUSE_COMPANIES = [
    "stripe", "notion", "airbnb", "figma", "datadog",
    "discord", "brex", "coursera", "square", "robinhood"
]

def fetch_greenhouse_company_jobs(company):
    url = f"https://boards-api.greenhouse.io/v1/boards/{company}/jobs"
    try:
        res = requests.get(url, timeout=10)
        res.raise_for_status()

        data = res.json()
        jobs = data.get("jobs", [])

        results = []
        for job in jobs:
            job_url = job.get("absolute_url")
            domain = urlparse(job_url).netloc if job_url else None

            results.append({
                "id": job.get("id"),
                "title": job.get("title"),
                "company": job.get("company", {}).get("name", company),
                "location": job.get("location", {}).get("name"),
                "job_url": job_url,
                "domain": domain,
                "updated_at": job.get("updated_at"),
                "created_at": job.get("created_at"),
            })
        logger.info(f"[GH] {company}: {len(results)} jobs")
        return results

    except Exception as e:
        logger.error(f"[GH] ERROR {company}: {e}")
        return []


def fetch_greenhouse():
    all_jobs = []
    for comp in GREENHOUSE_COMPANIES:
        all_jobs.extend(fetch_greenhouse_company_jobs(comp))
        time.sleep(0.2)  # avoid API rate limit
    return all_jobs
