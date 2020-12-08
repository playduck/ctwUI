#!/usr/bin/env python3
# tool to update all qml imports to the same version as specified in
# ./tools/versions.csv

import csv
import fileinput
import os
import re
import sys

versionsFile = "./tools/versions.csv"
qmlDir = "./src/qml/"

print("gathering qml files")
qmlfiles = [
    f for f in os.listdir(qmlDir) if os.path.isfile(
        os.path.join(
            qmlDir,
            f
        )
    )
]
print(qmlfiles)

# read config csv
print("reading config csv", versionsFile)
versions = dict()
with open(versionsFile) as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=",")
    line_count = 0
    for row in csv_reader:
        if line_count == 0:
            line_count += 1
        else:
            versions[row[0].strip()] = row[1].strip()
            line_count += 1

print("\nVersions")
for v in versions.keys():
    print("\t", v, versions.get(v))
print("\n")

# parse and sub files
print("parsing qml files and updating versions\n")
for f in qmlfiles:
    # with open(os.path.join(qmlDir, f), "r+") as f:
    buffer = list()
    for line in fileinput.input(os.path.join(qmlDir, f), inplace=True):

        match = re.search(
            r"^.*import (\S*)\s*([1-9|\.].*)$",
            line,
            flags=re.M | re.I)

        if match is not None:
            ver = versions.get(match.groups()[0], None)
            if ver is not None:
                if match.groups()[1] != ver:
                    # print("\t", match)
                    buffer.append({
                        "what": match.groups()[0],
                        "from": match.groups()[1],
                        "to": ver
                    })
                    line = line.replace(match.groups()[1], ver)

            # buffer.append((match.groups(), ver))
        print(line, end="")

    # if len(buffer) > 1:
    print("file", f, "updated", len(buffer), "elements")
    for i, b in enumerate(buffer):
        print("\t", b["what"], "from", b["from"], "to", b["to"])
    # else:
        # print("file", f, "all versions correct")

print("done")
