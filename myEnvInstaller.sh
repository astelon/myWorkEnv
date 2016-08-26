#!/bin/sh

# $1 is the command to install
AssertCmdInstallation() {
    if hash $1 2>/dev/null; then
        echo "+ "$1" command was already installed....\t\tOK"
    else
        echo "+ Installing "$1" ..."
	sudo apt-get install $1
        if hash $1 2>/dev/null; then
            echo "+ "$1" command installed successfully! ....\t\tOK";
        else
            echo "- "$1" command instalation failed! ....\t\tERROR";
            exit 1;
        fi
    fi
}

echo "Updating package sources..."

sudo apt-get update

echo "Installing basic packages..."

AssertCmdInstallation wget;
AssertCmdInstallation gcc;
AssertCmdInstallation g++;
AssertCmdInstallation git;
AssertCmdInstallation python;

exit 0;

