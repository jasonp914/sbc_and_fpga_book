#!/usr/bin/env python3

#import numpy as py
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
		file.write(data_list[i])
		
		# Determine if we need to write TODO tag
		if data_list[i].find("chapter") == 1:
			file.write("\t<TODO Chapter " +data_list[i][9:-2] + " : NOT DONE>\n")
		elif data_list[i].find("section") == 1:
			file.write("\t<TODO Section " +data_list[i][9:-2] + " : NOT DONE>\n")
		elif data_list[i].find("subsection") == 1:
			file.write("\t<TODO Subsection " +data_list[i][12:-2] + " : NOT DONE>\n")
		elif data_list[i].find("subsubsection") == 1:
			file.write("\t<TODO Subsubsection  " +data_list[i][15:-2] + " : NOT DONE>\n")

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
			if data_list[i].find("NOT DONE") >= 0:
				todo_tags = todo_tags + data_list[i]


	return todo_tags

def gen_email_switch_msg(data_list,switch_array):
	todo_tags ="""From: Jason Pennington <penninjr@gmail.com>\nTo:Jason Pennington <penninjr@gmail.com\nSubject: TODO Tags\n\n""" 
	for i in range(0,len(data_list)):
		for sa in range(0,len(switch_array)):
			if data_list[i].find("TODO") > 0:
				if data_list[i].find(switch_array[sa]) >= 0:
					todo_tags = todo_tags + data_list[i]


	return todo_tags


def remove_todo_tags(data_list,filepath):
	# File is parsed - print out file
	file=open(filepath,'w')

	# Write line if no TODO tag is in.
	for i in range(0,len(data_list)):
		if data_list[i].find("<TODO") < 0:
			# Copy non-tag line over to new file
			file.write(data_list[i])
		#else:
			# TODO TAG line
			#if data_list[i].find("NOT DONE") < 0:
				# Don't remove other tag types
				#file.write(data_list[i])

	file.close()

def remove_all_todo_tags():
	fn = "../texfiles/chapter1.tex"
	data = parse_file(fn)
	remove_todo_tags(data,fn)
	
	fn = "../texfiles/chapter2.tex"
	data = parse_file(fn)
	remove_todo_tags(data,fn)
	
	fn = "../texfiles/chapter3.tex"
	data = parse_file(fn)
	remove_todo_tags(data,fn)
	
	fn = "../texfiles/chapter4.tex"
	data = parse_file(fn)
	remove_todo_tags(data,fn)
	
	fn = "../texfiles/chapter5.tex"
	data = parse_file(fn)
	remove_todo_tags(data,fn)
	
	fn = "../texfiles/chapter6.tex"
	data = parse_file(fn)
	remove_todo_tags(data,fn)
	
	fn = "../texfiles/chapter7.tex"
	data = parse_file(fn)
	remove_todo_tags(data,fn)
	
	fn = "../texfiles/chapter8.tex"
	data = parse_file(fn)
	remove_todo_tags(data,fn)
	
	fn = "../texfiles/chapter9.tex"
	data = parse_file(fn)
	remove_todo_tags(data,fn)
	
	fn = "../texfiles/chapter10.tex"
	data = parse_file(fn)
	remove_todo_tags(data,fn)


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

def email_all_todo_tags(switch_array):
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

	#td_tags = gen_email_msg(data_all)
	td_tags = gen_email_switch_msg(data_all,switch_array)
	email_msg(td_tags)









running = 1
while(running == 1):
	print("\n\n ---------------- \n")
	cmd = input("Remove all tags : r\nInitalize All Tags : i \nEmail Tags with switches : e -[switches]\nHelp : h\nQuit : q\n\n>")
	
	if cmd.find("r") >= 0:
		remove_all_todo_tags()
		print("\nRemove Tags Complete\n")
	elif cmd.find("i") >= 0:
		init_todo_tags()
		print("\nInitalize Command Complete\n")
	elif cmd.find("e") >= 0:
		si = cmd.find("-")
		s_array = cmd[3:]
		
		print("\nEmail Command Started with switch : " + s_array + "\n")
		switch_array = []
		for sws in range(0,len(s_array)):
			if s_array[sws].find("N") >= 0:
				switch_array.append("NOT DONE")
			elif s_array[sws].find("C") >= 0:
				switch_array.append("INSERT CODE")
			elif s_array[sws].find("P") >= 0:
				switch_array.append("PROOF READ")

		email_all_todo_tags(switch_array)
		print("Email Command Complete\n")
	elif cmd.find("h") >= 0:
		print("Email Switch Definitions:\n")
		print("N - NOT DONE:\n")
		print("C - INSERT CODE:\n")
		print("P - PROOF READ:\n")
	elif cmd.find("q") >= 0:
		running = 0
		print("Good Bye")
	else:
		print("Unknown Command")










