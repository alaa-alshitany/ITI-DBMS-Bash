#!/bin/bash
source ./create_DB.sh
source ./list_DB.sh
source ./connect_db.sh
source ./drop_db.sh

displayDBMS() {
    echo -e "\e[1;35m"
    echo " ____     ____     __    __      ____   "
    echo "|    \   |    |   /  \  /  \    /       "  
    echo "|     |  |    /   |   --   |   /        "
    echo "|     |  |   |_   |        |    \       "
    echo "|     |  |     |  |        |     \      "
    echo "|_____|  |____/   |        | ____/      "
    echo -e "\e[0m"
}

PS3="Please choose from the following list: "

while true; 
do

    displayDBMS
    
    echo -e "\e[1;31mWelcome To Database Main Menu:\e[0m"
    select option in "Create Database" "List Databases" "Connect To Database" "Drop Database" "Exit"
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

