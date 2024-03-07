#! /usr/bin/bash
source ./list_DB.sh
source ./TablesMenu.sh

#reserved keywords
reserved_keywords="create|list|drop|connect|from|select|update|delete"
PS3="Choose Data Base you want to connect : "
#function to connect to DB
function connectToDatabases(){
#list dbs
listDatabases 

#check if there are databases exist or not
if [ $? -eq 1 ]; then
        echo "Returning to main menu."
        return
fi

#loop till user enter db-name
 while true; do
        read -p "Enter DB name: " db_name
        check_DB_name_empty

        if [[ "${db_name}" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
            if [[ "${db_name}" =~ ^($reserved_keywords)$ ]]; then
                echo "'$db_name' is a reserved keyword. Please choose a different name."
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
then echo "You didn't enter DB name"
fi
}

function extra_db_name_validate(){
#check if start with letters
if [[ ! "$db_name" =~ ^[a-zA-Z] ]]; then
        echo "DB Names must start with letters."
#check if has space or special character
elif [[ "$db_name" =~ [[:space:][:punct:]] ]]; then
        echo "DB Names must contain no spaces or special characters."
fi
}


function check_exist() {
    # check if db_name exist in ./databases
    if [ -d "./databases/${db_name}" ]; then
        cd "./databases/${db_name}"
        echo "Now you're connected !"
        showTablesMenu
        if [ $? -eq 1 ]; then
	     return 1
        fi
    else
        echo "Database '${db_name}' does not exist."

    fi
}




