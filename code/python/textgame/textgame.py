#!/usr/bin/env python3
import math

print("Starting Game! ...\n")
print("Initializing Game...\n")
print("Starting Balance $50\n")

total_money = 50.0
num_workers = 0.0
skip_iters = 0
playing = 1
while(playing == 1):
    if skip_iters == 0:
        print("  -- Status ")
        print("  -- Total Money : " 
            + str(total_money))
        print("  -- Number Of Workers : " 
            + str(num_workers))
        
        cmd = input("What would you like to do: \n")
        
        if cmd.find("a") >= 0:
            print("Add Worker\n")
            num_workers += 1
            total_money -= 25
        elif cmd.find("A") >= 0:
            print("Add Workers\n")
            new_workers = math.floor(total_money/25)
            num_workers += new_workers
            total_money -= new_workers*25
        elif cmd.find("s") >= 0:
            print("Skip Iterations\n")
            skip_iters = 1000
        elif cmd.find("q") >= 0:
            playing = 0
            print("Good Bye!\n")
    else:
        skip_iters -= 1
    
    # Update Money 
    total_money += num_workers*.02

	
