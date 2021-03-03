#!/bin/bash
set -x

if [ -z "$1" ]
  then
    echo "You must supply a branch name. eg: bash helm_update.sh my_branch mynamespace [--set/--set-file etc...]"
    exit
fi

if [ -z "$2" ]
  then
    echo "You must supply a namespace. eg: bash helm_update.sh my_branch mynamespace [--set/--set-file etc...]"
    exit
fi

BASEDIR=$(pwd)
BRANCHDIR="$BASEDIR/branches/$1"


helm upgrade --install "$2-gxy-rls" -n "$2" "$BRANCHDIR/galaxy-helm/galaxy/" -f "$BRANCHDIR/values.yaml" -f "$BRANCHDIR/extra-values.yaml" --create-namespace ${@:3}
