#!/bin/bash
if [ -z "$1" ]
then
    echo "No arguments supplied. Provide a GitHub username."
    exit 1
fi
wget https://api.github.com/users/${1}/repos 
grep clone_url repos | tr -s " " | cut -d" " -f3 | sed s/,// | sed s/\"//g > strippedRepos.txt 
mkdir ./cloned_repos 
pushd ./cloned_repos 
# loop through file and clone all repos 
while read repo;
do
    git clone $repo
    #echo $repo
done < ../strippedRepos.txt
printf "(Cloned repos will be deleted automatically)\n\n\n" 
cloc . --exclude-ext=xml 
popd 
rm -rf cloned_repos/ 
rm strippedRepos.txt 
rm repos
