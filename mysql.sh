if [ -z ${root_password} ]
then
    echo -e "please set the root_password variable"
    exit 1
fi
source common.sh

print_head "disbaled the default mysql"
dnf module disable mysql -y &>> ${log}
check_status

print_head "repo files"
cp ${script_location}/files/mysql.repo /etc/yum.repos.d/ &>> ${log}
check_status

print_head "install mysql"
dnf install mysql-community-server -y &>> ${log}
check_status

print_head "Set password for root user"
mysql_secure_installation --set-root-pass ${root_password} &>> ${log}
check_status