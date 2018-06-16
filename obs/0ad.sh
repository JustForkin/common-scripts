function 0adup {
    cdgo 0ad
    git pull origin master -q
    mastn=$(git rev-list --branches master --count)
    specn=$(cat $OBSH/0ad/0ad.spec | grep "Version:" | sed 's/Version:\s*//g')
    comm=$(git log | head -n 1 | cut -d ' ' -f 2)
    specm=$(cat $OBSH/0ad/0ad.spec | grep "define commit" | cut -d ' ' -f 3)

    if [[ $specn == $mastn ]]; then
         printf "0 A.D. is up to date!\n"
    else
         sed -i -e "s/$specn/$mastn/g" $OBSH/0ad/0ad.spec
         sed -i -e "s/$specn/$mastn/g" $OBSH/0ad-data/0ad-data.spec
         sed -i -e "s/$specm/$comm/g" $OBSH/0ad/0ad.spec
         sed -i -e "s/$specm/$comm/g" $OBSH/0ad-data/0ad-data.spec
         cdobsh 0ad; osc ci -m "Bumping $specn->$mastn"
         cdobsh 0ad-data; osc ci -m "Bumping $specn->$mastn"
    fi
}
