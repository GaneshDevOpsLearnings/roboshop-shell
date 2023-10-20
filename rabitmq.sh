if [ -z "${rabbitmq_password}" ]
then
    echo -e "please provide rabbitmq password"
    exit 1
fi
source common.sh

print_head "rabbitmq" 
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> ${log}
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> ${log}
dnf install rabbitmq-server -y &>> ${log}
check_status

print_head "rabbitmq service"
systemctl enable rabbitmq-server  &>> ${log}
systemctl restart rabbitmq-server &>> ${log}
check_status

print_head "add user roboshop"
rabbitmqctl list_users | grep roboshop &>> ${log}
if [ $? -eq 0 ]; then
    echo -e "user exists"
else
    rabbitmqctl add_user roboshop ${rabbitmq_password} &>> ${log}
fi
check_status

print_head "set permissions"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> ${log}
check_status