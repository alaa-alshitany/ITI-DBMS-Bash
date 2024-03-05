#!/bin/bash


function showTablesMenu(){
PS3="Please choose what you want to do (from 1-8): "
while true; 
do
    echo "Welcome To ${database} Menu:"
    select option in "List Tables" "Add Table" "Drop Table" "Select from Table" "Update Table" "Insert into Table" "Delete from Table" "Disconnect from DB"
    do
        case $option in
            "List Tables")
                listTables
                break
                ;;
            "Create Table")
                addTable
                break
                ;;
            "Drop Table")
                dropTable
                break
                ;;
            # "Add Column")
            #     addColumn
            #     break
            #     ;;
            "Select from Table")
                selectFromTable
                break
                ;;
            "Update Table")
                updateTable
                break
                ;;
            "Insert into Table")
                insertIntoTable
                break
                ;;
            "Delete from Table")
                deleteFromTable
                break
                ;;
            "Disconnect from DB")
                exit
                ;;
            *)
                echo "Invalid option please choose an option from 1 to 8"
                ;;
        esac
    done
done
}
