# Make a working library
vlib work

# If using Xilinx IP they use
# a library other than work
vlib xil_defaultlib

# Compile the files in the design
vcom -64 -2008 -work work\
"../path/to/src/*.vhd"

# Optimize the design
# Simulation will run faster
# Use -L to reference the xilinx library
vopt -64 +acc=npr -L xil_defaultlib 
    -work work work.tb_top -o tb_top_opt

# Simulate top level	
vsim -lib work tb_top_opt

# Run DO script to add signals to view
do {add_waves.do}

# Opens up windows in Questa
view wave
view structure
view signals

# Run simulation
run -all