import os
import shutil
from pathlib import Path
from dataclasses import dataclass


@dataclass
class FileManager():
    initial_dataset: str = "initial_dataset"
    target_dir: str  = "cleaning"

    def createTargetDir(self):
        # Create the target directory if it doesn't exist
        if not os.path.exists(self.target_dir):
            os.makedirs(self.target_dir, exist_ok=True)

    def copyToWorkspace(self):
        # Find all .docx files in the initial_dataset directory
        for filepath in Path(self.initial_dataset).rglob('*.docx'):
            if os.path.isfile(filepath):
                # Construct the new filename by removing spaces
                new_filename = filepath.name.replace(' ', '')
                # Construct the full target path for the file
                target_path = os.path.join(self.target_dir, new_filename)
                # Copy the file to the target directory
                shutil.copy2(filepath, target_path)
                print(f"Copied {filepath} to {target_path}")
