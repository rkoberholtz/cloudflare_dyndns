#!/bin/bash

CLOUDFLARE_API_KEY="API KEY HERE"
AUTH_EMAIL="user@example.com"
#Can be found by logging in to your Cloudflare, click the site/zone, scroll down to the bottom.  You'll see if on the right side
ZONE_ID="ZONE ID NUMBER HERE"
#This can only be gotten by using the API to get a list of records for the zone.
RECORD_ID="<RECORD ID NUMBER HERE"
RECORD_NAME="example.com"
RECORD_TYPE="A"
TTL=1

#Get the current IP address for the DNS record
RECORD_IP="$(dig @1.1.1.1 $RECORD_NAME | grep $RECORD_NAME | grep -v ';' | awk '{ print $5} ')"

IP="$(curl -s http://ipinfo.io/ip 2> /dev/null)"

DATE=$(date +%Y%m%d-%H%M%S)

#If the RECORD_IP and IP do not match, then we need to update the record information.
if [ "$RECORD_IP" != "$IP" ]; then
        RESPONSE=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
                -H "X-Auth-Email: $AUTH_EMAIL" \
                -H "X-Auth-Key: $CLOUDFLARE_API_KEY" \
                -H "Content-Type: application/json" \
                --data '{"type":"$RECORD_TYPE","name":"'$RECORD_NAME'","content":"'$IP'","ttl":'$TTL'}')

        if [ $(echo "$RESPONSE" | grep '"success":true' | wc -l) -eq 1 ]; then
                echo "$DATE|Record IP: $RECORD_IP|Pub IP: $IP|CF Update: Success"
        else
                echo "$DATE|Record IP: $RECORD_IP|Pub IP: $IP|CF Update: Failure"
                echo "Response: $RESPONSE"
        fi
else
        echo "$DATE|Record IP: $RECORD_IP|Pub IP: $IP|CF Update: Skipped"
fi
