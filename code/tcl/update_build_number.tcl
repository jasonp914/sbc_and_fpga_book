set inputFile [open $fni r]
set outputFile [open $fno w]
set findStr "constant VERSION"
set replaceStr [lappend $findStr " : integer := "]

# Look for the line :
#   constant VERSION : integer := x;
# Replace the above line with:
#   constant VERSION : integer := x+1;

while{ [gets $inputFile line ] != -1}{
	if {[string first $findStr $line] >= 0}{
		set linearray [string split $line { }]
		set currVersion [lindex $linearray 6]
		incr currVersion
		puts $outputFile [lappend $replaceStr $currVersion ";"]
	}else{
		puts $outputFile $line
	}	
}

# Delete input file and rename output file
file delete $fni
file rename $fno $fni