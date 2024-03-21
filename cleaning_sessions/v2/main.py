#!/usr/bin/env python

import os
import time
from utils.FileManager import FileManager
from utils.WordDocManager import WordDocManager



def main():    
    print("Running, conversion program")
    fileManager = FileManager()
    fileManager.createTargetDir()
    fileManager.copyToWorkspace()
    wordDocManager = WordDocManager()
    cleaning_list = wordDocManager.getListOfDocs(fileManager.target_dir)
    for filename in cleaning_list:
        print(wordDocManager.extractData(filename))
        time.sleep(0.5)


if __name__ == "__main__":
    main()
