function comsearch {
    for i in $(echo $PATH | sed 's/:/\n/g')
    do
         if [[ -d $i ]]; then 
              find $i -name "*vim*"
         fi
    done
}
