import requests
from bs4 import BeautifulSoup
from datetime import datetime
import time


def get_meta_image(soup, source="Wired"):
    """
    Try to extract a site-wide or Open Graph image for fallback, with source-specific defaults.
    """
    meta = soup.find("meta", property="og:image")
    if meta and meta.get("content"):
        return meta["content"]

    placeholders = {
        "TechCrunch": "https://picsum.photos/300/200?random=1",
        "The Verge": "https://picsum.photos/300/200?random=2",
        "Wired": "https://picsum.photos/300/200?random=3",
    }
    return placeholders.get(source, "https://picsum.photos/300/200?random=0")


def get_full_article_wired(url):
    """
    Fetch and extract the full text of a Wired article.
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

        # Wired articles usually contain <div class="body__inner-container"> or <article> with <p>
        content_blocks = article_soup.select(
            "div.body__inner-container p, article p, div.article__chunks p"
        )
        if not content_blocks:
            content_blocks = article_soup.select("p")

        full_text = " ".join([p.get_text(strip=True) for p in content_blocks])
        return full_text.strip() or "Full content could not be loaded."

    except Exception as e:
        print(f"Error fetching full article from {url}: {e}")
        return "Full content could not be loaded."


def scrape_wired():
    """
    Scrape latest full Wired articles with detailed descriptions.
    """
    url = "https://www.wired.com/"
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

        # Wired homepage headlines often in h2 a
        for item in soup.select("h2 a"):
            title = item.get_text(strip=True)
            link = item.get("href")

            # Normalize link
            if link and link.startswith("/"):
                link = "https://www.wired.com" + link

            # Validate
            if not (title and link and link.startswith("https://www.wired.com/")):
                continue

            # Try to find nearby image
            parent_article = item.find_parent("article")
            image_el = parent_article.find("img") if parent_article else None
            image = image_el.get("src") if image_el and image_el.get("src") else None
            if not image:
                image = get_meta_image(soup, source="Wired")

            # Fetch the full content of the article
            full_content = get_full_article_wired(link)

            articles.append({
                "source": "Wired",
                "title": title,
                "content": full_content,
                "link": link,
                "image": image,
                "timestamp": datetime.now().isoformat()
            })

            # Add short delay to avoid hitting Wired’s servers too fast
            time.sleep(1)

        return articles

    except requests.RequestException as e:
        print(f"Error fetching Wired homepage: {e}")
        return []
    except Exception as e:
        print(f"Unexpected error in Wired scraper: {e}")
        return []


# Example usage
if __name__ == "__main__":
    data = scrape_wired()
    for i, article in enumerate(data[:3], 1):
        print(f"\n[{i}] {article['title']}")
        print(article["content"][:600], "...\n")
