#!/bin/bash
set -x

if [ -z "$3" ]
  then
    echo "You must supply a branch name and two directory paths. eg: bash symlink_branch.sh my_branch /path/to/galaxy /path/to/galaxy-helm"
    exit
fi

echo "Creating directory $(pwd)/branches/$1"
mkdir -p "branches/$1"
echo "Symlinking repos"
ln -s "$2" "$(pwd)/branches/$1/galaxy"
ln -s "$3" "$(pwd)/branches/$1/galaxy-helm"
cd "branches/$1/galaxy"
git checkout -b $1
cd "../galaxy-helm"
git checkout -b $1
cd ../../..
