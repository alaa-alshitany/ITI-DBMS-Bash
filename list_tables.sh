#! /usr/bin/bash

function listTables(){
     if [ "$(ls  ./)" ]; then
        echo -e "\e[1;32mListing current Tables\e[0m"
        ls  ./
    else
        echo -e "\e[1;31mNo Tables Found!\e[0m"
        return 1
    fi
}