#!/bin/bash

CLOUDFLARE_API_KEY="API KEY HERE"
AUTH_EMAIL="user@example.com"
#Can be found by logging in to your Cloudflare, click the site/zone, scroll down to the bottom.  You'll see if on the right side
ZONE_ID="ZONE ID NUMBER HERE"
#This can only be gotten by using the API to get a list of records for the zone.
RECORD_ID="<RECORD ID NUMBER HERE"
RECORD_NAME="example.com"

IP="$(curl http://ipinfo.io/ip 2>/dev/null)"

echo "Current IP Address: $IP"

curl -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
        -H "X-Auth-Email: $AUTH_EMAIL" \
        -H "X-Auth-Key: $CLOUDFLARE_API_KEY" \
        -H "Content-Type: application/json" \
        --data '{"type":"A","name":"$RECORD_NAME","content":"'$IP'","ttl":1}'
