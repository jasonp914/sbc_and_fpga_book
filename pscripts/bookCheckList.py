import numpy as py
import re
#import pandas as pd

def parse_file(filepath):
	data = []
	with open(filepath,'r') as file_object:
		line = file_object.readline()
		while line:
			print(line)
			line = file_object.readline()
		

print("Hello World")
parse_file("../texfiles/chapter1.tex")
