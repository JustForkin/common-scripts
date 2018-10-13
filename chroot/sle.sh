function sleroot {
    if [[ -d /sle ]]; then
         genbasic /sle
    elif [[ -d sled ]]; then
         genbasic /sled
    fi
} 
