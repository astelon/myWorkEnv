#!/bin/sh

export install_cmd="sudo apt-get install"
export update_cmd="sudo apt-get update"

# $1 is the command to install
# $2 is the package name
AssertCmdInstallation() {
    if hash $1 2>/dev/null; then
        echo "+ "$1" command was already installed....\t\tOK"
    else
        echo "+ Installing "$2" ..."
	$install_cmd $2
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
    echo "Configuring Vim..."
    if ! [ -d ~/.vim_runtime ]; then
        cd ~
        git clone https://github.com/amix/vimrc.git ~/.vim_runtime
        sh ~/.vim_runtime/install_awesome_vimrc.sh
        echo "set exrc"   >> ~/.vimrc;
        echo "set secure" >> ~/.vimrc;
        echo "set nu!"    >> ~/.vimrc;
        echo "set relativenumber" >> ~/.vimrc;

        if [ -d ~/.vim_runtime/sources_non_forked/syntastic ]; then
            echo "Removing syntastic..."
            rm -rf ~/.vim_runtime/sources_non_forked/syntastic
        fi
    else
        echo "+ Amix vimrc was already installed..... \t\tOK!"
    fi

    if ! [ -d ~/.vim_runtime/sources_non_forked/YouCompleteMe ]; then
        echo "Installing YouCompleteMe..."
        cd ~/.vim_runtime/sources_non_forked/
        git clone https://github.com/Valloric/YouCompleteMe.git YouCompleteMe
        cd YouCompleteMe
        echo "Updating dependencies for YouCompleteMe..."
        git submodule update --init --recursive
        python3 ~/.vim_runtime/sources_non_forked/YouCompleteMe/install.py --clang-completer
        echo "\"\"\" Use a default ycm extra conf file if needed \"\"\"" >> ~/.vimrc
        echo "let g:ycm_global_ycm_extra_conf = '~/.vim_runtime/sources_non_forked/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'" >> ~/.vimrc
    else
        echo "+ YouCompleteMe vim plugin was already installed ... OK!"
    fi

    if ! [ -d ~/.vim_runtime/sources_non_forked/YCM-Generator ]; then
        cd ~/.vim_runtime/sources_non_forked/
        git clone https://github.com/rdnetto/YCM-Generator.git YCM-Generator
		cd ~/.vim_runtime/sources_non_forked/YouCompleteMe/third_party/ycmd/clang_archives/
		mkdir bin
		cd bin
        ls .. | grep tar | sed 's/\.tar.*//' | xargs -ifile tar -xf ../file.tar.xz file/bin --strip=2
		# echo "export PATH=\$HOME/.vim_runtime/sources_non_forked/YouCompleteMe/third_party/ycmd/clang_archives/bin:$PATH" >> ~/.zshrc
    else
        echo "+ YCM-Generator vim plugin was already installed ... OK!"
    fi
}

echo "Updating package sources..."

$update_cmd

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
$install_cmd build-essential

if ! [ -e ~/.antigen.zsh ]; then
    echo "Install Antigen"
    curl https://cdn.rawgit.com/zsh-users/antigen/v1.0.4/antigen.zsh > ~/.antigen.zsh
fi

echo "Install ncurses library"
$install_cmd libncurses5-dev libncursesw5-dev

echo "Install scripting dev libraries"
$install_cmd python-dev python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev

echo "Install libx11 libs"
$install_cmd libx11-dev libxtst-dev

if hash ranger 2>/dev/null; then
    echo "+ ranger command was already installed....\t\tOK"
else
    echo "+ Installing ranger ..."
    $install_cmd ranger caca-utils highlight poppler-utils mediainfo
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

