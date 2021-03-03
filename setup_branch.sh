#!/bin/bash
set -x

if [ -z "$1" ]
  then
    echo "You must supply a branch name. eg: bash setup_branch.sh my_branch"
    exit
fi

echo "Creating directory ${pwd}/branches/$1"
mkdir -p "branches/$1"
cd "branches/$1"
echo "Pulling repos"
git clone -b "dev" --single-branch https://github.com/galaxyproject/galaxy &
git clone -b "master" --single-branch https://github.com/galaxyproject/galaxy-helm
cd galaxy-helm
git checkout -b "$1"
cd ..
wait
cd galaxy
git checkout -b "$1"
cd ..
