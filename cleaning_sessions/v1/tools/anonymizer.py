#!/usr/bin/env python

import os
import sys
import subprocess
import argparse

# Configuration
blacklist_file = "config/blacklist.txt"
output_dir = "anonymizer_data"
output_file = os.path.join(output_dir, "ignore_employee_names.txt")


def error(message):
    print(f"\033[35mError:\t\033[31m{message}.\033[0m")
    sys.exit(1)


def extract_value(arg):
    return arg.split(':')[1].split('=')[1]


# Parse command-line arguments
parser = argparse.ArgumentParser()
parser.add_argument("--dir", dest="dirname", type=str, help="Directory name")
args = parser.parse_args()

# Create output directory if it does not exist
os.makedirs(output_dir, exist_ok=True)

if os.path.exists(blacklist_file):
    names = []
    if args.dirname:
        # Perform search and process results
        find_command = f"find {args.dirname} -type f"
        try:
            results = subprocess.check_output(find_command, shell=True, text=True).splitlines()
            for result in results:
                try:
                    with open(result, 'r') as file:
                        for line in file:
                            if "Name" in line:
                                if subprocess.run(["egrep", "-E", "-i", "-f", blacklist_file], input=line, text=True).returncode != 0:
                                    print(line.strip())
                                    if len(line) > 2:
                                        names.append(line.replace(':', '').replace('(', '').replace(')', '').strip())
                except Exception as e:
                    print(f"Error processing file {result}: {e}")
        except subprocess.CalledProcessError as e:
            error(f"Unable to find files in directory {args.dirname}")
        
        # Output results
        if os.path.exists(output_file):
            os.remove(output_file)
        
        with open(output_file, 'a') as f:
            for name in sorted(set(names)):
                f.write(f"{name}\n")
    else:
        error("Directory name not provided")
else:
    error(f"Missing or unable to find file {blacklist_file}")
