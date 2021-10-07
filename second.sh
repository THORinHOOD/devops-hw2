#!/bin/bash

help=$(cat <<-END
    -i --input       : path to dataset csv file with data
    -r --train_ratio : percentage of objects in train sample
    -y --test        : path to test dataset file
    -x --train       : path to train dataset file
    -h --help        : help
END
)

while [ $# -gt 0 ]
do
    case "$1" in
    (-i | --input) input=$2;;
    (-r | --train_ratio) train_ratio=$2;;
    (-y | --test) test=$2;;
    (-x | --train) train=$2;;
    (-h | --help) echo "$help"
                  exit 0;;
    esac
    shift
done

read -r headers < $input
echo $headers >> $train
echo $headers >> $test

awk -v train="$train" -v test="$test" -v ratio=$train_ratio '{if (NR != 1) if(rand()<ratio) {print >> train} else {print >> test}}' $input


