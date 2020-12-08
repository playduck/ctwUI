from pathlib import Path

import os
import sys
import json


print(sys.version)
if getattr(sys, 'frozen', False):
    print("\nFrozen!", Path(sys._MEIPASS), "\n")


def getResource(path: str) -> str:
    if getattr(sys, 'frozen', False):
        root = Path(sys._MEIPASS)  # sys has attribute if it's frozen
    else:
        root = Path()
    f = os.path.join(root, path)
    return str(f)

configPath = getResource("./ctw_config.json")

def saveConfig(bridge):
    data = {
        "binary": bridge._binary,
        "logfile": bridge._logfile
    }
    print(data)
    with open(configPath, 'w') as outfile:
        json.dump(data, outfile)

def loadConfig() -> dict:
    try:
        with open(configPath) as json_file:
            data = json.load(json_file)
    except Exception:
        data = {
            "binary": None,
            "logfile": None
        }
    finally:
        return data
