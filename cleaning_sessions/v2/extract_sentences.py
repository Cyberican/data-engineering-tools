#!/usr/bin/env python3

import os
import re
import subprocess

def remove_date_lines(input_file, output_file):
    # 01/2015 - 05/2016
    # date_pattern = re.compile(r'^\d{4}-\d{2}-\d{2}$')  # Regular expression for 'YYYY-MM-DD'
    date_pattern = re.compile(r'^\d{2}/\d{4}\s*–\s*\d{2}/\d{4}$')  # Regular expression for 'YYYY-MM-DD'
    try:
        with open(input_file, 'r', encoding='utf-8') as infile, open(output_file, 'w', encoding='utf-8') as outfile:
            for line in infile:
                if not date_pattern.match(line.strip()):  # Check if the line is only a date
                    outfile.write(line)  # Write non-date lines to the output file
            print("File processed successfully.")
    except FileNotFoundError:
        print("The input file was not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

def extract_sentences(filename):
    try:
       sentences = list()
       with open(filename, 'r', encoding='utf-8') as file:
            text = file.readlines()
            # Regular expression to split the text into sentences
            for t in text:
                word_count = len(t.split(' '))
                if not ':' in t and word_count > 2:
                    sentences.append(re.split(r'(?<=[.!?]) +', t))
            return sentences
    except FileNotFoundError:
        print("The file was not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

# source dataset
filename = "input.txt"
target_file = "cleaning/sentence_extraction.txt"
if os.path.exists(target_file):
    os.remove(target_file)
clean_sentences = extract_sentences(filename)
fp = open(target_file, "a")

if clean_sentences:
    for i, sentence in enumerate(clean_sentences):
        sentence = " ".join(sentence)
        fp.writelines(sentence)
        print(f"Sentence {i+1}: {sentence}")
fp.close()

# Example usage
output_file = 'output.txt'
if os.path.exists(output_file):
    os.remove(output_file)
if not os.path.exists(output_file):
    remove_date_lines(target_file, output_file)


