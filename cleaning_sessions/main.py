#!/usr/bin/env python

import os
import shutil
import psutil
import subprocess
from utils.DocToPdfConverter import DocToPdfConverter
from utils.PdfToolUtil import PdfToolUtil

# Set a limit or 0 for all
stop_loop: int = 0
# Container for initial datasets
main_dir: str = "initial_dataset"
# The workspace for cleaning files
target_dir: str = "cleaning"

if __name__ == '__main__':
    docToPdfConverter = DocToPdfConverter(stop_loop=stop_loop, main_dir=main_dir, target_dir=target_dir)
    find_docx = lambda dirname: docToPdfConverter.find_docx_files(dirname)[:stop_loop] if stop_loop else docToPdfConverter.find_docx_files(dirname)

    # Copying files from main directory to workspace
    file_list = find_docx(main_dir)
    docToPdfConverter.copy_data(file_list)
    # Cleaning on the main directory data
    session_files = find_docx(target_dir)
    print(file_list)

    # Generate text files
    container = []
    for filename in session_files:
        pdf_filename = filename.replace('.docx','.pdf')
        pdfToolUtil = PdfToolUtil(pdf_path=pdf_filename)
        pdfToolUtil.write_to_file()
