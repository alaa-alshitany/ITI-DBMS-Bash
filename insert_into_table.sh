#!/bin/bash

function insertIntoTable() {
    while true; do
        listTables
        read -p $'\e[1;32mEnter the name of the table you want to insert into or (exit) to return: \e[0m' table_name
        if [[ "$table_name" == "exit" ]]; then
            echo -e "\e[1;32mReturning to the main menu.\e[0m"
            return 
        fi
        check_table_name
        metadataFile=".${table_name}"

        if [ -f "$metadataFile" ]; then
            # check if the data file exists, create it if not
            if [ ! -f "$table_name" ]; then
                touch "$table_name"
            fi

            echo -e "\e[1;37mHere are the headers of the table\e[0m"
            echo -e "\e[1;35m$(head -n 1 "$metadataFile" | tr ':' '\t')\e[0m"
            headers=$(head -n 1 "$metadataFile")
            data_types=$(sed -n '2p' "$metadataFile")
            constraints=$(sed -n '3p' "$metadataFile")

            IFS=':' read -r -a columns <<< "$headers"
            IFS=':' read -r -a types <<< "$data_types"
            IFS=':' read -r -a constraints_arr <<< "$constraints"
            data_values=()

            for ((i=0; i<${#columns[@]}; i++)); do
                column="${columns[i]}"
                data_type="${types[i]}"
                constraint="${constraints_arr[i]}"

                # Check if the column is pk
                if [ "$constraint" == "pk" ]; then
                    while true; do
                        read -p "Enter value for $column ($data_type): " value

                        if [[ "$value" == "exit" ]]; then
                            echo -e "\e[1;32mReturning to the main menu.\e[0m"
                            return 
                        fi

                        if validate_input "$value" "$data_type" "$constraint" "$table_name" "$column"; then
                            # Check uniqueness of the pk column
                            pk_column_index=$((i+1))
                            existing_values=$(cut -d: -f$pk_column_index "$table_name")

                            if [[ -z "$existing_values" || ! "$existing_values" =~ (^|[^0-9])"$value"([^0-9]|$) ]]; then
                                data_values+=("$value")
                                break
                            else
                                echo -e "\e[1;31mValue for $column must be unique. Please try again.\e[0m"
                            fi
                        else
                            echo -e "\e[1;31mInvalid input. Please try again.\e[0m"
                        fi
                    done
                else
                    # check if the column is pk and is auto-increment
                    if [ "$column" == "added_pk_col" ] && [ "$data_type" == "int" ] && [ "$constraint" == "pk,ai" ]; then
                        last_value=$(tail -n 1 "$table_name" | cut -d ":" -f $((i+1)))
                        if [[ -z "$last_value" ]]; then
                            last_value=0
                        fi
                        value=$((last_value + 1))
                        echo -e "\e[1;33mAuto-generated value for $column: $value\e[0m"
                        data_values+=("$value")
                    else
                        while true; do
                            read -p "Enter value for $column ($data_type): " value

                            if [[ "$value" == "exit" ]]; then
                                echo -e "\e[1;32mReturning to the main menu.\e[0m"
                                return 
                            fi
                            if validate_input "$value" "$data_type" "$constraint"; then
                                data_values+=("$value")
                                break
                            else
                                echo -e "\e[1;31mInvalid input. Please try again.\e[0m"
                            fi
                        done
                    fi
                fi
            done

            data_row=$(IFS=:; echo "${data_values[*]}")
            # append the data to the table file
            echo "$data_row" >> "$table_name"
            echo -e "\e[1;32mData inserted successfully.\e[0m"

        else
            echo -e "\e[1;31mMetadata file not found for table '${table_name}'.\e[0m"
        fi
        break
    done
}

function check_table_name() {
    if [[ "$table_name" == "databases" || "$table_name" == "select" || "$table_name" == "update" || "$table_name" == "delete" || "$table_name" == "insert" || "$table_name" == "drop" || "$table_name" == "null" ]]; then
        echo -e "\e[1;31mInvalid table name. '$table_name' is a reserved keyword.\e[0m"
        return 1
    fi

    if [[ "$table_name" =~ [[:space:]] ]]; then
        echo -e "\e[1;31mInvalid table name, spaces are not allowed!\e[0m"
        return 1
    fi

    if [[ ! "$table_name" =~ ^[a-zA-Z][a-zA-Z0-9_]{0,49}$ ]]; then
        echo -e "\e[1;31mInvalid table name. Please use only alphanumeric characters, underscores, starting with a letter!\e[0m"
        return 1
    fi
}

function validate_input() {
    local value="$1"
    local data_type="$2"

    if [[ "$value" == "null" || "$value" == "none" || "$value" == "empty" || -z "$value" ]]; then
        echo -e "\e[1;31mValue cannot be null, none, or empty.\e[0m"
        return 1
    fi

    if [[ "$data_type" == "int" ]]; then
        if [[ "$value" =~ ^[0-9]+$ ]]; then
            return 0
        else
            echo -e "\e[1;31mOnly Numbers Allowed!\e[0m"
            return 1
        fi
    elif [[ "$data_type" == "string" ]]; then
        if [[ -n "$value" && "$value" =~ ^[a-zA-Z]+$ ]]; then
            return 0 
        else 
             echo -e "\e[1;31mOnly Characters Allowed!\e[0m"
            return 1
        fi
    fi
    return 1 
}