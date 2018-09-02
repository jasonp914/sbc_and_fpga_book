#!/usr/bin/env python3

import numpy as py
import re
import sys
import smtplib



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
		elif data_list[i].find("section") == 1:
			file.write("\t<TODO Section : NOT DONE>\n")

	file.close()		

def email_msg(data_str):
	server = smtplib.SMTP('smtp.gmail.com',587)
	server.starttls()
	server.login("penninjr@gmail.com","Ktown Rocks!")
	server.sendmail("penninjr@gmail.com","penninjr@gmail.com",data_str)	
def gen_email_msg(data_list):
	todo_tags ="""From: Jason Pennington <penninjr@gmail.com>\nTo:Jason Pennington <penninjr@gmail.com\nSubject: TODO Tags\n\n""" 
	for i in range(0,len(data_list)):
		if data_list[i].find("TODO") > 0:
			todo_tags = todo_tags + data_list[i]

	return todo_tags

def remove_todo_tags(data_list,filepath):
	# File is parsed - print out file
	file=open(filepath,'w')

	# Write line if no TODO tag is in.
	for i in range(0,len(data_list)):
		
		print(data_list[i])
		print(data_list[i].find("<TODO"))
		if data_list[i].find("<TODO") < 0:
			# Copy line over to new file
			file.write(data_list[i]+"\n")
	file.close()

def remove_all_todo_tags():
	fn = "../texfiles/chapter1.tex"
	data = parse_file(fn)
	remove_todo_tags(data,fn)
	
	# fn = "../texfiles/chapter2.tex"
	# data = parse_file(fn)
	# remove_todo_tags(data,fn)
	# 
	# fn = "../texfiles/chapter3.tex"
	# data = parse_file(fn)
	# remove_todo_tags(data,fn)
	# 
	# fn = "../texfiles/chapter4.tex"
	# data = parse_file(fn)
	# remove_todo_tags(data,fn)
	# 
	# fn = "../texfiles/chapter5.tex"
	# data = parse_file(fn)
	# remove_todo_tags(data,fn)
	# 
	# fn = "../texfiles/chapter6.tex"
	# data = parse_file(fn)
	# remove_todo_tags(data,fn)
	# 
	# fn = "../texfiles/chapter7.tex"
	# data = parse_file(fn)
	# remove_todo_tags(data,fn)
	# 
	# fn = "../texfiles/chapter8.tex"
	# data = parse_file(fn)
	# remove_todo_tags(data,fn)
	# 
	# fn = "../texfiles/chapter9.tex"
	# data = parse_file(fn)
	# remove_todo_tags(data,fn)
	# 
	# fn = "../texfiles/chapter10.tex"
	# data = parse_file(fn)
	# remove_todo_tags(data,fn)


def init_todo_tags():
	fn = "../texfiles/chapter1.tex"
	data = parse_file(fn)
	add_todo_init(data,fn)
	
	fn = "../texfiles/chapter2.tex"
	data = parse_file(fn)
	add_todo_init(data,fn)
	
	fn = "../texfiles/chapter3.tex"
	data = parse_file(fn)
	add_todo_init(data,fn)
	
	fn = "../texfiles/chapter4.tex"
	data = parse_file(fn)
	add_todo_init(data,fn)
	
	fn = "../texfiles/chapter5.tex"
	data = parse_file(fn)
	add_todo_init(data,fn)
	
	fn = "../texfiles/chapter6.tex"
	data = parse_file(fn)
	add_todo_init(data,fn)
	
	fn = "../texfiles/chapter7.tex"
	data = parse_file(fn)
	add_todo_init(data,fn)
	
	fn = "../texfiles/chapter8.tex"
	data = parse_file(fn)
	add_todo_init(data,fn)
	
	fn = "../texfiles/chapter9.tex"
	data = parse_file(fn)
	add_todo_init(data,fn)
	
	fn = "../texfiles/chapter10.tex"
	data = parse_file(fn)
	add_todo_init(data,fn)

def email_all_todo_tags():
	fn = "../texfiles/chapter1.tex"
	data_all = parse_file(fn)
	
	fn = "../texfiles/chapter2.tex"
	data = parse_file(fn)
	data_all = data_all + data
	
	fn = "../texfiles/chapter3.tex"
	data = parse_file(fn)
	data_all = data_all + data

	fn = "../texfiles/chapter4.tex"
	data = parse_file(fn)
	data_all = data_all + data
	
	fn = "../texfiles/chapter5.tex"
	data = parse_file(fn)
	data_all = data_all + data
	
	fn = "../texfiles/chapter6.tex"
	data = parse_file(fn)
	data_all = data_all + data
	
	fn = "../texfiles/chapter7.tex"
	data = parse_file(fn)
	data_all = data_all + data
	
	fn = "../texfiles/chapter8.tex"
	data = parse_file(fn)
	data_all = data_all + data
	
	fn = "../texfiles/chapter9.tex"
	data = parse_file(fn)
	data_all = data_all + data
	
	fn = "../texfiles/chapter10.tex"
	data = parse_file(fn)
	data_all = data_all + data
	print(len(data))
	print(len(data_all))
	


	td_tags = gen_email_msg(data_all)
	email_msg(td_tags)


#print(data)
init_todo_tags()

remove_all_todo_tags()


#print(td_tags)


#email_all_todo_tags()














