import os
import sys
import subprocess

# A subprocess of pip
subprocess.call(['apt','update'])
subprocess.check_call([sys.executable, '-V'])
# Out with an API in the subprocess mod
requirements = subprocess.check_output([sys.executable, '-m', 'pip', 'freeze'])
# installed_pkgs = [ req.decode().split('==')[0] for req in requirements.split()]
# print(installed_pkgs)
subprocess.check_call([sys.executable, '-V'])
