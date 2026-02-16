#!/bin/bash

echo "Select an option:"
echo "1) Push Dotfiles"
echo "2) Pull Dotfiles"
echo "3) Exit"

read -p "Enter your choice (1/2/3): " choice

#alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"
#alias dotfiles="
case $choice in
    1)
        echo "Pushing Dotfiles..."
        /usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME add -u :/ -v
        /usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME commit -m "Updated"
        /usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME push --set-upstream origin master
        
        #dotfiles add -u :/ -v
        #dotfiles commit -m "Updated"
        #dotfiles push --set-upstream origin master
        ;;
    2)
        echo "Pulling Dotfiles..."
        dotfiles fetch origin
        dotfiles reset --hard
        dotfiles pull
        ;;
    3)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid option. Please try again."
        ;;
esac
