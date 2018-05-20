function git-branch {
    git rev-parse --abbrev-ref HEAD
}

# Push changes
function push {
    if `printf "$PWD" | grep 'AUR' > /dev/null 2>&1`; then
         mksrcinfo
    fi
    git add --all                                        # Add all files to git
    git commit -m "$1"                                   # Commit with message = argument 1
    git push origin $(git-branch)                        # Push to the current branch
    if `echo $PWD | grep "$HOME/Shell" > /dev/null 2>&1`; then
         szsh
    elif `echo $PWD | grep "$FS" > /dev/null 2>&1` && `cat /etc/os-release | grep -i Fedora > /dev/null 2>&1`; then
         szsh
    elif `echo $PWD | grep "$AS" > /dev/null 2>&1` && `cat /etc/os-release | grep -i Arch > /dev/null 2>&1`; then
         szsh
    elif `echo $PWD | grep "$GS" > /dev/null 2>&1` && `cat /etc/os-release | grep -i Gentoo > /dev/null 2>&1`; then
         szsh
    elif `echo $PWD | grep "$DS" > /dev/null 2>&1` && `cat /etc/os-release | grep -i "Debian\|Ubuntu" > /dev/null 2>&1`; then
         szsh
    elif `echo $PWD | grep "$VS" > /dev/null 2>&1` && `cat /etc/os-release | grep -i Void > /dev/null 2>&1`; then
         szsh
    elif `echo $PWD | grep "$OS" > /dev/null 2>&1` && `cat /etc/os-release | grep -i openSUSE > /dev/null 2>&1`; then
         szsh
    elif `echo $PWD | grep "$NS" > /dev/null 2>&1` && `cat /etc/os-release | grep -i NixOS > /dev/null 2>&1`; then
         szsh
    elif `echo $PWD | grep "$PLS" > /dev/null 2>&1` && `cat /etc/os-release | grep -i PCLinuxOS > /dev/null 2>&1`; then
         szsh
    elif `echo $PWD | grep "$CS" > /dev/null 2>&1` && `cat /etc/os-release | grep -i CentOS > /dev/null 2>&1`; then
         szsh
    fi
}

# Estimate the size of the current repo
# Taken from http://stackoverflow.com/a/16163608/1876983
function gitsize {
    git gc
    git count-objects -vH
}

# Git shrink
# Taken from http://stackoverflow.com/a/2116892/1876983
function gitsh {
    git reflog expire --all --expire=now
    git gc --prune=now --aggressive
}

function pushss {
    push "$1" && gitsh && gitsize
}