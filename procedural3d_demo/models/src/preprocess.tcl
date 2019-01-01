foreach f [glob *.obj] {
	set name [file rootname $f]
	puts $name
	set file [open $f.old]
	set data [read $file]
	close $file
	regsub -all {object1} $data $name data
	regsub -all {object} $data "${name}_" data
	set file [open $f w]
	puts $file $data
	close $file
} 