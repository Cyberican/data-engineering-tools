#!/usr/bin/env python

import os
import zipfile
from xml.etree import ElementTree as ET
from dataclasses import dataclass

@dataclass
class WordDocManager:    
    
    def getListOfDocs(self, dir_path) -> list:
        results: list = []
        if os.path.isdir(dir_path):
            # Iterate thru directory
            for file in os.listdir(dir_path):
                # Save relative path with location
                filename = os.path.join(dir_path, file)                
                if os.path.isfile(filename):
                    print(f"Found: {filename}")
                    results.append(filename)
        return results
        
    def extractData(self, file_path) -> list:
        """
        Extract the data from specified file path.
        """
        # The namespace is required to correctly traverse the XML tree.
        namespace = '{http://schemas.openxmlformats.org/wordprocessingml/2006/main}'
        paragraphs = []
        # Open the .docx file as a ZIP archive
        with zipfile.ZipFile(file_path) as docx:
            # Extract the XML content of the document
            with docx.open('word/document.xml') as document_xml:
                tree = ET.parse(document_xml)
                root = tree.getroot()
                # Find all paragraphs in the document            
                for paragraph in root.iter(namespace + 'p'):
                    texts = [ node.text for node in paragraph.iter(namespace + 't') if node.text ]
                    if texts:
                        paragraphs.append(''.join(texts))
        return paragraphs

