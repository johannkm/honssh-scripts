import csv

infile = "data/all.csv"
outfile = "data/commandsVsTime.csv"

ranCommandsCount = 0
ranCommandsTime = 0

ranNoCommandsCount = 0
ranNoCommandsTime = 0


with open(infile) as csvfile:
    reader = csv.reader(csvfile)

    with open(outfile, 'w') as csvfile:
        writer = csv.writer(csvfile)

        for row in reader:
            if (len(row) >= 6):

                for i in range(0, int(row[3])):

                    time = int(row[i+4])
                    commands = int(row[i+4+int(row[3])])

                    writeRow = []
                    writeRow.append(commands)
                    writeRow.append(commands!=0)
                    writeRow.append(time)

                    writer.writerow(writeRow)
                    print(writeRow)
