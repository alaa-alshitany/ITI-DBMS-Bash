#! /bin/bash

source ./list_tables.sh
source ./select_table.sh

updateTable() {

    PS3=$'\e[1;36mPlease choose from the following options: \e[0m'

    if ! listTables
    then
        return
    fi

    while true
    do
	    select option in "Update Column" "Update Field" "Exit"
	    do
		    case $option in
			    "Update Column")
				    updateColumn
				    ;;
		            "Update Field")
				    updateField
				    ;;
			    "Exit")
				    return
				    ;;
		            *)
			            echo -e "\e[1;31mInvalid option. Please choose an option from 1 to 3\e[0m"
                                    ;;
		    esac
		    break
	    done
    done
}

is_integer() {
    [[ $1 =~ ^[0-9]+$ ]]
}

is_string() {
    [[ $1 =~ ^[a-zA-Z]+$ ]]
}


updateColumn() {
    while true; do
        listTables
        read -p $'\e[1;32mEnter the table name to perform update column operation on it or type (exit) to return: \e[0m' input_table
        if [[ "$input_table" == "exit" ]]; then
            echo -e "\e[1;32mReturning to the menu.\e[0m"
            return
        fi

        if [[ "$input_table" == "databases" || "$input_table" == "select" || "$input_table" == "update" || "$input_table" == "delete" || "$input_table" == "insert" || "$input_table" == "drop" || "$input_table" == "truncate" ]]; then
            echo -e "\e[1;31mInvalid table name. '$input_table' is a reserved keyword.\e[0m"
            continue
        fi

        if [[ "$input_table" =~ [[:space:]] ]]; then
            echo -e "\e[1;31mInvalid table name, spaces are not allowed!\e[0m"
            continue
        fi

        if [[ ! "$input_table" =~ ^[a-zA-Z][a-zA-Z0-9_]{0,49}$ ]]; then
            echo -e "\e[1;31mInvalid table name. Please use only alphanumeric characters, underscores, starting with a letter!\e[0m"
            continue
        fi

        if [ -f "${input_table}" ]; then
            echo -e "\e[1;32mAvailable columns in table $input_table:\e[0m"
            show_columns "$input_table"
        fi
        break
    done


    data_types=($(awk -F ':' 'NR==2 {for(i=1;i<=NF;i++) print $i}' ".$input_table"))
    
   
    IFS=':' read -ra primary_keys <<< "$(sed -n '3p' ".$input_table")"

    while true; do
        read -p $'\e[1;32mEnter column number to perform update operation on: \e[0m' colNumber

        if [[ $colNumber =~ ^[1-9][0-9]*$ ]]; then
            totalColumns=$(awk -F ':' 'NR==1 {print NF}' ".$input_table")
            if ((colNumber > 0 && colNumber <= totalColumns)); then
                break
            else
                echo -e "\e[1;31mInvalid column number. Please enter a valid column number between 1 and $totalColumns.\e[0m"
            fi
        else
            echo -e "\e[1;31mInvalid input. Please enter a valid number.\e[0m"
        fi
    done
    
    if [[ ${primary_keys[colNumber-1]} == "pk" || ${primary_keys[colNumber-1]} == "pk,ai" ]]; then
        echo -e "\e[1;31mError: Cannot update primary key column!!\e[0m"
        return 1
    fi

    echo -e "\e[1;31mWarning: All fields in column $colNumber will be updated!!\e[0m"
    read -p $'\e[1;35mEnter new value for the field: \e[0m' newValue

    if [[ ${data_types[colNumber-1]} == "int" ]]; then
        if ! is_integer "$newValue"; then
            echo -e "\e[1;31mError: Field $colNumber accepts integers only!!\e[0m"
            return 1 
        fi
        
    elif [[ ${data_types[colNumber-1]} == "string" ]]; then
        if ! is_string "$newValue"; then
            echo -e "\e[1;31mError: Field $colNumber accepts strings only!!\e[0m"
            return 1 
        fi
    fi
    
    while IFS= read -r line; do
        oldValue=$(echo "$line" | cut -d':' -f"$colNumber")
        echo -e "\e[1;36mUpdating field '$oldValue' to '$newValue' in column $colNumber.\e[0m"
        updatedLine=$(echo "$line" | awk -v col="$colNumber" -v val="$newValue" 'BEGIN{FS=OFS=":"}{$col=val; print}')
        sed -i "s|$line|$updatedLine|" "$input_table"
    done < "$input_table"
    echo -e "\e[1;32mAll fields in column $colNumber updated successfully.\e[0m"
    
}



updateField() {
    while true; do
        listTables
        read -p $'\e[1;32mEnter the table name to perform update column operation on it or type (exit) to return: \e[0m' input_table
        if [[ "$input_table" == "exit" ]]; then
            echo -e "\e[1;32mReturning to the menu.\e[0m"
            return
        fi

        if [[ "$input_table" == "databases" || "$input_table" == "select" || "$input_table" == "update" || "$input_table" == "delete" || "$input_table" == "insert" || "$input_table" == "drop" || "$input_table" == "truncate" ]]; then
            echo -e "\e[1;31mInvalid table name. '$input_table' is a reserved keyword.\e[0m"
            continue
        fi

        if [[ "$input_table" =~ [[:space:]] ]]; then
            echo -e "\e[1;31mInvalid table name, spaces are not allowed!\e[0m"
            continue
        fi

        if [[ ! "$input_table" =~ ^[a-zA-Z][a-zA-Z0-9_]{0,49}$ ]]; then
            echo -e "\e[1;31mInvalid table name. Please use only alphanumeric characters, underscores, starting with a letter!\e[0m"
            continue
        fi
        
        if [ ! -f "${input_table}" ]; then
            echo -e "\e[1;31mTable '$input_table' does not exist.\e[0m"
            continue
        fi
        
        echo "Available columns in table $input_table:"
        show_columns "$input_table"
        break
    done
    
    while true; do
        read -p $'\e[1;32mEnter column number to filter by: \e[0m' columnNumber

        if [[ $columnNumber =~ ^[0-9]+$ ]]; then
            totalColumns=$(awk -F ':' 'NR==1 {print NF}' ".$input_table")
            if ((columnNumber > 0 && columnNumber <= totalColumns)); then
                break
            else
                echo -e "\e[1;31mInvalid column number. Please enter a valid column number between 1 and $totalColumns.\e[0m"
            fi
        else
            echo -e "\e[1;31mInvalid input. Please enter a valid number.\e[0m"
        fi
    done

    while true; do
        read -p $'\e[1;35mEnter value to match: \e[0m' matchingValue
        matchingRows=$(awk -F ':' -v col="$columnNumber" -v val="$matchingValue" '$col == val' "$input_table")

        if [ -z "$matchingRows" ]; then
            read -p $'\e[1;31mNo matching rows found for the given value type (exit) to return or press any key to continue.\e[0m' goback
            if [[ "$goback" == "exit" ]]; then
               echo -e "\e[1;32mReturning to the menu.\e[0m"
               return
            fi        
        else
            break
        fi
    done

    data_types=($(awk -F ':' 'NR==2 {for(i=1;i<=NF;i++) print $i}' ".$input_table"))
    
    IFS=':' read -ra primary_keys <<< "$(sed -n '3p' ".$input_table")"

    read -p $'\e[1;35mEnter new value for the field: \e[0m' newValue

    if [[ -z "$newValue" ]]; then
        echo -e "\e[1;31mError: New value cannot be empty or null.\e[0m"
        return 1
    fi


    if [[ ${primary_keys[columnNumber-1]} == "pk" || ${primary_keys[columnNumber-1]} == "pk,ai" ]]; then
        if awk -F ':' -v col="$columnNumber" -v val="$newValue" -v table="$input_table" '$col == val { print "repeat" }' "$input_table" | grep -q "repeat"; then
            echo -e "\e[1;31mError: This value is already present in the pk.\e[0m"
            return 1
        fi
    fi

    if [[ ${data_types[columnNumber-1]} == "int" ]]; then
        if ! is_integer "$newValue"; then
            echo -e "\e[1;31mError: Field $columnNumber accepts integers only.\e[0m"
            return 1 
        fi
        
    elif [[ ${data_types[columnNumber-1]} == "string" ]]; then
        if ! is_string "$newValue"; then
            echo -e "\e[1;31mError: Field $columnNumber accepts strings only!!\e[0m"
            return 1 
        fi
    fi
    
    
    awk -F ':' -v col="$columnNumber" -v val="$matchingValue" -v newval="$newValue" 'BEGIN{OFS=":"} $col==val {$col=newval}1' "$input_table" > tmp_file && mv tmp_file "$input_table"
    echo -e "\e[1;32mValue updated successfully.\e[0m"

}






