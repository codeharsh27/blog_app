# normalize.py
def normalize_greenhouse(job):
    job_id = f"greenhouse_{job.get('id')}"
    return {
        "job_id": job_id,
        "title": job.get("title"),
        "company": job.get("company"),
        "location": job.get("location"),
        "salary": None,
        "experience": None,
        "skills": [],
        "job_url": job.get("job_url"),
        "source_portal": "greenhouse",
        "hr_email": None,
        "company_domain": job.get("domain"),
        "posted_on": job.get("updated_at") or job.get("created_at"),
    }


def normalize_lever(job):
    job_id = f"lever_{job.get('id')}"
    return {
        "job_id": job_id,
        "title": job.get("title"),
        "company": job.get("company"),
        "location": job.get("location"),
        "salary": None,
        "experience": None,
        "skills": [],
        "job_url": job.get("job_url"),
        "source_portal": "lever",
        "hr_email": None,
        "company_domain": job.get("domain"),
        "posted_on": job.get("created_at") or job.get("updated_at"),
    }
