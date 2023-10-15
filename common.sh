script_location=$(pwd)
log=/tmp/roboshop.log

print_head(){
    echo -e "\e[1m $1 [0m"
}

check_status(){
    if [ $? -eq 0 ]; then
        echo -e "\e[1;32m Success[0m"
    else
        echo -e "\e[1;31mfailure[0m"
        echo -e "\e[31mrefer the log file for more information, log - ${log}"
        exit 1
    fi
}

get_code(){
    git clone "https://github.com/roboshop-Project/$1.git"
}