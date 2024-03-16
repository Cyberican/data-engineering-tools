#!/usr/bin/env python

import os
import re
import shutil
import psutil
import subprocess
import chardet
from dataclasses import dataclass


@dataclass
class DocToPdfConverter:
    """ Convert DOC to PDF """
    # For Development and Testing
    # Note: setting this value to 0
    # will convert all files
    stop_loop: int
    # Container for initial datasets
    main_dir: str
    # The workspace for cleaning files
    target_dir: str
    # Create target filename and remove special characters
    def clean_filename(self, filename):
        cleaned_filename = lambda word: ''.join(c for c in word if c.isalnum() or c == '.')
        return cleaned_filename(filename)

    def flush_session_files(self, doc_filename, pdf_filename):
        session_files = [ doc_filename, pdf_filename ]
        for session_file in session_files:
            os.remove(f"{session_file}")

    # Converts docx to pdf file
    def docx_to_pdf(self, filename):
        if os.path.exists(filename):
            parameters = "--doctype doc"
            os.system(f"doc2pdf {parameters} {filename}")
        else:
            print(f"No file name {filename} exists")

    # Copy initial dataset to cleaning directory
    def copy_data(self, src_path):
        limit = 0
        if not os.path.exists(self.target_dir):
            os.mkdir(self.target_dir)
        for src in src_path:
            # Clean-up filename before copying
            cleaned_file_basename = self.clean_filename(os.path.basename(src))
            target_path = os.path.join(self.target_dir, cleaned_file_basename)
            # Clean-up docx
            if not os.path.exists(f"{target_path}"):
                print(target_path)
                shutil.copy2(src, target_path)
            else:
                print("Already clean file.")
            # Convert docx to pdf
            if not os.path.exists(f"{target_path.replace('.docx','.pdf')}"):
                self.docx_to_pdf(target_path)
            else:
                print("Already converted file.")
            print(limit, self.stop_loop)
            limit += 1
            if limit == self.stop_loop and self.stop_loop != 0:
                break
    # Locate dataset in cleaning directory
    def find_docx_files(self, src_path) -> list:
        isDoc = lambda x: x.endswith('.docx')
        origfiles = [ os.path.join(root, file) for root, dirs, files in os.walk(src_path) for file in files if isDoc(file) ]
        return origfiles


