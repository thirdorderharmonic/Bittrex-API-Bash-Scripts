#!/bin/bash

# Prompt for API key information

echo -n "Enter your API key and press [ENTER]: "
read apikey
echo
echo -n "Enter your API secret and press [ENTER]: "
read apisecret

# Alternately, you can assign your keys to variables as below, or read in from a file, etc.
# apikey="yourkeyhere"
# apisecret="yoursecrethere"


# Construct URI.  See Bittrex API Documentation for additional options

nonce=$(date +%s)
uri="https://bittrex.com/api/v1.1/account/getbalances?apikey=$apikey&nonce=$nonce"
sign=$(echo -n "$uri" | openssl dgst -sha512 -hmac "$apisecret" | awk '{print $2}')

# GET request on URI and parse resultant json using jq

balancesraw=$(curl -s -H "apisign: $sign" $uri)
echo $balancesraw | jq -r '.result[]'

