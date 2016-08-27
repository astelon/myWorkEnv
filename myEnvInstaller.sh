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

InstallTmux() {
    echo "Downloading libevent..."
    wget https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz -P /tmp

    echo "Downloading Tmux source..."
    wget https://github.com/tmux/tmux/releases/download/2.2/tmux-2.2.tar.gz -P /tmp
}

echo "Updating package sources..."

sudo apt-get update

echo "Installing basic packages..."

AssertCmdInstallation wget;
AssertCmdInstallation gcc;
AssertCmdInstallation g++;
AssertCmdInstallation git;
AssertCmdInstallation python;

if hash tmux 2>/dev/null; then
    echo "+ tmux command was already installed....\t\tOK"
else
    InstallTmux
fi

exit 0;

