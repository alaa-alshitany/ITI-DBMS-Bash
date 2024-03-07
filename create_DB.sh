#! /bin/bash

createDatabase() {
    if [[ ! -d "./databases" ]]; then
        mkdir -p "./databases"
    fi

    while true; do
        read -p $'\e[1;32mPlease enter the name of the database or type (exit) to return to the main menu: \e[0m' database_name

        if [[ "$database_name" == "exit" ]]; then
            echo -e "\e[1;32mReturning to the main menu.\e[0m"
            return
        fi

	if [[ "$database_name" == "databases" || "$database_name" == "select" || "$database_name" == "update" || "$database_name" == "delete" || "$database_name" == "insert" || "$database_name" == "drop" || "$database_name" == "truncate" ]]; then

            echo -e "\e[1;31mInvalid database name. '$database_name' is a reserved keyword.\e[0m"
            continue
        fi

        if [[ "$database_name" =~ [[:space:]] ]]; then
            echo -e "\e[1;31mInvalid database name, spaces are not allowed!\e[0m"
            continue
        fi

        if [[ ! "$database_name" =~ ^[a-zA-Z][a-zA-Z0-9_]{0,49}$ ]]; 
	then
	    echo -e "\e[1;31mInvalid database name. Please use only alphanumeric characters, underscores, starting with a letter!\e[0m"
            continue
        fi

        if [[ -d "./databases/$database_name" ]]; then
             echo -e "\e[1;35mDatabase '$database_name' already exists.\e[0m"
	     continue
        else
            mkdir -p "./databases/$database_name"
            echo -e "\e[1;32mDatabase '$database_name' created successfully.\e[0m"
        fi

        break 
    done
}

