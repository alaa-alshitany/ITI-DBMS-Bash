#!/bin/bash
source ./create_DB.sh
source ./list_DB.sh
source ./connect_db.sh
source ./drop_db.sh

PS3="Please choose from the following list: "

while true; 
do
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

