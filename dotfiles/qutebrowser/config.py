# Load autoconfig.yml if it exists
config.load_autoconfig(False)

# UI & Dark Mode
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.images = "never"
c.fonts.default_family = "JetBrains Mono"
c.fonts.default_size = "11pt"
c.window.hide_decoration = True
c.tabs.show = "multiple"
c.tabs.position = "top"
c.statusbar.show = "in-mode"

# Ad-blocking
c.content.blocking.enabled = True
c.content.blocking.method = "both"
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt",
    "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=1&mimetype=plaintext",
]

# Intelligence Gathering & Market Arbitrage Custom Searches
c.url.searchengines = {
    'DEFAULT': 'https://duckduckgo.com/?q={}',
    'sh': 'https://www.shodan.io/search?query={}',                 # Shodan IoT Recon
    'gh': 'https://github.com/search?q={}',                        # GitHub code search
    'yt': 'https://www.youtube.com/results?search_query={}',
    'wiki': 'https://en.wikipedia.org/wiki/Special:Search?search={}',
    'osint': 'https://osintframework.com/?q={}',                   # OSINT lookups
    'amz': 'https://www.amazon.com/s?k={}',                        # Arbitrage pricing
    'ebay': 'https://www.ebay.com/sch/i.html?_nkw={}',             # Arbitrage pricing
}

# Bindings customized for heavy keyboard workflow
config.bind('J', 'tab-prev')
config.bind('K', 'tab-next')
config.bind('xx', 'config-cycle statusbar.show always in-mode')
config.bind('xt', 'config-cycle tabs.show always switching')
config.bind(',m', 'spawn mpv {url}')
config.bind(',p', 'spawn puppeteer-cli scrape {url}') # Hook into our watchdog pipeline
config.bind('yy', 'yank')

# Security & Fingerprint overrides
c.content.javascript.clipboard = "access"
c.content.canvas_reading = False
c.content.webrtc_ip_handling_policy = "default-public-interface-only"
