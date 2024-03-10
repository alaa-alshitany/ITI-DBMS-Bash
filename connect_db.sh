#! /usr/bin/bash
source ./list_DB.sh
source ./TablesMenu.sh

#reserved keywords
reserved_keywords="create|list|drop|connect|from|select|update|delete|null|none|empty"
PS3=$'\e[1;36mChoose Data Base you want to connect : \e[0m'
#function to connect to DB
function connectToDatabases(){
#list dbs
listDatabases 

#check if there are databases exist or not
if [ $? -eq 1 ]; then
        echo -e "\e[1;33mReturning to main menu....\e[0m"
        return
fi

#loop till user enter db-name
 while true; do
        read -p $'\e[1;36mEnter DB name or type (exit) to return to the main menu: \e[0m' db_name
        if [[ "$db_name" == "exit" ]]; then
            echo -e "\e[1;33mReturning to the main menu....\e[0m"
            return
        fi
        check_DB_name_empty

        if [[ "${db_name}" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
            if [[ "${db_name}" =~ ^($reserved_keywords)$ ]]; then
                echo -e "\e[1;31m'$db_name' is a reserved keyword. Please choose a different name.\e[0m"
            else
                check_exist
                if [ $? -eq 1 ]; then
	     	 break
       	        fi
            fi
        else
            extra_db_name_validate
        fi
    done
}

#check DB_name for empty
function check_DB_name_empty(){
# make sure he enter db_name|number
if [ -z ${db_name} ] #-z check for empty or null
then echo -e "\e[1;31mYou didn't enter DB name.\e[0m"
fi
}

function extra_db_name_validate(){
#check if start with letters
if [[ ! "$db_name" =~ ^[a-zA-Z] ]]; then
        echo -e "\e[1;31mDB Names must start with letters.\e[0m"
#check if has space or special character
elif [[ "$db_name" =~ [[:space:][:punct:]] ]]; then
        echo -e "\e[1;31mDB Names must contain no spaces or special characters.\e[0m"
fi
}


function check_exist() {
    # check if db_name exist in ./databases
    if [ -d "./databases/${db_name}" ]; then
        cd "./databases/${db_name}"
        echo -e "\e[1;32mNow you're connected !\e[0m"
        showTablesMenu
        if [ $? -eq 1 ]; then
	     return 1
        fi
    else
        echo -e "\e[1;31mDatabase '${db_name}' does not exist.\e[0m"

    fi
}




