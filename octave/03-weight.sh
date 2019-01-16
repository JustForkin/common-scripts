function lbtokg {
    octave_evaluate "0.4535924*$1" | sed 's/ans =\s*//g'
}

function kgtolb {
    octave_evaluate "$1/0.4535924" | sed 's/ans =\s*//g'
}
