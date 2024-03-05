#!/bin/bash

listDatabases() {
    if [ "$(ls -A ./databases)" ]; then
        echo -e "\e[1;32mListing current databases\e[0m"
        ls -d ./databases/*/ | cut -d/ -f3
    else
        echo -e "\e[1;31mThe 'databases' directory is empty\e[0m"
    fi
}

