#! usr/bin/bash

source ./drop_Table.sh
source ./create_table.sh
source ./list_tables.sh
source ./select_table.sh
source ./delete_from_table.sh
source ./insert_into_table.sh

PS3="Please choose what you want to do (from 1-8): "

function showTablesMenu(){
while true; 
do
    echo "Welcome To ${database} Menu:"
    select option in "List Tables" "Create Table" "Drop Table" "Select from Table" "Update Table" "Insert into Table" "Delete from Table" "Disconnect from DB"
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
                cd ../..
                return 1
                ;;
            *)
                echo "Invalid option please choose an option from 1 to 8"
                ;;
        esac
    done
done
}
