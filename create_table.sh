#!/usr/bin/bash

function addTable() {
    reserved_keywords="create|list|drop|connect|from|select|update|delete|int|string"
    while true; do
        read -p "Enter Table name: " tb_name
        check_tb_name_empty
        # check if tb_name matches regex (starts with letters followed by numbers)
        if [[ "${tb_name}" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
            # check if it's a reserved keyword
            if [[ "${tb_name}" =~ ^($reserved_keywords)$ ]]; then
                echo "'$tb_name' is a reserved keyword. Please choose a different name."
            else
                dataFile="./${tb_name}"
                metadataFile="./.${tb_name}"
                if check_tb_exist; then
                    echo "Table '$tb_name' or metadata file already exists. Choose a different name."
                    continue
                fi
                create_columns
                touch "$metadataFile"
                create_metadata
                if [ "$colNum" -gt 0 ]; then
                    touch "$dataFile"
                    echo "Table '$tb_name' created successfully!"
                    break
                else
                    echo "Table cannot be created without columns. Please enter a positive number of columns."
                fi
            fi
        else
            extra_tb_name_validate
        fi
    done
}

# check table_name for empty
function check_tb_name_empty() {
    # make sure he enters tb_name|number
    if [ -z "${tb_name}" ]; then #-z check for empty or null
        echo "You didn't enter Table name"
    fi
}

function extra_tb_name_validate() {
    # check if it starts with letters
    if [[ ! "$tb_name" =~ ^[a-zA-Z] ]]; then
        echo "Table Name must start with letters."
    # check if it has space or special character
    elif [[ "$tb_name" =~ [[:space:][:punct:]] ]]; then
        echo "Table Name must contain no spaces or special characters."
    fi
}

function check_tb_exist() {
    # check if tb_name exists in ./databases/dbname
    if [ -e "$dataFile" ] || [ -e "$metadataFile" ]; then
        return 0
    else
        return 1
    fi
}

# function to create columns in the table
function create_columns() {
    colNames=""
    colTypes=""
    colConstraints=""
    uniqueColNames=()
    primaryKeySelected=false

    while true; do
        read -p "Enter the number of columns for the table: " colNum
        if [ -z "$colNum" ]; then
            echo "Number of columns cannot be empty. Please enter a positive integer."
            continue
        elif ! [[ "$colNum" =~ ^[1-9][0-9]*$ ]]; then
            echo "Invalid number of columns. Please enter a positive integer. "
            continue
        fi

        for ((i=1; i<=$colNum; i++)); do
            while true; do
                # taking columns names
                read -p "Enter the name for column $i: " colName
                if [ -z "$colName" ]; then
                    echo "Column name cannot be empty. Try again."
                    continue
                elif ! [[ "$colName" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
                    echo "Invalid column name. Please enter a valid name."
                    continue
                elif [[ " ${uniqueColNames[@]} " =~ " $colName " ]]; then
                    echo "Column name can't be duplicated. Enter another Name"
                    continue
                else
                    uniqueColNames+=("$colName")
                    colNames+=":$colName"
                    break
                fi
            done
            # taking data types
            while true; do
                read -p "Enter the data type for column $colName (int/string): " colType
                if [ "$colType" != "int" ] && [ "$colType" != "string" ]; then
                    echo "Invalid data type. Please enter 'int' or 'string'."
                    continue
                else
                    colTypes+=":$colType"
                    break
                fi
            done
            # taking primary key constraint
            if [ "$primaryKeySelected" = false ]; then
                while true; do
                    read -p "Do you want column $colName to be a primary key? (y/n): " choice
                    case $choice in
                        [Yy]*)
                            colConstraints+=":pk"
                            primaryKeySelected=true
                            primaryCol="$colName"
                            break
                            ;;
                        [Nn]*)
                            break
                            ;;
                        *)
                            echo "Invalid input. Please enter 'yes' or 'no'."
                            continue
                            ;;
                    esac
                done
            fi
        done

        # if no column is selected as primary key, create a new column named 'added_pk_col' as primary key with int data_type
        if [ -z "$colConstraints" ]; then
            uniqueColNames+=("added_pk_col")
            colTypes+=":int"
            colConstraints+="pk,ai"
            primaryCol="added_pk_col"
        fi

        break
    done
}

function create_metadata() {
    # get all elements from the array that holds the unique column entered
    uniqueColNames=$(echo "${uniqueColNames[@]}")
    # translate each space to : as separator
    colNames=$(echo "$uniqueColNames" | tr ' ' ':')
    # remove first ':' from colNames
    colTypes="${colTypes#:}"

    echo "$colNames" >> "$metadataFile"
    echo "$colTypes" >> "$metadataFile"
    # count the number of columns and create a string with that many ':'
    colConstraints=""

    for colName in $uniqueColNames; do
        if [ "$colName" == "$primaryCol" ]; then
            if [ "$colName" == "added_pk_col" ]; then
            colConstraints+=":pk,ai"
            else
            colConstraints+=":pk"
            fi
        else
            colConstraints+=":"
        fi
    done

    echo "${colConstraints#:}" >> "$metadataFile"
}
