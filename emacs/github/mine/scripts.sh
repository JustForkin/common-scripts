function emsc {
  emacs "$SCR/$1"
}

for i in $(dirname "$0")/scripts/*.sh
do
  . "$i"
done
