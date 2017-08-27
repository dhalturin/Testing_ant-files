#!/bin/bash

pl=scripts

find . -type d -name $pl | while read d
do
    echo -e " :: $d"

    find $d -type f -name *.pyco -delete -o -name *.pyc -delete

    find $d -type f -name *.py | egrep -v "$d$" | while read f
    do
       dir=$(dirname $f)
       file=$(basename $f | sed 's/py/pyco/')
       md5=$(openssl rand -base64 5 | md5)
       cp $f $dir/$md5.pyc
       cp $f $dir/$file
    done

    # remove old directory
    find $d -type d | egrep -v "$d$|logic|player|vehicle|debug" | xargs -I {} rm -rf {}

    # create obf directory
    find $d -type d | egrep -v "debug|$d$" | while read dd
    do
       md5=$(openssl rand -base64 5 | md5)
       dn=$(basename $dd)
       cp -r $dd $(echo $dd | sed "s/$dn/$md5/")
    done
done
