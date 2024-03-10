#!/bin/bash

source ./create_DB.sh
source ./list_DB.sh
source ./connect_db.sh
source ./drop_db.sh

files=(
    connect_db.sh
    delete_from_table.sh
    list_DB.sh
    select_table.sh
    create_DB.sh
    drop_db.sh
    list_tables.sh
    TablesMenu.sh
    create_table.sh
    drop_Table.sh
    MainMenu.sh
    updateTable.sh
    insert_into_table.sh
)

checkFiles() {
    echo -e "\e[1;33mChecking All Files Exist in the Current Directory\e[0m"
    for file in "${files[@]}"; do
        if [ -f "./$file" ]; then
            chmod +x "./$file"
        elif [ ! -f "./$file" ];then
            echo -e "\e[1;31m$file not Exist in Current Directory! Add it and Try to Run Again\e[0m"
            exit 
        fi 
    done
        echo -e "\e[1;32mAll Files for DBMS are Exist and Excutable.\e[0m"
}

displayDBMS() {
    red='\033[38;5;196m'    
    orange='\033[38;5;208m' 
    yellow='\033[38;5;226m' 

    echo -en "${red}" 
    echo "                                                                                         "
    echo "DDDDDDDDDDDDD      BBBBBBBBBBBBBBBBB   MMMMMMMM               MMMMMMMM   SSSSSSSSSSSSSSS "
    echo "D::::::::::::DDD   B::::::::::::::::B  M:::::::M             M:::::::M SS:::::::::::::::S"
    echo "D:::::::::::::::DD B::::::BBBBBB:::::B M::::::::M           M::::::::MS:::::SSSSSS::::::S"
    echo "DDD:::::DDDDD:::::DBB:::::B     B:::::BM:::::::::M         M:::::::::MS:::::S     SSSSSSS"
    echo "  D:::::D    D:::::D B::::B     B:::::BM::::::::::M       M::::::::::MS:::::S            "
    echo "  D:::::D     D:::::DB::::B     B:::::BM:::::::::::M     M:::::::::::MS:::::S            "
    echo -en "${orange}" 
    echo "  D:::::D     D:::::DB::::BBBBBB:::::B M:::::::M::::M   M::::M:::::::M S::::SSSS         "
    echo "  D:::::D     D:::::DB:::::::::::::BB  M::::::M M::::M M::::M M::::::M  SS::::::SSSSS    "
    echo "  D:::::D     D:::::DB::::BBBBBB:::::B M::::::M  M::::M::::M  M::::::M    SSS::::::::SS  "
    echo "  D:::::D     D:::::DB::::B     B:::::BM::::::M   M:::::::M   M::::::M       SSSSSS::::S "
    echo "  D:::::D     D:::::DB::::B     B:::::BM::::::M    M:::::M    M::::::M            S:::::S"
    echo -en "${yellow}"
    echo "  D:::::D    D:::::D B::::B     B:::::BM::::::M     MMMMM     M::::::M            S:::::S"
    echo "DDD:::::DDDDD:::::DBB:::::BBBBBB::::::BM::::::M               M::::::MSSSSSSS     S:::::S"
    echo "D:::::::::::::::DD B:::::::::::::::::B M::::::M               M::::::MS::::::SSSSSS:::::S"
    echo "D::::::::::::DDD   B::::::::::::::::B  M::::::M               M::::::MS:::::::::::::::SS "
    echo "DDDDDDDDDDDDD      BBBBBBBBBBBBBBBBB   MMMMMMMM               MMMMMMMM SSSSSSSSSSSSSSS   "
    echo -en "\033[0m"
}


PS3=$'\e[1;36mPlease choose from the following list: \e[0m '

while true; 
do
    
    checkFiles
    displayDBMS
    
    echo -e "\e[1;32mWelcome To Database Main Menu:\e[0m"
    select option in select option in "Create Database" "List Databases" "Connect To Database" "Drop Database" "Exit"
    do
        case $option in
            "Create Database")
                createDatabase
                break
                ;;
            "List Databases")
                listDatabases
                break
                ;;
            "Connect To Database")
                connectToDatabases
                break
                ;;
            "Drop Database")
                dropDatabase
                break
                ;;
            "Exit")
                exit
                ;;
            *)
                echo -e "\e[1;31mInvalid option please choose an option from 1 to 5\e[0m"
                ;;
        esac
    done
done

