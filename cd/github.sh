function cdg {
    cd $GHUB/$1
}

function cdgm {
    cd $GHUBM/$1
}

. $(dirname "$0")/GitHub/mine.sh

function cdgo {
    cd $GHUBO/$1
}

. $(dirname "$0")/GitHub/others.sh
