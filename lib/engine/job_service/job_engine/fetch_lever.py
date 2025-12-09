# fetch_lever.py
import requests
import logging
from urllib.parse import urlparse

logger = logging.getLogger("LEVER")

LEVER_COMPANIES = [
    "airtable", "twitch", "reddit", "gusto", "instacart", "ramp"
]

def fetch_lever_company_jobs(company):
    url = f"https://api.lever.co/v0/postings/{company}?mode=json"

    try:
        res = requests.get(url, timeout=10)
        res.raise_for_status()
        postings = res.json()

        results = []
        for job in postings:
            job_url = job.get("hostedUrl")
            domain = urlparse(job_url).netloc if job_url else None

            results.append({
                "id": job.get("id"),
                "title": job.get("text"),
                "company": company,
                "location": job.get("categories", {}).get("location"),
                "job_url": job_url,
                "domain": domain,
                "created_at": job.get("createdAt"),
                "updated_at": job.get("updatedAt"),
            })
        logger.info(f"[LEVER] {company}: {len(results)} jobs")
        return results

    except Exception as e:
        logger.error(f"[LEVER] ERROR {company}: {e}")
        return []


def fetch_lever():
    all_jobs = []
    for comp in LEVER_COMPANIES:
        all_jobs.extend(fetch_lever_company_jobs(comp))
    return all_jobs
