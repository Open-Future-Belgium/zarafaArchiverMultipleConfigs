#!/bin/bash

#######################################
# Archiver Script                     #
# Written by Tom                      #
#######################################

CONFIGFILE="/usr/local/sbin/archiver-wrapper.cfg"
. $CONFIGFILE

while getopts ":c:" opt; do
  case $opt in
	c)                                                                                                                                                                                                                           
		if [ -f $OPTARG ]; then CONFIGFILE=$OPTARG; else echo "File not found"; fi   
	;;
  esac
done

function increase_error_count {
    ERRORCOUNT=$((${ERRORCOUNT}+1))
}

function not_found {
    echo "${1} not found!" >&2    
    exit 1
}

for soft in ldapsearch mail zarafa-archiver
do
  which $soft &>/dev/null || not_found $soft
done

(

### Run Archiver ###

for i in "${!FILTERGROUP[@]}" 
do
        array=( $(${LDAPSEARCH} -x -b "${SEARCHBASE}" "${FILTERGROUP[${i}]}" | grep -w "${SEARCHSTRING}" | cut -d " " -f 2) )

        for j in "${array[@]}" 
        do
            if ${ARCHIVER} -u $j -A -c ${CONFIG[${i}]}; then
                echo "Zarafa Archiver for user $j succeeded" 
            else
                echo "Zarafa Archiver for user $j failed" 
                increase_error_count
            fi
       done
done

### Logging ###

) > ${LOGS}/archiver-custom-${DATE}.log 2>&1

  if [ $? -eq 0 ]
  then
    ${MAIL} -s "Zarafa Archiver [OK]" -r $SENDER $RCPT < ${LOGS}/archiver-custom-${DATE}.log
  else
    ${MAIL} -s "Zarafa Archiver [FAILED]" -r $SENDER $RCPT < ${LOGS}/archiver-custom-${DATE}.log
  fi
