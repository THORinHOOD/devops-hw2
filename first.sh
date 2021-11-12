#!/bin/bash

help=$(cat <<-END
    -s --source    : path to dataset csv file from which links will be taken
    -c --column    : column with links
    -d --delimeter : delimeter in dataset csv file
    -w --workers   : how many workers will be when downloading files
    -p --path      : path to folder where to store downloaded files
    -h --help      : help
END
)

while [ $# -gt 0 ]
do
    case "$1" in
    (-s | --source) src=$2;;
    (-c | --column) column_with_link=$2;;
    (-d | --delimeter) delimeter=$2;;
    (-w | --workers) workers=$2;;
    (-p | --path) path_to_download=$2;;
    (-h | --help) echo "$help"
        exit 0;;
    esac
    shift
done

read -r headers < $src

column_with_link_index=-1

IFS=$delimeter read -r -a array <<< "$headers"
for i in "${!array[@]}"
do
    if [ "$column_with_link" = "${array[$i]}" ]; then
        column_with_link_index=$(($i+1))
    fi
done

if [ $column_with_link_index = -1 ]; then
    echo "Can't find column with name : $column_with_link"
    exit 1
fi

echo "Start to download..."
(cat $src | cut -d $delimeter -f$column_with_link_index | parallel -j$workers wget -t 3 -P $path_to_download {}) 2> /dev/null
echo "End download..."