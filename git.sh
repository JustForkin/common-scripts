FILE_PATH="`dirname \"$0\"`"
for i in ${FILE_PATH}/git/*.sh
do
    . "$i"
done