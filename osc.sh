FILE_PATH="`dirname \"$0\"`"
for i in ${FILE_PATH}/obs/*.sh
do
    . "$i"
done