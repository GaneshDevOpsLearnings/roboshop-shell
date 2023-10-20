source common.sh

print_head "node js setup"
sudo yum install https://rpm.nodesource.com/pub_18.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y &>> ${log}
sudo yum install nodejs -y --setopt=nodesource-nodejs.module_hotfixes=1 &>> ${log}
check_status

print_head "adding demon user"
id roboshop &>> ${log}
    if [ $? -eq 0 ]; then
        echo -e "user already exists"
    else
        useradd roboshop &>> ${log}
    fi
check_status

print_head "getting code from git"
get_code catalogue
check_status

print_head "install dependencies"
npm install
check_status

print_head "setting up catalogue service"
cp ${script_location}/files/catalogue.service /etc/systemd/system/
check_status

print_head "setting up the mongodb repo file"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/
check_status

print_head "installing mongodb client"
dnf install mongodb-org-shell -y &>> ${log}
check_status

print_head "load schema"
mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js &>> ${log}
check_status

print_head "daemon reload"
systemctl daemon-reload &>> ${log}
systemctl enable catalogue  &>> ${log}
systemctl start catalogue &>> ${log}
check_status
