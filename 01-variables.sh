FILE_PATH="`dirname \"$0\"`"
for i in ${FILE_PATH}/variables/*.sh
do
    . "$i"
done