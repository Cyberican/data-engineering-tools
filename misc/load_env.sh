#!/bin/bash -x

source ./temp/bin/activate
curl https://bootstrap.pypa.io/pip/3.6/get-pip.py -o get-pip.py
python get-pip.py
pip --version
python ./installer.py
deactivate
