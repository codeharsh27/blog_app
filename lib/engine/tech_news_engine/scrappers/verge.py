import requests
from bs4 import BeautifulSoup
from datetime import datetime
import time


def get_meta_image(soup, source="The Verge"):
    """
    Try to extract a site-wide or Open Graph image for fallback, with source-specific defaults.
    """
    meta = soup.find("meta", property="og:image")
    if meta and meta.get("content"):
        return meta["content"]
    # Source-specific faster-loading placeholder images
    placeholders = {
        "TechCrunch": "https://picsum.photos/300/200?random=1",
        "The Verge": "https://picsum.photos/300/200?random=2",
        "Wired": "https://picsum.photos/300/200?random=3"
    }
    return placeholders.get(source, "https://picsum.photos/300/200?random=0")


def get_full_article_verge(url):
    """
    Fetch and extract the full text of a Verge article.
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

        # Verge article paragraphs are typically inside <div class="duet--article--body"> or similar
        content_blocks = article_soup.select(
            "div.duet--article--body p, div.c-entry-content p"
        )
        if not content_blocks:
            content_blocks = article_soup.select("p")

        # Combine all paragraphs
        full_text = " ".join([p.get_text(strip=True) for p in content_blocks])
        return full_text.strip() or "Full content could not be loaded."

    except Exception as e:
        print(f"Error fetching full article from {url}: {e}")
        return "Full content could not be loaded."


def scrape_verge():
    """
    Scrape latest full articles from The Verge.
    """
    url = "https://www.theverge.com/tech"
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

        # Common selectors for Verge articles
        selectors = [
            "article h2 a",
            "h2 a",
            "a[href*='/tech/']"
        ]

        for selector in selectors:
            if articles:
                break  # stop when we already have found some

            for item in soup.select(selector):
                title = item.get_text(strip=True)
                link = item.get("href")

                # Normalize relative links
                if link and link.startswith("/"):
                    link = "https://www.theverge.com" + link

                # Skip irrelevant links
                if not (title and link and link.startswith("https://www.theverge.com/") and "/tech/" in link):
                    continue

                parent_article = item.find_parent("article")
                image_el = parent_article.find("img") if parent_article else None
                image = image_el.get("src") if image_el and image_el.get("src") else None
                if not image:
                    image = get_meta_image(soup, source="The Verge")

                # Fetch the full article text
                full_content = get_full_article_verge(link)

                articles.append({
                    "source": "The Verge",
                    "title": title,
                    "content": full_content,
                    "link": link,
                    "image": image,
                    "timestamp": datetime.now().isoformat()
                })

                # Wait between requests to be polite
                time.sleep(1)

        return articles

    except requests.RequestException as e:
        print(f"Error fetching The Verge: {e}")
        return []
    except Exception as e:
        print(f"Unexpected error in Verge scraper: {e}")
        return []


# Example usage
if __name__ == "__main__":
    data = scrape_verge()
    for i, article in enumerate(data[:3], 1):
        print(f"\n[{i}] {article['title']}")
        print(article["content"][:600], "...\n")
