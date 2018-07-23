function sleroot {
    if [[ -d /sle ]]; then
         genroot /sle
    elif [[ -d sled ]]; then
         genroot /sled
    fi
} 
