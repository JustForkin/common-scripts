# Get latest git commit from repo data
function lcom {
    git log | head -n 1 | cut -d ' ' -f 2 | xclip -sel clip
}

# Get latest packaged commit from spec file
function scom {
    if ls -ld ./*.spec > /dev/null 2>&1; then
         grep "define commit" < "$(find . -name "*.spec" | grep -v ".osc" | head -n 1)" | cut -d ' ' -f 3 | xclip -sel clip
    elif [[ -n $1 ]]; then
        grep "define commit" < "$1" | cut -d ' ' -f 3 | xclip -sel clip
    fi
}
