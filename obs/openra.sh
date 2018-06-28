# Execute scripts in the openra subfolder
for i in $(dirname "$0")/openra/*.sh
do
    . "$i"
done
