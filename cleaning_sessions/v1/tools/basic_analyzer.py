#!/usr/bin/env python

import os
import string
import re
import time
import pandas as pd
import numpy as np
import argparse

# cat * | tr ' ' '\n' | tr -d [:punct:] | sort -u


def remove_special_chars(text: str):
    regex = re.compile(r'[^\w\s]|[\U00010000-\U0010ffff]', re.UNICODE)
    clean_text = regex.sub('', text)
    return clean_text

def extract_all_words(dirname: str):
    # Read all files in the current directory
    all_texts = []
    print(f"Setting target directory to {dirname} to scan\n")
    if os.path.exists(dirname):
        print("scanning...")
        for filename in os.listdir(dirname):
            # define the relative path
            relpath = f"{dirname}/{filename}"
            if os.path.isfile(relpath):
                with open(relpath, 'r') as file:
                    all_texts.append(file.read())

        # Combine texts, replace spaces with newlines, and remove punctuation
        combined_text = ' '.join(all_texts)
        words = combined_text.split()
        words_no_punct = [ word.translate(str.maketrans('', '', string.punctuation)) for word in words ]
        # Sort and remove duplicates
        unique_words = sorted(set(words_no_punct))
        # Print the result
        for word in unique_words:
            print(remove_special_chars(word))

parser = argparse.ArgumentParser( prog='Basic Analyzer',
                    description='Analyze the content',
                    epilog=':: help')
parser.add_argument('-d', '--dirname')

args = parser.parse_args()
dirname = args.dirname
if dirname:
    extract_all_words(dirname=dirname)
else:
    print("\033[35mError: \033[31mMissing dirname parameter!\033[0m")

