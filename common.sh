script_location=$(pwd)
log=/tmp/roboshop.log

print_head(){
    echo -e "\e[1m $1 \e[0m"
}

check_status(){
    if [ $? -eq 0 ]; then
        echo -e "\e[1;32m Success\e[0m"
    else
        echo -e "\e[1;31mfailure\e[0m"
        echo -e "\e[31mrefer the log file for more information, log - ${log}\e[0m"
        exit 1
    fi
}

get_code(){
    rm -rf /app/* &>> ${log}
    mkdir -p /app &>> ${log}
    cd /app &>> ${log}
    git clone "https://github.com/roboshop-Project/$1.git" &>> ${log}
    check_status
    cp -r /app/$1/* /app/ &>> ${log}
    cd /app &>> ${log}
    check_status
}

app_prereq(){
    print_head "adding demon user"
    id roboshop &>> ${log}
        if [ $? -eq 0 ]; then
            echo -e "user already exists"
        else
            useradd roboshop &>> ${log}
        fi
    check_status

    print_head "getting code from git"
    get_code $1
    check_status

    print_head "install dependencies"
    npm install &>> ${log}
    check_status

    print_head "setting up $1 service"
    cp ${script_location}/files/$1.service /etc/systemd/system/
    check_status

    print_head "daemon reload"
    systemctl daemon-reload &>> ${log}
    systemctl enable $1  &>> ${log}
    systemctl restart $1 &>> ${log}
    check_status
    if [ ${schema_type} == mongodb ]; then
        print_head "setting up the mongodb repo file"
        cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/
        check_status

        print_head "installing mongodb client"
        dnf install mongodb-org-shell -y &>> ${log}
        check_status

        print_head "load schema"
        mongo --host 172.31.42.190 </app/schema/$1.js &>> ${log}
        check_status
    fi
}

System_setup(){
    if [ $1 == "nodejs" ]; then
        print_head "node js setup"
        sudo yum install https://rpm.nodesource.com/pub_18.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y &>> ${log}
        sudo yum install nodejs -y --setopt=nodesource-nodejs.module_hotfixes=1 &>> ${log}
        check_status
    fi
}