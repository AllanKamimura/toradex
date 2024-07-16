#!/bin/bash

print() {
    echo -e $1
}

# Step 1: Get the provision code
response1=$(curl -s https://app.torizon.io/api/provision-code)
provisionUuid=$(echo $response1 | jq -r '.provisionUuid')
provisionCode=$(echo $response1 | jq -r '.provisionCode')

print '\nProvision Code: '"$provisionCode"'\nUse this code to pair this device on https://pair.torizon.io\n'

# Timer
while true; do
    sleep 5
    response2=$(curl -s -G -d "provisionUuid=$provisionUuid" https://app.torizon.io/api/provision-code)
    access=$(echo $response2 | jq -r '.access')
    if [ "$access" != "null" ]; then
        break
    fi
done

# Step3: Run the cloud provisioning script
curl -fsSL https://app.torizon.io/statics/scripts/provision-device.sh | sudo bash -s -- -t "${access}"
