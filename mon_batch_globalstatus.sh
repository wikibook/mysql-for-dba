#!/bin/bash

## Init variables
TODAY_SECOND=`date '+20%y-%m-%d %H:%M:%S'`
TODAY=`date '+20%y%m%d'`
NUMCUR=1

export _DBA_USR='root'
export _DBA_PWD='password'
export TEMPFILE_01=/home/mysql/mon_batch_globalstatus_TEMPFILE_01.log
export TEMPFILE_02=/home/mysql/mon_batch_globalstatus_TEMPFILE_02.log
export TEMPFILE_03=/home/mysql/mon_batch_globalstatus_TEMPFILE_03.log
export RESULTFILE=/home/mysql/mon_batch_globalstatus_RESULTFILE_$TODAY.csv
export GLOBALSTATUSFILE=/home/mysql/mon_batch_GLOBALSTATUS.txt
export PATH_MYSQLADMIN=/home/mysql/3306/mysql/bin

## Init file
rm -rf ${TEMPFILE_01}
rm -rf ${TEMPFILE_02}
rm -rf ${TEMPFILE_03}
touch ${TEMPFILE_01}
touch ${TEMPFILE_02}
touch ${TEMPFILE_03}
if [ -f ${RESULTFILE} ]
then
  echo ''
else
  cat ${GLOBALSTATUSFILE} > ${RESULTFILE}
fi

## global variables
$PATH_MYSQLADMIN/mysqladmin -u${_DBA_USR} -p${_DBA_PWD} -S /tmp/mysql_3306.sock extended-status | grep -v Ssl_ > ${TEMPFILE_01}

echo ${TODAY_SECOND} >> ${TEMPFILE_02}

## file filtering
cat ${TEMPFILE_01} | \
while read line
do
  if [ ${NUMCUR} -gt 3 -a ${NUMCUR} -lt 293 ]
  then
    echo "$line" | awk '{print $4}' >> ${TEMPFILE_02}
  fi
  NUMCUR='expr ${NUMCUR} + 1'
done

tr '\n' ',' < ${TEMPFILE_02} >> ${TEMPFILE_03}
echo '' >> ${TEMPFILE_03}

##results
cat ${TEMPFILE_03} >> ${RESULTFILE}