source common.sh

print_head "setting up the mongodb repo file"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo
check_status

print_head "installing mongodb"
dnf install mongodb-org -y &>> ${log}
check_status

print_head "update the listing address"
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
check_status

print_head "enabling mongod"
systemctl enable mongod
systemctl restart mongod
check_status