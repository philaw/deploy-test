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

# v1.0.0, v1.5.2, etc.
versionLabel=$1

# establish branch and tag name variables
devBranch=develop
masterBranch=master
releaseBranch=release/$versionLabel
 
# create the release branch from the -develop branch
git checkout $releaseBranch
git pull --no-edit --ff
 
# merge release branch with the new version number into master
git checkout $masterBranch
git merge --no-edit --no-ff $releaseBranch
 
# create tag for new version from -master
git tag $versionLabel
git push origin $masterBranch
git push --tags
 
# merge release branch with the new version number back into develop
git checkout $devBranch
git merge --no-edit --no-ff $releaseBranch
git push origin $devBranch
 
# remove release branch
git branch -d $releaseBranch

	cd ..
	rm -rf $dir
done

