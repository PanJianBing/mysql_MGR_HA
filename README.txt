#####db user create#####
create user switch identified with mysql_native_password with 'switch';
GRANT SELECT ON `performance_schema`.`replication_group_members` TO `switch`@`%`
#####client lib######
cp libcrypto.so.1.0.0 /lib64/
cp libssl.so.1.0.0 /lib64/
cp mysql /usr/bin/
##### test file #####
touch /usr/local/nginx/running
#####start shell ######
/usr/local/nginx/switch_write_mysql.sh >>/usr/local/nginx/logs/switch_write_mysql.log 2>&1 &
