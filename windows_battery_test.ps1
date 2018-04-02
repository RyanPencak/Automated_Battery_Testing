## Create a battery report in xml format
powercfg /batteryreport /output "./battery_report.txt" /xml

## Check computer chassis type and exit if desktop
# $chassis = Get-WmiObject win32_systemenclosure -
# if ($chassis.chassistypes -contains '3'){exit 1}

## Use findstr to get desired information
$serialNumber = findstr "<SerialNumber>" ./battery_report.txt
$deviceID = findstr "<ComputerName>" ./battery_report.txt
$ratedCap = findstr "<DesignCapacity>" ./battery_report.txt
$measuredCap = findstr "<FullChargeCapacity>" ./battery_report.txt
$cycles = findstr "<CycleCount>" ./battery_report.txt


## Remove HTML tags
$serialNumber = $serialNumber.Replace("<SerialNumber>","")
$serialNumber = $serialNumber.Replace("</SerialNumber>","")

$deviceID = $deviceID.Replace("<ComputerName>","")
$deviceID = $deviceID.Replace("</ComputerName>","")

$ratedCap = $ratedCap.Replace("<DesignCapacity>","")
$ratedCap = $ratedCap.Replace("</DesignCapacity>","")
$ratedCap = $ratedCap.Replace("<DesignCapacity>","")

$measuredCap = $measuredCap.Replace("<FullChargeCapacity>","")
$measuredCap = $measuredCap.Replace("</FullChargeCapacity>","")
$measuredCap = $measuredCap.Replace("<FullChargeCapacity>","")

$cycles = $cycles.Replace("<CycleCount>","")
$cycles = $cycles.Replace("</CycleCount>","")


## Set battery data to JSON format
$batteryData = '{ "serial_number": "' + $serialNumber + '", "device_id": "' + $deviceID + '", "rated_capacity": ' + $ratedCap + ', "measured_capacity": ' + $measuredCap + ', "cycle_count": ' + $cycles + ', "is_software": true }'


## Define POST information
$uri = "https://batterydiagnostics.herokuapp.com/api/battery"
$contentType = "application/json"


## HTTP Post data.json to server
Invoke-WebRequest -Uri $uri -Method POST -ContentType $contentType -Body $batteryData


## Delete previous data files
Remove-Item –path ./battery_report.txt –recurse
