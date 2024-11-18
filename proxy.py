from mitmproxy import ctx
from mitmproxy import http
import configparser

config = configparser.ConfigParser()
config.read("proxy.ini")

# Target server
TARGET_SCHEME = config["proxy"]["scheme"]
TARGET_HOST = config["proxy"]["host"]
TARGET_PORT = int(config["proxy"]["port"])

# List of domains to forward
FORWARD_DOMAINS = [
    "yuanshen.com",
    "mihoyo.com",
    "hoyoverse.com",
]

# List of domains to NOT forward
EXCLUDED_DOMAINS = [
    "autopatchhk.yuanshen.com",
]

LOG_KEYWORDS = [
    # "h5log", # minor-api-os.hoyoverse.com
    # "admin", # webstatic.hoyoverse.com
]


def request(flow: http.HTTPFlow) -> None:
    # First check if the request host matches any excluded domains
    if any(flow.request.pretty_host.endswith(domain) for domain in EXCLUDED_DOMAINS):
        ctx.log.warn(f"Skipping forwarding - {flow.request.pretty_url}")
        return
    
    # Log keyword URLs
    if any(keyword in flow.request.pretty_url for keyword in LOG_KEYWORDS):
        ctx.log.warn(f"Keyword URL - {flow.request.pretty_url}")
        
    # Check if the request host contains any of our forward domains
    if any(flow.request.pretty_host.endswith(domain) for domain in FORWARD_DOMAINS):
        
        # Preserve the original URL
        original_url = flow.request.pretty_url
        
        # Update the host header and target
        flow.request.headers["Host"] = flow.request.pretty_host
        flow.request.host = TARGET_HOST
        flow.request.port = TARGET_PORT
        flow.request.scheme = TARGET_SCHEME
        
        ctx.log.info(f"Forwarding request for {original_url} to {TARGET_HOST}:{TARGET_PORT}")
