function molqup {
    cdgo molequeue
    pkglver=$(git rev-list --branches master --count)
    pkglc=$(git log | head -n 1 | cut -d ' ' -f 2)
    cdobsh molequeue
    pkgpc=$(cat molequeue.spec | grep "%define commit" | cut -d ' ' -f 3)
    pkgpver=$(cat molequeue.spec | grep "Version" | sed 's/Version:\s*//g')

    if ! [[ $pkglc == $pkgpc ]]; then
         sed -i -e "s|$pkgpver|$pkglver|g" \
                -e "s|%define commit $pkgpc|%define commit $pkglc|g" molequeue.spec
         osc ci -m "Bumping to $pkglver"
    fi
}

alias molequeueup=molqup
