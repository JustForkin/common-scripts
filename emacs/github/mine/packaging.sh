function empk {
  emacs "$PKG/$1"
}

for i in $(dirname "$0")/packaging/*.sh
do
  . "$i"
done
