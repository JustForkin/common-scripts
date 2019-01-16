function ctof {
    octave_evaluate "32+1.8*$1"
}

function ftoc {
    octave_evaluate "("${1}"-32)/1.8"
}
