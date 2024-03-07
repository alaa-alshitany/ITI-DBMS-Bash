#!/bin/bash

source ./drop_Table.sh
source ./create_table.sh
source ./list_tables.sh

selectFromTable() {
    PS3=$'\e[1;36mPlease choose from the following options: \e[0m'
    if ! listTables; then
        return
    fi
    
    while true
    do
        select option in "Select All" "Select a Column" "Select a Row" "Exit"
        do
            case $option in
                "Select All")
                    selectAll
                    ;;
                "Select a Column")
                    selectColumn
                    ;;
                "Select a Row")
                    selectRow
                    ;;
                "Exit")
                    return
                    ;;
                *)
                    echo -e "\e[1;31mInvalid option. Please choose an option from 1 to 4\e[0m"
                    ;;
            esac
            break
        done
    done
}

selectAll() {

    while true
    do
    listTables
        read -p $'\e[1;32mEnter the name of the table you want to list or (exit) to return: \e[0m' table_name
        if [[ "$table_name" == "exit" ]]
        then
            echo -e "\e[1;32mReturning to the main menu.\e[0m"
            return
        fi

        if [[ "$table_name" == "databases" || "$table_name" == "select" || "$table_name" == "update" || "$table_name" == "delete" || "$table_name" == "insert" || "$table_name" == "drop" || "$table_name" == "truncate" ]]
        then
            echo -e "\e[1;31mInvalid table name. '$table_name' is a reserved keyword.\e[0m"
            continue
        fi

        if [[ "$table_name" =~ [[:space:]] ]]
        then
            echo -e "\e[1;31mInvalid table name, spaces are not allowed!\e[0m"
            continue
        fi

        if [[ ! "$table_name" =~ ^[a-zA-Z][a-zA-Z0-9_]{0,49}$ ]]
        then
            echo -e "\e[1;31mInvalid table name. Please use only alphanumeric characters, underscores, starting with a letter!\e[0m"
            continue
        fi

        if [ -f "${table_name}" ]
        then
            echo -e "\e[1;35m$(head -n 1 ".$table_name")\e[0m"
            cat "${table_name}"
        else
            echo -e "\e[1;31mTable '${table_name}' does not exist in the current database.\e[0m"
        fi
        break
    done
}


selectColumn() {

    while true
    do
    listTables
        read -p $'\e[1;32mEnter the name of the table you want to list or (exit) to return: \e[0m' selected_table
        
        if [[ "$selected_table" == "exit" ]]
        then
            echo -e "\e[1;32mReturning to the main menu.\e[0m"
            break 
        fi

        if [[ "$selected_table" == "databases" || "$selected_table" == "select" || "$selected_table" == "update" || "$selected_table" == "delete" || "$selected_table" == "insert" || "$selected_table" == "drop" || "$selected_table" == "truncate" ]]
        then
            echo -e "\e[1;31mInvalid table name. '$selected_table' is a reserved keyword.\e[0m"
            continue
        fi

        if [[ "$selected_table" =~ [[:space:]] ]]
        then
            echo -e "\e[1;31mInvalid table name, spaces are not allowed!\e[0m"
            continue
        fi

        if [[ ! "$selected_table" =~ ^[a-zA-Z][a-zA-Z0-9_]{0,49}$ ]]
        then
            echo -e "\e[1;31mInvalid table name. Please use only alphanumeric characters, underscores, starting with a letter!\e[0m"
            continue
        fi


        if [ ! -f "${selected_table}" ]
        then
            echo -e "\e[1;31mTable '$selected_table' does not exist.\e[0m"
            continue
        fi

        echo -e "\e[1;36mColumns in table'$selected_table':\e[0m"
        echo -e "\e[1;35m$(head -n 1 ".$selected_table")\e[0m"
        
        while true; do
            read -p $'\e[1;32mPlease enter the column number you want to view or type (exit) to return: \e[0m' selected_column_number
            
            if [[ "$selected_column_number" == "exit" ]]
            then
                echo -e "\e[1;32mReturning to the main menu.\e[0m"
                break 2 
            fi
            
            if ! [[ "$selected_column_number" =~ ^[0-9]+$ ]]
            then
                echo -e "\e[1;31mError: Only numbers are allowed.\e[0m"
                continue
            fi

            echo -e "\e[1;36mData in column '$selected_column_number':\e[0m"
            awk -F':' -v col="$selected_column_number" '{ print $col }' "${selected_table}"
            
            break
        done
    done
}


selectRow() {
    echo "Selecting a Row"
}


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
