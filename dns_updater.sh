#!/bin/bash
#
#. Description:
#.      This script will keep a CloudFlare DNS record up to date with your current public IP address
#.      It will use 'dig' to query the IP address for the DNS record, then compare that IP to your current public IP.
#.      If the two IP's do not match, the DNS record will be updated with the current IP address via
#.      Cloudfare's API.
#
#. Usage:
#.      Enter your details for the variables below, then schedule this script to run every 15 or 30 min via cron.
#.      The script will output Success/Failure/Skip details that can be easily redirected to a log file.
#
#.      Example Crontab Entry:
#.              */15 *       * * *   root    /path/to/dns_updater.sh >> /var/log/dns_updater.log 2>&1
#
#. Author: Rich Oberholtzer (2/2021)

CLOUDFLARE_API_KEY="API KEY HERE"
AUTH_EMAIL="user@example.com"

#. Can be found by logging in to your Cloudflare account, click the site/zone, scroll down to the bottom.  
#. You'll see it listed on the right side of the page.
ZONE_ID="ZONE ID NUMBER HERE"

#This can only be gotten by using the API to get a list of records for the zone.
#  Reference: https://api.cloudflare.com/#dns-records-for-a-zone-list-dns-records
RECORD_ID="RECORD ID NUMBER HERE"

RECORD_NAME="example.com"
RECORD_TYPE="A"
TTL=1

#Get the current IP address for the DNS record
RECORD_IP="$(dig @1.1.1.1 $RECORD_NAME | grep $RECORD_NAME | grep -v ';' | awk '{ print $5} ')"

# Get the current public IP address
IP="$(curl -s http://ipinfo.io/ip 2> /dev/null)"

DATE=$(date +%Y%m%d-%H%M%S)

#If the RECORD_IP and IP do not match, then we need to update the record information.
if [ "$RECORD_IP" != "$IP" ]; then

        # Make the API call to update the DNS record and save the response details for confirmation of success/failure.
        RESPONSE=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
                -H "X-Auth-Email: $AUTH_EMAIL" \
                -H "X-Auth-Key: $CLOUDFLARE_API_KEY" \
                -H "Content-Type: application/json" \
                --data '{"type":"$RECORD_TYPE","name":"'$RECORD_NAME'","content":"'$IP'","ttl":'$TTL'}')
        
        # Output appropriate status details depending on whether or not the API call was successful or not
        # If it failed, we want dump out the entire response for troubleshooting. 
        if [ $(echo "$RESPONSE" | grep '"success":true' | wc -l) -eq 1 ]; then
                echo "$DATE|Record IP: $RECORD_IP|Pub IP: $IP|CF Update: Success"
        else
                echo "$DATE|Record IP: $RECORD_IP|Pub IP: $IP|CF Update: Failure"
                echo "Response: $RESPONSE"
        fi
else
        # The current public IP address matches the IP address for the DNS record.  
        # There is nothing to do, yay!
        echo "$DATE|Record IP: $RECORD_IP|Pub IP: $IP|CF Update: Skipped"
fi
