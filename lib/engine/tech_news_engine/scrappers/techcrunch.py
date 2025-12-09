import requests
from bs4 import BeautifulSoup
from datetime import datetime
import time


def get_meta_image(soup, source="TechCrunch"):
    """
    Try to extract a site-wide or Open Graph image for fallback, with source-specific defaults.
    """
    meta = soup.find("meta", property="og:image")
    if meta and meta.get("content"):
        return meta["content"]
    placeholders = {
        "TechCrunch": "https://picsum.photos/300/200?random=1",
        "The Verge": "https://picsum.photos/300/200?random=2",
        "Wired": "https://picsum.photos/300/200?random=3"
    }
    return placeholders.get(source, "https://picsum.photos/300/200?random=0")


def get_full_article(url):
    """
    Fetch and extract the full text of a TechCrunch article.
    """
    headers = {
        "User-Agent": (
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
            "AppleWebKit/537.36 (KHTML, like Gecko) "
            "Chrome/91.0.4472.124 Safari/537.36"
        )
    }

    try:
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()
        article_soup = BeautifulSoup(response.text, "html.parser")

        # Extract paragraphs from the main article body
        content_blocks = article_soup.select("div.article-content p, div.article__content p")
        if not content_blocks:
            content_blocks = article_soup.select("p")

        full_text = " ".join([p.get_text(strip=True) for p in content_blocks])
        return full_text.strip()

    except Exception as e:
        print(f"Error fetching full article from {url}: {e}")
        return "Full content could not be loaded."


def scrape_techcrunch():
    """
    Scrape latest full TechCrunch articles with detailed descriptions.
    """
    url = "https://techcrunch.com/"
    headers = {
        "User-Agent": (
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
            "AppleWebKit/537.36 (KHTML, like Gecko) "
            "Chrome/91.0.4472.124 Safari/537.36"
        )
    }

    try:
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, "html.parser")

        articles = []

        for item in soup.select("h3 a"):
            title = item.get_text(strip=True)
            link = item.get("href")

            if not (title and link and link.startswith("https://techcrunch.com/")):
                continue

            parent_article = item.find_parent("article")
            image_el = parent_article.find("img") if parent_article else None
            image = image_el.get("src") if image_el and image_el.get("src") else None
            if not image:
                image = get_meta_image(soup, source="TechCrunch")

            # Fetch full article content
            full_content = get_full_article(link)

            articles.append({
                "source": "TechCrunch",
                "title": title,
                "content": full_content,
                "link": link,
                "image": image,
                "timestamp": datetime.now().isoformat()
            })

            # Add a small delay to avoid overwhelming the site
            time.sleep(1)

        return articles

    except requests.RequestException as e:
        print(f"Error fetching TechCrunch homepage: {e}")
        return []
    except Exception as e:
        print(f"Unexpected error in TechCrunch scraper: {e}")
        return []


if __name__ == "__main__":
    data = scrape_techcrunch()
    for i, article in enumerate(data[:3], 1):
        print(f"\n[{i}] {article['title']}")
        print(article["content"][:600], "...\n")
