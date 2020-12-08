#!/usr/bin/env python3

# QT Creator needs a pyproject file listing all files in json format
# however it does not automatically add files
# this utility generates the pyproject file given boundaries and
# resepcting gitignore

from gitignore_parser import parse_gitignore
from lxml import etree as ET

import glob
import json
import os
import sys

# def _parse_gitignore_string(data: str, fake_base_dir: str = None):
#     with patch('builtins.open', mock_open(read_data=data)):
#         success = parse_gitignore(f'{fake_base_dir}/.gitignore', fake_base_dir)
#         return success

include_dirs = [
    "./",
    "./src/",
    "./src/qml/",
    "./src/icons/",
    "./tools/",
]

print("Reading Files")
files = []
for d in include_dirs:
    files += glob.glob(d + "*.*", recursive=True)

print("Reading gitignore")
try:
    ignored = parse_gitignore('./.gitignore')
except Exception:
    pass

print("Filtering Files")
files = list(set(files))  # keep only uniques
filter(lambda s: not ignored(s), files)  # respect gitignore
files.sort()

# remove "./" prefix
# is this  p y t h o n i c  enough for you?
files = [f[2:] if f.startswith("./") else f for f in files]

print("Writing pyproject JSON")
json_files = json.dumps(
    {'files': files},
    sort_keys=True,
    indent=4
)
with open("./ctwUI.pyproject", "w") as f:
    f.write(json_files)

print("Writing qrc XML")
root = ET.Element("RCC")
resource = ET.SubElement(root, "qresource", prefix="/")

for f in files:
    ET.SubElement(resource, "file").text = f

tree = ET.ElementTree(root)
tree.write("./qml.qrc", pretty_print=True)

print("Done!\n")
