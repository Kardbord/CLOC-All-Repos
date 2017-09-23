#!/bin/bash

wget https://api.github.com/users/Kardbord/repos
grep clone_url repos | tr -s " " | cut -d" " -f3 | sed s/,// > strippedRepos.txt
mkdir ./cloned_repos
pushd ./cloned_repos
# loop through file and clone all repos
# printf "(Cloned repos will be deleted automatically)"\n\n\n"
# cloc .
# popd
# rm -rf cloned_repos/
