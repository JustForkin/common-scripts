function bmiim {
    # BMI from imperial measurements
    # $1 is weight in lb
    # $2 is height in ft, rounding down
    # $3 is the remainder height in inches
    kg=$(octe "0.4535924*$1" | sed 's/ans =\s*//g')
    cm=$(fitocm $2 $3)
    mt=$(octe "$cm/100")
}
