#!/bin/bash
#
# Copyright, 2021 - Hendrawan, hendrawan.hendrawan@hpe.com

/bin/rm -f smartarray_check_script.sh
for i in `cat ilolist.txt`
do
 iloip=`echo "$i" | awk -F, '{print $1}'`
 ilouser=`echo "$i" | awk -F, '{print $2}'`
 ilopass=`echo "$i" | awk -F, '{print $3}'`
 echo "./smartarray_check.sh --url $iloip -u $ilouser -p $ilopass" >> smartarray_check_script.sh
done
/bin/chmod 755 smartarray_check_script.sh
