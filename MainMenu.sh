#!/bin/bash
source ./create_DB.sh
source ./list_DB.sh

connectToDatabases() { echo "Connecting to Database"; }
dropDatabase() { echo "Dropping Database"; }


PS3="Please choose from the following list: "

while true; 
do
    echo "Welcome To Database Main Menu:"
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
                echo "Invalid option please choose an option from 1 to 5"
                ;;
        esac
    done
done

