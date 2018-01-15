#!/bin/bash

cwd=`pwd`

while read line
do
  repos+=( "$line" )
done < $cwd/repos.txt

# repos="git@github.com:philaw/sample1.git
# git@github.com:philaw/sample2.git"

echo $cwd

for repo in "${repos[@]}"
do
	echo "$repo"
	dir=$(echo "$repo" | sed -e 's,.*/\(.*\).git,\1,')
	echo "Removing existing dir: $dir"
	rm -rf $dir
	git clone "$repo"
	cd $dir
	echo "In dir: $dir"

# current Git branch
branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')

# TODO: resion from a version controlled config file
# v1.0.0, v1.5.2, etc.
versionLabel=$1

# establish branch and tag name variables
devBranch=develop
masterBranch=master
releaseBranch=release/$versionLabel
 
git checkout $devBranch
git pull --no-edit --ff

# create the release branch from the -develop branch
git checkout -b $releaseBranch $devBranch
 
# merge release branch with the new version number into master
git push --set-upstream origin $releaseBranch

# some manual steps, fixes, testing etc
# release-finish will take from here

	cd ..
	rm -rf $dir

done

