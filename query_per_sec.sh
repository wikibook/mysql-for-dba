#!/bin/bash
/home/mysql/3306/mysql/bin/mysqladmin -uroot --password="password" -i1 extended-status | awk '
/Queries/{qu=$4-qup;qup=$4}
/Questions/{qs=$4-qsp;qsp=$4}
/Com_call_procedure/{ccp=$4-ccpp;ccpp=$4}
/Slow_queries/{slq=$4-slqp;slqp=$4}
/Com_select/{cs=$4-csp;csp=$4}
/Com_insert/ && $2 !~ /Com_insert_select/{ci=$4-cip;cip=$4}
/Com_update/ && $2 !~ /Com_update_multi/{cu=$4-cup;cup=$4}
/Com_delete/ && $2 !~ /Com_delete_multi/{cd=$4-cdp;cdp=$4}
/Com_replace/ && $2 !~ /Com_replace_select/{cr=$4-crp;crp=$4}
/Threads_connected/{tc=$4}
/Threads_running/{printf "Queries: %5d Questions: %5d Call_SP: %5d Slow_queries: %5d Com_select:
%5d Com_insert: %5d Com_update: %5d Com_delete: %5d Com_replace: %5d Threads_connected: %5d
Threads_running: %5d\n",qu,qs,ccp,slq,cs,ci,cu,cd,cr,tc,$4}'