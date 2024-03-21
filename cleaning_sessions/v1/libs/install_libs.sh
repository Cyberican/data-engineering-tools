#!/bin/bash

sudo pip install chardet
sudo pip install PyPDF2
sudo pip install packaging
if [ -f "unoconv-python-3.12" ];
then
    sudo cp -a -v unoconv-python-3.12 /usr/bin/unoconv
fi
