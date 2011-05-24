#!/usr/bin/python

import os
import random
from sys import argv

mypath = argv[0]

def dir_list(dircontent):
    dirs = []
    files = []
    for item in dircontent:
        if os.path.isdir(currentpath + '/' + item):
            dirs.append(item)
        else:
            files.append(item)
    dirs.sort()
    files.sort()
    return dirs, files

def replacer(string):
    return string.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;').replace('"', '&quot;').replace("'", '&apos;')

def gen_menu(dirs, files):
    curpath = replacer(currentpath)
    print('<openbox_pipe_menu>')
    print('<separator label="' + curpath + '"/>')
    
    for thisdir in dirs:
        thisdir = replacer(thisdir)
        menuid = str(random.randrange(1,99,1)).zfill(2)
        print('  <item label="' + thisdir +'">')
	print('		<action name="execute">')
	print('			<execute>')
	print('				urxvt -title Ranger -name Ranger -e ranger "' + curpath + '/' + thisdir + '"')
	print('			</execute>')	
	print('		</action>')
	print('  </item>')
	
    print('</openbox_pipe_menu>')

if len(argv) > 1:
    currentpath = ' '.join(argv[1:])
else:
    currentpath = "/"

try:
    content = [x for x in os.listdir(currentpath) if x[0] != '.']
    parts = dir_list(content)
    gen_menu(parts[0], parts[1])
except OSError:
    print('<openbox_pipe_menu>')
    print('<separator label="Ei kansioita, tai oikeuksia" />')
    print('</openbox_pipe_menu>')
