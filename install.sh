#!/bin/bash
set -x
export BASE=$(pwd)

# OhMyZsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
(cd "${HOME}/.oh-my-zsh" && git pull)

create_symlinks() {
    dotfiles_dir=$(dirname "$(readlink -f "$0")")
    for file in $(find -maxdepth 1 -type f -name ".*"); do
        name=$(basename $file)
        echo "Creating symlink to $name in home directory."
        rm -rf ~/$name
        ln -s $dotfiles_dir/$name ~/$name
    done
}
create_symlinks