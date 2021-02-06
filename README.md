*** This project lives at https://gitlab.rickelobe.com/Scripts/cloudflare-dns-updater ***

# Description
This script will keep a CloudFlare DNS record up to date with your current public IP address.  It will use 'dig' to query the IP address for the DNS record, then compare that IP to your current public IP.  If the two IP's do not match, the DNS record will be updated with the current IP address via Cloudfare's API.
