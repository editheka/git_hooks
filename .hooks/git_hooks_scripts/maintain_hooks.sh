#!/bin/bash 

#This script maintains git hooks by removing from the .git/hook directory 
#those hooks wich are not longer in the .hook folder. It also adds a soft
#link of new hooks in the .hooks directory to the .git/hooks directory
#the script outputs to the user the hooks that have been removed and 
#those which have been added 

Red=$'\e[1;31m'
Green=$'\e[1;32m'
Blue=$'\e[1;34m'


BASE_DIRECTORY=$(git rev-parse --show-toplevel)

list_of_hooks_manged=`ls -p $BASE_DIRECTORY/.hooks | grep -v /`
list_of_hook_in_git_directory=`ls $BASE_DIRECTORY/.git/hooks`

declare -a LIST_OF_HOOKS_TO_BE_DELETED 
declare -a LIST_OF_HOOKS_TO_BE_ADDED

#this function loads the list of hooks into the following Array LIST_OF_HOOKS_TO_BE_DELETED an array has been used in order to modify the original data gatherad by ls ./git/hook

load_data() {
  let i=0
  for hook in $list_of_hook_in_git_directory; do 
    LIST_OF_HOOKS_TO_BE_DELETED[i]="${hook}"
    ((i++))
  done

  let i=0
  for hook in $list_of_hooks_manged; do
    LIST_OF_HOOKS_TO_BE_ADDED[i]="${hook}"
    ((i++))
  done
}

#this function deletes all the hooks in .git/hook directory that are note anymore available in the .hook directory

cleanup_hooks() {
  
#comparing if hooks in the .hoook direcotry are also in ./git/hook directory.
#if they are they will be removed from the array LIST_OF_HOOKS_TO_BE_DELETED 
#In this way it is possible to have the list of hooks in .git/hooks directory
#that are not anymore in the .hook directory. This list will be used to identify and delete these hooks

  for hook in $list_of_hooks_manged; do
    let i=0
    for git_hook in $list_of_hook_in_git_directory; do
      if [ "$hook" == "$git_hook" ]; then
        unset -v LIST_OF_HOOKS_TO_BE_DELETED[$i]
      fi
      ((i++))
      done
    done

#deleting hooks and showing which hooks are being deleted
#Deleting is executed only if the LIST_OF_HOOKS_TO_BE_DELETED array is not empty

   if [ "${#LIST_OF_HOOKS_TO_BE_DELETED[@]}" != "0" ]; then
     echo "$Red Deleting the following hooks from $BASE_DIRECTORY/.git/hooks:"
     for hook in ${LIST_OF_HOOKS_TO_BE_DELETED[@]}; do
       echo " $hook"  
       rm  $BASE_DIRECTORY/.git/hooks/$hook 
     done
   fi
 }   

#this function adds to the .git/hooks directory new hooks created in the .hook directory

add_new_hooks() {
  let i=0
  for hook in $list_of_hooks_manged; do
    for git_hook in $list_of_hook_in_git_directory; do
      if [ "$hook" == "$git_hook" ]; then
        unset -v LIST_OF_HOOKS_TO_BE_ADDED[$i]
      fi
      done
    ((i++))
    done
   
   if [ "${#LIST_OF_HOOKS_TO_BE_ADDED[@]}" != "0" ]; then
     echo "$Green Adding a soft link for the folloiwng hooks in the $BASE_DIRECTORY/.git/hooks:"
     for hook in ${LIST_OF_HOOKS_TO_BE_ADDED[@]}; do
       echo " $hook"
       ln -sf ../../.hooks/$hook $BASE_DIRECTORY/.git/hooks
   done
   fi
}

main() {

  load_data
  cleanup_hooks
  add_new_hooks
  
  echo -e "\033[0m"

}

main $@ 

 
