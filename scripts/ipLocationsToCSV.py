import urllib.request
import json
import csv
import sys

id = "600"
infile = "data/" + id + ".csv"
outfile = "data/" + id + "_location.csv"

key = "ba502337d6fbe5aba5c3a2866164490786f73132"

with open(infile) as csvfile:
    reader = csv.reader(csvfile)

    with open(outfile, 'w') as csvfile:
        writer = csv.writer(csvfile)

        for readRow in reader:
            if (len(readRow) >= 6):
                ip = readRow[1]

                with urllib.request.urlopen("http://api.db-ip.com/v2/"+key+"/"+ip) as url:
                    responseRaw = url.read()
                response = json.loads(responseRaw)

                if 'error' in response:
                    print(response['error'])
                    sys.exit(1)
                else:
                    writeRow = []

                    writeRow.append(readRow[0])
                    writeRow.append(readRow[1])
                    writeRow.append(response["continentCode"])
                    writeRow.append(response["countryName"])
                    writeRow.append(int(readRow[3])>1)

                    for i in range(2, len(readRow)):
                        writeRow.append(readRow[i])

                    writer.writerow(writeRow)
                    print(writeRow)
