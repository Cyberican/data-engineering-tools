import os
import time
import re

dirname = 'example_files'
blacklist = ['WA', 'CT']
regex1 = r'\s+'
regex2 = r'\d+'
for f in os.listdir(dirname):
  clean_up1 = re.sub(regex1,'%',f)
  clean_up2 = re.sub(regex2,'',clean_up1)
  clean_up3 = list(filter(None, clean_up2.split('_')))
  clean_up4 = list(filter(lambda x: x not in blacklist, clean_up3))
  clean_up5 = [ p for p in clean_up4 ]
  print(clean_up5)
