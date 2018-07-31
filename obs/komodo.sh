function komodoup {
    cdobsh komodo-edit
    pkglver=$(curl -sL https://www.activestate.com/komodo-ide/downloads/edit | grep "linux-x86_64" | cut -d '/' -f 10)
    pkgpver=$(komodo-edit.spec | grep "Version:" | cut -d ':' -f 2 | sed 's/\s*//g')
    sed -i -e "s|$pkgpver|$pkglver|g" komodo-edit.spec
    osc ci -m "Bumping $pkglver"
}

alias kup=komodoup
alias kedup=komodoup
alias komodoeditup=komodoup
