#! /usr/bin/bash
source ./list_DB.sh

#reserved keywords
reserved_keywords="create|list|drop|connect|from|select|update|delete"
#function to drop DB
function dropDatabase(){
#list dbs
listDatabases 

#check if there are databases exist or not
if [ $? -eq 1 ]; then
        echo "Returning to main menu."
        return
fi
#loop till user enter db-name
while true;
do
read -p "Enter DB name you want to drop : " db_name
#check for some db_name is empty or not
check_DB_name_empty

# check if db_name matches regex (starts with letters followed by numbers)
if [[ "${db_name}" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
    #check if it's a reserved keyword
    if [[ "${db_name}" =~ ^($reserved_keywords)$ ]]; then
        echo "'$db_name' is a reserved keyword. Please choose a different name."
    else
        check_db_exist
        break
    fi
	else
	    more_db_name_validate
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

function more_db_name_validate(){
#check if start with letters
if [[ ! "$db_name" =~ ^[a-zA-Z] ]]; then
        echo "DB Names must start with letters."
#check if has space or special character
elif [[ "$db_name" =~ [[:space:][:punct:]] ]]; then
        echo "DB Names must contain no spaces or special characters."
fi
}

function check_db_exist(){
#check if db_name exist in ./databases
if [ -d "./databases/${db_name}" ]; then
        echo "Database Found !"
        dropDB
    else
        echo "Database '${db_name}' does not exist."
    fi
}

function dropDB(){
    rm -r $PWD/databases/${db_name}
     if [ $? -eq 0 ]; then
        echo "Database '${db_name}' successfully deleted."
    else
        echo "Failed to delete the database '${db_name}'. Try Again!"
    fi
}


