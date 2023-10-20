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
    rm -rf /code/*
    mkdir -p /code
    cd /code
    git clone "https://github.com/roboshop-Project/$1.git"
    check_status
}

