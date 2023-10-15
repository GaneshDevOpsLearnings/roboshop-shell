source common.sh

print_head "Installing nginx"
yum install nginx -y &>> ${log}
check_status

print_head "removing the default content"
rm -rf /usr/share/nginx/html/* &>> ${log}
check_status

print_head "Getting the files from git"
get_code froentend &>> ${log}
check_status

print_head "coping the code to defaulf location"
cp ./froented/* /usr/share/nginx/html/ &>> ${log}
check_status

print_head "setup nginx conf file"
cp ./files/nginx.conf /etc/nginx/default.d/roboshop.conf &>> ${log}
check_status

print_head "restart nginx service"
systemctl enable nginx &>> ${log}
systemctl restart nginx &>> ${log}
check_status