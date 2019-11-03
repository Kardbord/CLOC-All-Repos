#!/bin/bash

function fail {
    echo "$0 failed for some reason"
    exit 1
}

if [ -z "$1" ];
then
    echo "No arguments supplied. Provide a GitHub username."
    exit 1
fi

# Create a temporary directory to work in
TEMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'cloc_tmp')

# Make sure our workspace gets cleaned up on exit
trap 'rm -rf $TEMP_DIR' EXIT

if [ ! -d "$TEMP_DIR" ]; then
    echo "Failed to create temporary directory, quitting..."
    exit 1
fi

pushd "$TEMP_DIR" > /dev/null 2>&1 || fail

if ! wget https://api.github.com/users/"${1}"/repos > /dev/null 2>&1
then
    echo "Failed to access the GitHub API page for GitHub user $1."
    exit 1
fi

grep clone_url repos | tr -s " " | cut -d" " -f3 | sed s/,// | sed s/\"//g > "$TEMP_DIR/strippedRepos.txt"

while read -r repo; do
    git clone "$repo"
done < "$TEMP_DIR/strippedRepos.txt"

echo -e "\n(Cloned repos will be deleted automatically)\n\n\n"

echo -e "Counting lines of code...\n"

#cloc . --exclude-ext=xml
#cloc . --exclude-ext=json
cloc .

popd > /dev/null 2>&1 || fail

