import sys
import os
import subprocess

def escape(s: str) -> str:
    return "\""+s+"\""

def convert(flags, binary=None, logfile=None, callback=lambda: None):
    if binary is None or binary == "":
        binary = "./ctw-core/ctw-core"
        if not sys.platform.startswith("darwin"):
            binary = "."+binary+".exe"
        binary = os.path.abspath(binary)

    if logfile is None or logfile == "":
        logfile = ""
    else:
        logfile = "> "+logfile

    command = [
        binary,
        "--seperator", escape(flags["inputSeperator"]),
        "--decimal", escape(flags["inputDecimal"]),

        "--gen-x" if flags["inputGenX"] else "",

        "--bits-per-sample", flags["inputBPS"],
        "--samplerate", flags["inputSamplerate"],
        "--max "+ flags["inputMax"] if flags["inputMax"] != "None" else "",
        "--bias", flags["inputBias"],
        "--clipping", flags["inputClipping"],
        "--interpolation", flags["inputInterpolation"],
        "--multichannel" if flags["inputMultichannel"] else "",

        "--log-level", "debug",

        escape(flags["inputFile"]),
        escape(flags["outputFile"]),

        logfile
    ]

    command_str = ""
    for c in command:
        command_str += " " + c

    try:
        # os.system(command_str)
        complete = subprocess.run(command_str, shell=True)
    except Exception as e:
        print("Exception occured")
        print(e)
    finally:
        callback(complete.returncode)
        return
