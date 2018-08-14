#!/usr/bin/env bash
### author : jianbing.pan
### date   : 2018/07/31
### desc   : HA for MGR
prefix=/usr/local/nginx
INTERVAL=5
RUNFILE=${prefix}/running
function switch_primary()
{
for host in 10.4.168.223 10.4.168.225 10.4.168.226 
  do
   primary=`$prefix/MGR-HA-mysql8.0/bin/mysql --defaults-extra-file=${prefix}/MGR-HA-mysql8.0/conf/mysql.conf -h$host --connect-timeout=2 -e "select MEMBER_HOST from performance_schema.replication_group_members where MEMBER_ROLE='PRIMARY' and MEMBER_STATE='ONLINE';" | tail -1`
   config=`ps -ef | grep 'master process' | grep -v grep | awk -F"/" '{print $NF}' | awk -F".conf" '{print $1}'`
    if [ ! -z ${primary} ] && [ x${primary} != x${config} ]; then
       echo "$(date +%F_%T): $host==> switch $config to ${primary}!" 
       $prefix/sbin/nginx -s stop
       sleep 3
#      nginx_pid=`cat $prefix/logs/nginx.pid`
       $prefix/sbin/nginx -c $prefix/MGR-HA-mysql8.0/conf/${primary}.conf
       sleep 10
       break 1 
   fi
done
}

while test -e $RUNFILE
 do
  sleep=$(date  +%s.%N | awk "{print $INTERVAL - (\$1 % $INTERVAL)}")
  sleep $sleep
  switch_primary
done
echo "Exiting because $RUNFILE does not exits"
