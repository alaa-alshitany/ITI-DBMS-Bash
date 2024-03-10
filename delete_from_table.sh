#! /bin/bash

source ./list_tables.sh

deleteFromTable() {

    PS3=$'\e[1;36mPlease choose from the following options: \e[0m'
    if ! listTables
    then
        return
    fi
    
    while true
    do
	    select option in "Delete All" "Delete Column" "Delete a Row" "Exit"
	    do
		    case $option in
			    "Delete All")
				    deleteAll
				    ;;
		            "Delete Column")
				    deleteColumn
				    ;;
			    "Delete a Row")
				    deleteRow
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


deleteAll() {
    while true
    do
    listTables
        read -p $'\e[1;32mEnter the name of the table you want to delete or (exit) to return: \e[0m' input_table
        if [[ "$input_table" == "exit" ]]; then
            echo -e "\e[1;32mReturning to the main menu.\e[0m"
            return
        fi

        if [[ "$input_table" == "databases" || "$input_table" == "select" || "$input_table" == "update" || "$input_table" == "delete" || "$input_table" == "insert" || "$input_table" == "drop" || "$input_table" == "truncate" ]]; then
            echo -e "\e[1;31mInvalid table name '$input_table' is a reserved keyword.\e[0m"
            continue
        fi

        if [[ "$input_table" =~ [[:space:]] ]]; then
            echo -e "\e[1;31mInvalid table name. Spaces are not allowed!\e[0m"
            continue
        fi

        if [[ ! "$input_table" =~ ^[a-zA-Z][a-zA-Z0-9_]{0,49}$ ]]; then
            echo -e "\e[1;31mInvalid table name. Please use only alphanumeric characters, underscores, starting with a letter!\e[0m"
            continue
        fi
        
        if [ -f "${input_table}" ]; then
            read -p $'\e[1;31mAre you sure you want to delete the content of this table? (yes/no): \e[0m' confirm
            if [[ $confirm == yes ]]; then
       
                cat /dev/null > "${input_table}"
                echo -e "\e[1;35mDeleted '$input_table' table content.\e[0m"
            else
                echo -e "\e[1;32mTable content deletion operation cancelled.\e[0m"
            fi
        else
            echo -e "\e[1;31mTable '$input_table' does not exist in the current database.\e[0m"
        fi
        break
    done
}


deleteColumn() {
    while true; do
        listTables

        read -p $'\e[1;32mChoose the table name you want to delete column from or (exit) to return: \e[0m' table

        if [[ "$table" == "exit" ]]; then
            echo -e "\e[1;32mReturning to the menu.\e[0m"
            return
        fi

        if [[ "$table" == "databases" || "$table" == "select" || "$table" == "update" || "$table" == "insert" || "$table" == "delete" || "$table" == "truncate" || "$table" == "drop" ]]; then
            echo -e "\e[1;31mInvalid table name '$table' is a reserved keyword.\e[0m"
            continue
        fi

        if [[ "$table" =~ [[:space:]] ]]; then
            echo -e "\e[1;31mInvalid table name. Spaces are not allowed!\e[0m"
            continue
        fi

        if [[ ! "$table" =~ ^[a-zA-Z][a-zA-Z0-9_]{0,49}$ ]]; then
            echo -e "\e[1;31mInvalid table name. Please use only alphanumeric characters, underscores, starting with a letter!\e[0m"
            continue
        fi

        if [ ! -f "${table}" ]; then
            echo -e "\e[1;31mTable "$table" does not exist.\e[0m"
            continue
        fi

        echo -e "\e[1;36mColumns in table '$table':\e[0m"
        echo -e "\e[1;35m$(head -n 1 ".$table")\e[0m"

        read -p $'\e[1;32mPlease enter the column number you want to delete or type (exit) to return: \e[0m' col_num

        if [[ "$col_num" == "exit" ]]; then
            echo -e "\e[1;32mReturning to the main menu.\e[0m"
            break
        fi

        if ! [[ "$col_num" =~ ^[1-9]+$ ]]; then
            echo -e "\e[1;31mError: Only numbers are allowed.\e[0m"
            continue
        fi

        num_fields=$(awk -F':' 'NR==1{print NF}' ".${table}")
        if (( col_num > num_fields )); then
            echo -e "\e[1;31mError: The column number you provided is greater than the number of fields in the table, please choose a number from (1 to "$num_fields").\e[0m"
            continue
        fi

        if [[ $(awk -F':' -v col="$col_num" 'NR==3{if($col == "pk" || $col == "pk,ai") print "true"}' ".$table") == "true" ]]; then
            echo -e "\e[1;31mError: The specified column is a primary key and cannot be deleted.\e[0m"
            continue
        fi
        
        temp_table="${table}.temp"
        
        awk -F':' -v col="$col_num" 'BEGIN {OFS=":"} {for (i=1; i<=NF; i++) printf "%s%s", (i == col ? "" : $i), (i == NF ? "\n" : FS)}' "${table}" > "${temp_table}"
        awk -F':' -v num_fields="$num_fields" 'BEGIN {OFS=":"} {for (i=NF+1; i<=num_fields; i++) printf "%s%s", (i == num_fields ? "" : ":"), ""} {print ""}' "${temp_table}" >> "${temp_table}"
        mv "${temp_table}" "${table}"
        
        echo -e "\e[1;36mColumn $col_num deleted successfully from table $table.\e[0m"
       
        break
    done
}
deleteRow() {
    while true; do
        listTables
        read -p $'\e[1;32mEnter the name of the table you want to delete a row from or (exit) to return: \e[0m' selected_table

        if [[ "$selected_table" == "exit" ]]; then
            echo -e "\e[1;32mReturning to the main menu.\e[0m"
            break
        fi

        if [[ "$selected_table" == "databases" || "$selected_table" == "select" || "$selected_table" == "update" || "$selected_table" == "delete" || "$selected_table" == "insert" || "$selected_table" == "drop" || "$selected_table" == "truncate" ]]; then
            echo -e "\e[1;31mInvalid table name. '$selected_table' is a reserved keyword.\e[0m"
            continue
        fi

        if [[ "$selected_table" =~ [[:space:]] ]]; then
            echo -e "\e[1;31mInvalid table name, spaces are not allowed!\e[0m"
            continue
        fi

        if [[ ! "$selected_table" =~ ^[a-zA-Z][a-zA-Z0-9_]{0,49}$ ]]; then
            echo -e "\e[1;31mInvalid table name. Please use only alphanumeric characters, underscores, starting with a letter!\e[0m"
            continue
        fi

        if [ ! -f "${selected_table}" ]; then
            echo -e "\e[1;31mTable '$selected_table' does not exist.\e[0m"
            continue
        fi

        if [ ! -s "${selected_table}" ]; then
            echo -e "\e[1;31mThe table '$selected_table' is empty. No data to delete.\e[0m"
            break
        fi

        echo "Available columns in table $selected_table:"
        show_columns "$selected_table"

        read -p "Enter column number to identify the row to delete: " columnNumber

        if [[ $columnNumber =~ ^[0-9]+$ ]]; then
            totalColumns=$(awk -F ':' 'NR==1 {print NF}' ".$selected_table")
            if ((columnNumber > 0 && columnNumber <= totalColumns)); then
                read -p "Enter value to match for deletion: " matchingValue
                matchingValue=$(echo "$matchingValue" | tr -d '[:space:]')

                matchingRecords=$(awk -F ':' -v col="$columnNumber" -v val="$matchingValue" '$col == val && $col != ""' "$selected_table")
                matchingRecordsCount=$(echo "$matchingRecords" | awk '$0 ~ /[^\s]/' | wc -l)
                if [ "$matchingRecordsCount" -gt 0 ]; then
                    read -p "The condition matches $matchingRecordsCount records. Do you want to delete them all? (yes/no): " confirmDelete
                    if [[ $confirmDelete == "yes" || $confirmDelete == "y" ]]; then  
                        awk -F ':' -v col="$columnNumber" -v val="$matchingValue" '$col != val {print $0}' "$selected_table" >"${selected_table}.tmp"
                        mv "${selected_table}.tmp" "$selected_table"
                        echo -e "\e[1;32mRow(s) deleted successfully.\e[0m"
                    elif [[ $confirmDelete == "no" || $confirmDelete == "n" ]]; then
                        echo -e "\e[1;32mDeletion operation cancelled.\e[0m"
                    else
                        echo -e "\e[1;31mInvalid input. Please enter a valid number.\e[0m"
                    fi
                elif [ "$matchingRecordsCount" -eq 0 ]; then
                    echo -e "\e[1;31mNo matching records found for deletion.\e[0m"
                fi
                break
            else
                echo -e "\e[1;31mInvalid column number. Please enter a valid column number between 1 and $totalColumns.\e[0m"
            fi
        else
            echo -e "\e[1;31mInvalid input. Please enter a valid number.\e[0m"
        fi
        break
    done
}


function show_columns() {
    tableName=$1
    metadataFile=".$tableName"

    if [ -f "$metadataFile" ]; then
        header=$(head -n 1 "$metadataFile" | tr ':' '\t')
        echo -e "\e[1;35m$header\e[0m" 
    else
        return 1
    fi
}