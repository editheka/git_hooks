#!/bin/bash 

#this script gets the list of hooks in the .hook directory and  

BASE_FOLDER=$(git rev-parse --show-toplevel)

cd $BASE_FOLDER/.hooks

list_of_files=`ls -p | grep -v /`

echo "Adding a soft link for the folloiwng hooks in the $BASE_FOLDER/.git/hooks"
for file in $list_of_files; do 
  echo $file  
  ln -sf ../../.hooks/$file $BASE_FOLDER/.git/hooks
done

