#!/bin/bash

clear

# Prompt for API key information

echo -n "Enter your API key and press [ENTER]: "
read apikey
echo
echo -n "Enter your API secret and press [ENTER]: "
read apisecret

# Alternately, you can assign your keys to variables as below, or read in from a file, etc.  Be mindful of security.
# apikey="yourkeyhere"
# apisecret="yoursecrethere"

# Construct URI and fetch current balance

nonce=$(date +%s)
uri="https://bittrex.com/api/v1.1/account/getbalance?apikey=$apikey&nonce=$nonce&currency=BTC"
sign=$(echo -n "$uri" | openssl dgst -sha512 -hmac "$apisecret")
btcbalanceraw=$(curl -s -H "apisign: $sign" $uri)
btcbalance=$(echo $btcbalanceraw | jq -r .result.Balance)

# Fetch current network fee

feebtc=$(curl -s "https://bittrex.com/api/v1.1/public/getcurrencies" | jq '.result[] | select(.Currency == "BTC") | .TxFee')

echo
echo -e "Current Bitcoin Balance is:\t$btcbalance BTC"
echo -e "Current Bitcoin TxFee is:\t$feebtc BTC"
echo
echo
echo -n "Enter (or paste in) the destination BTC address and press [ENTER] (or press ctrl-c to cancel): "
read btcdestination
echo -n "Enter the amount of BTC to transfer and press [ENTER] (or press ctrl-c to cancel): "
read xferamount


echo
echo "Transferring $xferamount BTC to $btcdestination"

nonce=$(date +%s)
uri="https://bittrex.com/api/v1.1/account/withdraw?apikey=$apikey&nonce=$nonce&currency=BTC&quantity=$xferamount&address=$btcdestination"
sign=$(echo -n "$uri" | openssl dgst -sha512 -hmac "$apisecret")
echo $uri
curl -X POST -H "apisign: $sign" $uri -d "Content-Length: 0"
