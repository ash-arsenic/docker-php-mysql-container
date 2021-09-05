#!/bin/bash

if [ "$1" == "--help" ]; then
    echo "Help for `basename $0`"
    exit 0
elif [ "$1" == "--suid_audit" ]; then
    cd tmp
    sudo find . -perm /4000 > suid_audit.txt
    cd ..
    exit 0
fi

# MAKE DIRECTORY
echo "**************Making directory********************"
if [ ! -d data ]; then
    mkdir data
    echo "data directory made"
else
    echo "data directory already exists"
fi


if [ ! -d tmp ]; then
    mkdir tmp
    echo "tmp directory made"
else
    echo "tmp directory already exists"
fi

# INSTALL PACKAGES
echo "***************Installing Packages**********************"
cd data

read -p "Enter file name: " file

if [ -f $file ]; then
    count = 0

    while IFS= read -r line; do
        sudo pacman -S $line
        ((count++))
    done < $file

    echo "Installed $count packages"
else
    echo "File not exist"
fi

cd ..
# Adding Users
echo "***************Adding Users**********************"
cd data

read -p "Enter file name: " file

if [ -f $file ]; then

    while IFS= read -r line; do
        getent passwd $line > /dev/null 2&>1

        if [ $? -eq 0 ]; then
            echo "User already exists"
        else
            sudo useradd $line
            echo "User $line added."
        fi
    done < $file
else
    echo "File not exist"
fi

cd ..