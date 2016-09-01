#!/bin/sh

# $1 is the command to install
# $2 is the package name
AssertCmdInstallation() {
    if hash $1 2>/dev/null; then
        echo "+ "$1" command was already installed....\t\tOK"
    else
        echo "+ Installing "$2" ..."
	sudo apt-get install $2
        if hash $1 2>/dev/null; then
            echo "+ "$1" command installed successfully! ....\t\tOK";
        else
            echo "- "$1" command instalation failed! ....\t\tERROR";
            exit 1;
        fi
    fi
}

InstallTmux() {
    if ! [ -e /tmp/libevent-2.0.22-stable.tar.gz ]; then
        echo "Downloading libevent..."
        wget https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz -P /tmp
    fi

    if ! [ -e /tmp/tmux-2.2.tar.gz ]; then
        echo "Downloading Tmux source..."
        wget https://github.com/tmux/tmux/releases/download/2.2/tmux-2.2.tar.gz -P /tmp
    fi

    if ! [ -d ~/src ]; then
        mkdir ~/src
    fi

    cd ~/src

    tar -zxf /tmp/libevent-2.0.22-stable.tar.gz
    cd libevent-2.0.22-stable
    ./autogen.sh
    ./configure

    echo "Compiling libevent..."
    make
    sudo make install

    cd ~/src


    tar -zxf /tmp/tmux-2.2.tar.gz
    cd tmux-2.2
    ./autogen.sh
    ./configure
    make
    sudo make install
}

ConfigureVim() {
    git clone https://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh
}

echo "Updating package sources..."

sudo apt-get update

echo "Installing basic packages..."

AssertCmdInstallation wget wget;
AssertCmdInstallation curl curl;
AssertCmdInstallation gcc gcc;
AssertCmdInstallation g++ g++;
AssertCmdInstallation git git;
AssertCmdInstallation automake automake;
AssertCmdInstallation aclocal aclocal;
AssertCmdInstallation libtoolize libtool;
AssertCmdInstallation atool atool;
AssertCmdInstallation python python;
AssertCmdInstallation ruby ruby;
AssertCmdInstallation perl perl;
AssertCmdInstallation w3m w3m;
AssertCmdInstallation cmake cmake;
AssertCmdInstallation elinks elinks;
AssertCmdInstallation zsh zsh;
AssertCmdInstallation vim vim;
AssertCmdInstallation ctags ctags;
AssertCmdInstallation cscope cscope;

echo "Install Build essential"
sudo apt-get install build-essential

if ! [ -e ~/.antigen.zsh ]; then
    echo "Install Antigen"
    curl https://cdn.rawgit.com/zsh-users/antigen/v1.0.4/antigen.zsh > ~/.antigen.zsh
fi

echo "Install ncurses library"
sudo apt-get install libncurses5-dev libncursesw5-dev

echo "Install scripting dev libraries"
sudo apt-get install python-dev python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev

echo "Install libx11 libs"
sudo apt-get install libx11-dev libxtst-dev

if hash ranger 2>/dev/null; then
    echo "+ ranger command was already installed....\t\tOK"
else
    echo "+ Installing ranger ..."
    sudo apt-get install ranger caca-utils highlight poppler-utils mediainfo
    if hash ranger 2>/dev/null; then
        echo "+ ranger command installed successfully! ....\t\tOK";
    else
        echo "- ranger command instalation failed! ....\t\tERROR";
        exit 1;
    fi
fi

if hash tmux 2>/dev/null; then
    echo "+ tmux command was already installed....\t\tOK"
else
    InstallTmux
fi

ConfigureVim

exit 0;

