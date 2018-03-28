#!/usr/bin/env bash

HOME=/root
LOGNAME=root
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LANG=en_US.UTF-8
SHELL=/bin/sh
PWD=/root

printf "{\n" >> data.json

printf "\"serialNum\": \"" >> data.json

# get serial number
system_profiler SPPowerDataType | grep "Serial Number" | awk '{print $3}' | head -n1 | cut -d " " -f1 | xargs echo -n >> data.json

printf "\",\n\"laptopId\": \"" >> data.json

# get device id
ioreg -l | grep "IOPlatformSerialNumber" | awk '{print $4}' | xargs echo -n >> data.json

printf "\",\n\"rCap\": " >> data.json

# get rated design capacity
ioreg -l -w0 | grep "DesignCapacity" | awk '{print $5}' | xargs echo -n >> data.json

printf ",\n\"mCap\": " >> data.json

# get current full charge capacity
system_profiler SPPowerDataType | grep "Full Charge Capacity" | awk '{print $5}' | xargs echo -n >> data.json

printf ",\n\"cycles\": " >> data.json

# get cycle count
system_profiler SPPowerDataType | grep "Cycle Count" | awk '{print $3}' | xargs echo -n >> data.json

printf ",\n\"is_software\": true" >> data.json

printf "\n}\n" >> data.json

# POST with RESTful HTTP
# curl -X POST -d @filename http://hostname/resource
curl -d "@data.json" -X POST -H "Content-Type: application/json" https://batterydiagnostics.herokuapp.com/api/battery

# remove data.json
rm data.json

printf "\n"

echo "Battery Report Delivered"
