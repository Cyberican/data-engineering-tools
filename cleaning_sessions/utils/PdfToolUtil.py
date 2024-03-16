#!/usr/bin/env python

import os
import PyPDF2
import re
from dataclasses import dataclass

@dataclass
class PdfToolUtil:
    # Replace 'example.pdf' with the path to your PDF file
    pdf_path: str

    def read_pdf_data(self) -> list:
        pattern = r"[\uf0b7\u2022\u00B7\u2023\f]"
        container = []
        print(self.pdf_path)
        with open(self.pdf_path, 'rb') as pdf_file:
            pdf_reader = PyPDF2.PdfReader(pdf_file)
            for page_num in range(len(pdf_reader.pages)):
                page = pdf_reader.pages[page_num]
                cleaned_text = re.sub(pattern, " ", page.extract_text(), flags=re.MULTILINE)
                container.append(cleaned_text)
        return " ".join(container)

    def write_to_file(self):
        if os.path.exists(self.pdf_path):
            target_file = self.pdf_path.replace('.pdf','.txt')
            with open(target_file, "w") as filename:
                filename.write(self.read_pdf_data())
