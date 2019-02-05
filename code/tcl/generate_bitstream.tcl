# Set working directory
set workingDir ./
file mkdir $workingDir

# Import source files
read_vhdl ./rtl/*.vhd
read_xdc top.xdc

# Run Synthesis
synth_design -top top -part xc7k70tfbg676-2

# Implementation has three steps
opt_design
place_design
route_design

# Generate Post-Route Status
report_route_status -file route_status.rpt
report_timing_summary -file timing_summary.rpt
report_drc -file post_imp_drc.rpt

# Write the Bitstream
write_bitstream -force $workingDir/example.bit