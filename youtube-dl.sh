function ytd {
    FORM=$(youtube-dl -F "$1" | grep "(best)")
    DIM=$(echo $FORM | sed 's/^[0-9][0-9][0-9]*\s*//g' | sed 's/^[a-z0-9][a-z0-9]*\s*//g' | cut -d ' ' -f 1)
    NUM=$(echo $FORM | cut -d ' ' -f 1)
    printf "Dimensions are: $DIM\n"
    youtube-dl -f $NUM "$1"
    printf "$FORM" &> /tmp/log
}
