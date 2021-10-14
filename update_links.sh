#!/bin/bash
set -x

if [ -z "$3" ]
  then
    echo "You must supply a branch, domain, and path. eg: bash update_links.sh my_branch my.domain.com /galaxypath [origin/dev]. Hint: use 192.168.2.2.xip.io for IPs"
    exit
fi

if [ -z "$4" ]
  then
    BASE_REF="origin/dev"
  else
    BASE_REF=$4
fi

BASEDIR=$(pwd)
BRANCHDIR="$BASEDIR/branches/$1"

cd "$BRANCHDIR/galaxy"

# Abort if anything but modified and added

abort=$(git diff --name-status $BASE_REF "$1" | cut -c1 | grep -E "C|D|R|T|U|X|B" )

if [[ -n $abort ]]; then

    echo "This experimental version only supports adding and modifying files"
    exit
fi

echo "Making list"
git diff --name-only "$BASE_REF" "$1" > "$BRANCHDIR/filelist"
git diff --name-only >> "$BRANCHDIR/filelist"
sort -u "$BRANCHDIR/filelist" > "$BRANCHDIR/unique"
cat "$BRANCHDIR/unique"

cd ../../..

echo "Deleting old extra files directory"
rm -rf "$BRANCHDIR/galaxy-helm/galaxy/extrafiles"


cat <<EOF > "$BRANCHDIR/extra-values.yaml"
extraFileMappings:
EOF

while IFS="" read -r p || [ -n "$p" ]
do
  mkdir -p "$BRANCHDIR/galaxy-helm/galaxy/extrafiles/""$(dirname "$p")"
  ln -s "$BRANCHDIR/galaxy/$p" "$BRANCHDIR/galaxy-helm/galaxy/extrafiles/$p"
  cat <<EOF >> "$BRANCHDIR/extra-values.yaml"
  /galaxy/server/$p:
    useSecret: false
    applyToJob: true
    applyToWeb: true
    applyToWorkflow: true
    tpl: true
    content: |
      {{- (.Files.Get "extrafiles/$p") }}
EOF
done < "$BRANCHDIR/unique"

DOMAIN="$2"
SANITIZED_DOMAIN=$(echo "$2" | sed "s/\./-/g" )

sed "s/domain\.example\.com/$2/g" galaxy-values.yaml | sed "s/domain-example-com/$SANITIZED_DOMAIN/g" | sed "s#\/examplepath#$3#g" > "$BRANCHDIR/values.yaml"

rm "branches/$1/filelist"
rm "branches/$1/unique"
