#!/usr/bin/env python

import os
import time
from utils.FileManager import FileManager
from utils.WordDocManager import WordDocManager

input_file = "input.txt"

def main():
    print("Running, conversion program")
    fileManager = FileManager()
    fileManager.createTargetDir()
    fileManager.copyToWorkspace()
    wordDocManager = WordDocManager()
    cleaning_list = wordDocManager.getListOfDocs(fileManager.target_dir)
    for filename in cleaning_list:
        with open(input_file, "+a") as data_file:
            print(f"Writing data to {input_file}...")
            for data in wordDocManager.extractData(filename):
                data_file.writelines(f"{data}\n")
            print("Done!")
        time.sleep(0.5)

if __name__ == "__main__":
    main()
