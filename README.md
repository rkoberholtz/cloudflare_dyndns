This project lives at [https://gitlab.rickelobe.com](https://gitlab.rickelobe.com/Scripts/cloudflare-dns-updater)

# Description
Use this script to keep a CloudFlare DNS record up to date with your current public IP address.  

When executed, the script will perform a lookup on the DNS record and compare the result with your current public IP.  If the record does not match your current IP, the record will be updated using Cloudflare's API.  

# Prerequisites

- Cloudflare managed DNS and Account
- Linux host to run the script within your network


Example Output:
```
root@www:/Scripts# ./dns_updater.sh
20210715-121018|Record IP: <REDACTED>|Pub IP: <REDACTED>|CF Update: Skipped
```
