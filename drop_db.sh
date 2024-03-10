#! /usr/bin/bash
source ./list_DB.sh

#reserved keywords
reserved_keywords="create|list|drop|connect|from|select|update|delete|null|none|empty"
#function to drop DB
function dropDatabase(){
#list dbs
listDatabases 

#check if there are databases exist or not
if [ $? -eq 1 ]; then
        echo -e "\e[1;33mReturning to main menu....\e[0m"
        return
fi

#loop till user enter db-name
while true;
do
read -p $'\e[1;36mEnter DB name you want to drop : \e[0m' db_name
#check for some db_name is empty or not
check_DB_name_empty

# check if db_name matches regex (starts with letters followed by numbers)
if [[ "${db_name}" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
    #check if it's a reserved keyword
    if [[ "${db_name}" =~ ^($reserved_keywords)$ ]]; then
        echo -e "\e[1;31m'$db_name' is a reserved keyword. Please choose a different name.\e[0m"
    else
        check_db_exist
        if [ $? -eq 1 ]; then
	     	 dropDB
       	    if [ $? -eq 1 ];then
            break
        fi
      fi
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
then echo -e "\e[1;31mYou didn't enter DB name.\e[0m"
fi
}

function more_db_name_validate(){
#check if start with letters
if [[ ! "$db_name" =~ ^[a-zA-Z] ]]; then
        echo -e "\e[1;31mDB Names must start with letters.\e[0m"
#check if has space or special character
elif [[ "$db_name" =~ [[:space:][:punct:]] ]]; then
        echo -e "\e[1;31mDB Names must contain no spaces or special characters.\e[0m"
fi
}

function check_db_exist(){
#check if db_name exist in ./databases
if [ -d "./databases/${db_name}" ]; then
        echo -e "\e[1;32mDatabase Found !\e[0m"
        return 1 
    else
        echo -e "\e[1;31mDatabase '${db_name}' does not exist.\e[0m"
        return 0
    fi
}

function dropDB(){
    rm -r $PWD/databases/${db_name}
     if [ $? -eq 0 ]; then
        echo -e "\e[1;32mDatabase '${db_name}' successfully deleted.\e[0m"
        return 1
    else
        echo -e "\e[1;31mFailed to delete the database '${db_name}'. Try Again!\e[0m"
    fi
}


