#!/usr/bin/python

import numpy as py
import re
#import pandas as pd

def parse_file(filepath):
	data = []
	lc=0
	with open(filepath,'r') as file_object:
		line = file_object.readline()
		while line:
			data.append(line)
			lc=lc+1
			line = file_object.readline()
	return data
		
def add_todo_init(data_list,filepath):	
	# File is parsed - print out file
	file=open(filepath,'w')


	for i in range(0,len(data_list)):
		# Copy line over to new file
		file.write(data_list[i]+"\n")
		
		# Determine if we need to write TODO tag
		if data_list[i].find("chapter") == 1:
			file.write("\t<TODO Chapter : NOT DONE>\n")
			print("Found C")
		elif data_list[i].find("section") == 1:
			file.write("\t<TODO Section : NOT DONE>\n")
			print("Found S")

	file.close()		

fn = "../texfiles/chapter1.tex"
data = parse_file(fn)
add_todo_init(data,fn)
