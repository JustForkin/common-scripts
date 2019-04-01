function fitocm {
    # First argument is height in feet rounded down
    # Second is the remaining height in inches
    octave_evaluate "$1*30+$2*2.5" | sed 's/ans =\s*//g'
}

function mtof {
	octave_evaluate "$1*100/30"
}

function ftom {
	octave_evaluate "$1*30/100"
}
