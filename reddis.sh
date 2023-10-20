source common.sh

print_head "installing redis"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> ${log}
dnf module enable redis:remi-6.2 -y &>> ${log}
dnf install redis -y &>> ${log}
check_status

print_head "updating the ip"
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf /etc/redis/redis.conf &>> ${log}
check_status

print_head "redis service"
systemctl enable redis
systemctl restart redis