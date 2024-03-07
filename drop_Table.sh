#! /bin/bash

## add list tables function if not ls and output ls is null return nothing and echo no tables found and break
## RM META AND DATA

dropTable () {
    while true; 
    do
        read -p $'\e[1;36mEnter the name of the table you want to drop or press (exit) to return to the previous menu: \e[0m' table_name

        if [[ "$table_name" == "exit" ]]
        then
            echo -e "\e[1;32mReturning to the connect menu.\e[0m"
            return
        fi

        if [[ "$table_name" =~ [[:space:]] || ! "$table_name" =~ ^[a-zA-Z][a-zA-Z0-9_]{0,49}$ ]]
        then
            echo -e "\e[1;31mInvalid table name. Please use only alphanumeric characters, underscores, starting with a letter, and no spaces!\e[0m"
            continue
        fi

        if [[ ! -f "$table_name" ]]
        then
            echo -e "\e[1;31mTable '$table_name' does not exist in database '$db_name'.\e[0m"
            continue
        fi

        read -p $'\e[1;31mAre you sure you want to drop this table? (yes/no): \e[0m' confirm

        if [[ "$confirm" == "yes" ]]
        then
            rm "$table_name"
            echo -e "\e[1;35mDropped table '$table_name' from database '$db_name'.\e[0m"
        else
            echo -e "\e[1;32mTable drop operation cancelled.\e[0m"
        fi
    done
}

