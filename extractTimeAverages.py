import csv
import os

include_single_entry = False
include_multiple_entry = True

logfile = open(os.path.join("data","all.csv"), "rb")
reader = csv.reader(logfile)

for row in reader:
    # Column associations
    path_col = 0
    ip_addr_col = 1
    num_logins_col = 3

    num_logins = int(row[num_logins_col])

    if (num_logins == 1 and not include_single_entry) or (num_logins > 1 and not include_multiple_entry):
        continue

    total_time = 0
    for i in range(num_logins_col+1, num_logins_col+1+num_logins):
        total_time += int(row[i])


    total_commands = 0
    for i in range(num_logins_col+1+num_logins, num_logins_col+1+num_logins+num_logins):
        total_commands += int(row[i])

    average_time = float(total_time) / num_logins
    average_commands = float(total_commands) / num_logins

    print(str(average_time)+", "+str(average_commands))

