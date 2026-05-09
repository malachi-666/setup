#!/usr/bin/env python3
import os
import subprocess
import json
import hashlib
from datetime import datetime
import logging

# Configure Logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger("Watchdog")

# Configuration
LOGSEQ_PATH = os.path.expanduser("~/Logseq/pages/Panopticon_Leads.md")
STATE_FILE = "watchdog_state.json"
TARGET_URLS = [
    # Replace with actual target URLs for market scraping
    "https://example.com/market-data",
]

def load_state():
    if os.path.exists(STATE_FILE):
        with open(STATE_FILE, "r") as f:
            try:
                return set(json.load(f))
            except json.JSONDecodeError:
                return set()
    return set()

def save_state(state):
    with open(STATE_FILE, "w") as f:
        json.dump(list(state), f)

def generate_hash(content):
    return hashlib.sha256(content.encode('utf-8')).hexdigest()

def scrape_with_puppeteer(url):
    logger.info(f"Scraping {url} with puppeteer-cli...")
    try:
        # Assuming puppeteer-cli is available in the environment path
        result = subprocess.run(
            ["puppeteer-cli", "print", url],
            capture_output=True,
            text=True,
            check=True,
            timeout=60
        )
        return result.stdout
    except subprocess.CalledProcessError as e:
        logger.error(f"Puppeteer scraping failed for {url}: {e.stderr}")
        return None
    except subprocess.TimeoutExpired:
        logger.error(f"Puppeteer scraping timed out for {url}")
        return None
    except FileNotFoundError:
        logger.error("puppeteer-cli not found. Ensure it is in the system packages.")
        return None

def analyze_with_fabric(content):
    logger.info("Analyzing content with local Qwen model via fabric...")
    try:
        # We use fabric-ai to pipe the content to the local model
        # The prompt asks for OSINT/Arbitrage leads extraction formatted in Markdown
        prompt = "Extract actionable OSINT and market arbitrage leads from this raw HTML dump. Format the output strictly as a concise Markdown list of findings."

        # Fabric CLI command structure: echo "<content>" | fabric -m <model> -p "<pattern/prompt>"
        # Note: We need to handle large content carefully with subprocess

        process = subprocess.Popen(
            ["fabric", "-m", "qwen", "-p", "extract_leads"], # Assuming 'extract_leads' pattern exists, or pass raw text
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        stdout, stderr = process.communicate(input=f"{prompt}\n\n{content}", timeout=120)

        if process.returncode != 0:
            logger.error(f"Fabric analysis failed: {stderr}")
            return None

        return stdout.strip()
    except Exception as e:
        logger.error(f"Error during fabric analysis: {e}")
        return None

def append_to_logseq(findings):
    logger.info(f"Appending findings to {LOGSEQ_PATH}")

    # Ensure directory exists
    os.makedirs(os.path.dirname(LOGSEQ_PATH), exist_ok=True)

    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    markdown_entry = f"\n## Watchdog Scan: {timestamp}\n\n{findings}\n\n---\n"

    try:
        with open(LOGSEQ_PATH, "a") as f:
            f.write(markdown_entry)
        logger.info("Successfully appended to Logseq.")
    except IOError as e:
        logger.error(f"Failed to write to Logseq: {e}")

def main():
    logger.info("Starting Panopticon Watchdog Pipeline...")
    seen_hashes = load_state()
    new_hashes = set()

    for url in TARGET_URLS:
        raw_html = scrape_with_puppeteer(url)
        if not raw_html:
            continue

        content_hash = generate_hash(raw_html)
        if content_hash in seen_hashes:
            logger.info(f"No changes detected for {url} (Hash matched). Skipping.")
            new_hashes.add(content_hash)
            continue

        logger.info(f"New content detected for {url}.")

        # We only want a subset or text version ideally, but sending raw to fabric for demonstration
        # In a real scenario, BS4 might parse it first to reduce token count.

        findings = analyze_with_fabric(raw_html)
        if findings:
            append_to_logseq(findings)
            new_hashes.add(content_hash)
        else:
            # If analysis failed, don't update hash so we try again later
            pass

    # Update state with the newly seen (and still active) hashes
    save_state(new_hashes)
    logger.info("Pipeline completed successfully.")

if __name__ == "__main__":
    main()
