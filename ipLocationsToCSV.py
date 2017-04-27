import urllib.request
import json
import csv
import sys

id = '600'
key = "7c9f5bae7bfee5379cb6584f64fbdb891c114e53"
infile = id+'_logincounts.csv'
outfile = id+'_locations.csv'


def getIpLocation(key, ipAddress):
    with urllib.request.urlopen("http://api.db-ip.com/v2/"+key+"/"+ipAddress) as url:
        responseRaw = url.read()
    response = json.loads(responseRaw)
    return(response)


ipList = []

with open(infile) as csvfile:
    reader = csv.reader(csvfile)
    for row in reader:
        if(len(row) == 13):
            visits = row[1]
            container = row[8]
            ip = row[12]

            ipDict = {}
            ipDict['ip'] = ip
            ipDict['returned'] = (int(visits) > 1)
            ipDict['container'] = container
            ipList.append(ipDict)

with open(outfile, 'w') as csvfile:
    writer = csv.writer(csvfile)

    for ipDict in ipList:

        response = getIpLocation(key, ipDict['ip'])
        if 'error' in response:
            print(response['error'])
            sys.exit(1)
        else:
            row = []

            try:
                row.append(ipDict['ip'])
                row.append(ipDict['returned'])
                row.append(response["continentCode"])
                row.append(response["countryName"])

                writer.writerow(row)
                csvfile.flush()
            except Exception:
                print('skipping '+ipDict['ip'])
