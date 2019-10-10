#!/bin/bash
set -x

valid_branches=("staging" "master")
tag=$(echo $CODEBUILD_WEBHOOK_TRIGGER | cut -d / -f2)
vars=$(git log -1 "refs/tags/$tag" --decorate=short | awk -F'[()]' '{print $2}')
IFS=, read -ra arr <<< "$vars"
echo $vars
branch=$(echo "${arr[@]:(-1)}" | sed 's/ //g' | | cut -d / -f2)
echo $branch
echo "$tag belongs to $branch"
if [ "$branch" = "HEAD" ]; then branch=master; fi
for var in $valid_branches;
do
    if [ "$var" = "$branch" ]; then
        echo "Tagging branch- $branch"
        export BRANCH=$branch
        break
    fi
done

if [ -z $BRANCH ]; then 
  echo "tag $tag is not belongs to \"${branches[*]}\""; 
else 
  echo "tag $tag is valid to deploy";
  echo "export BRANCH=$branch" >> ./build_scripts/variables.sh
fi
