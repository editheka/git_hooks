#!/bin/bash 

#This script syncronises the managed hooks in the .hooks directory with the hooks in the .git/hooks direcotry
#If a new hook is added to the .hooks direcotry it will autamatically be added in form of a soft link to the .git/hooks direcotry
#if a hook is removed from the .hooks direcotry it will autamatically be removed also from the .git/hooks direcotory (the soft link will be removed
#if a hook is accidentaly added in the .git/hooks direcotry and not in the .hooks direcotry, the hook in .git/hooks will be automatically removed
#the output of added or removed hooks will be provided to the user

Red=$'\e[1;31m'
Green=$'\e[1;32m'
Blue=$'\e[1;34m'

declare -a LIST_OF_HOOKS_TO_BE_DELETED
declare -a LIST_OF_HOOKS_TO_BE_ADDED

BASE_DIRECTORY=$(git rev-parse --show-toplevel)

list_of_managed_hooks=`ls -p $BASE_DIRECTORY/.hooks | grep -v /` #getting only files and not directories "ls -p adds / at the end of directories. Grep -v allows to excloud names that contain / from the listing.
list_of_hook_in_git_directory=`ls $BASE_DIRECTORY/.git/hooks`


adding_new_managed_hooks_to_git_hooks_directory() {  
  let i=0
  for hook in $list_of_managed_hooks; do
    check_if_hook_in_git_hooks=`echo $list_of_hook_in_git_directory | grep -w $hook` #checking if $hook is in .git/hooks directory 
    if [[ $check_if_hook_in_git_hooks == '' ]]; then
      ln -sf $BASE_DIRECTORY/.hooks/$hook $BASE_DIRECTORY/.git/hooks #adding a soft link of the new hook to the .git/hooks directory
      LIST_OF_HOOKS_TO_BE_ADDED[i]="${hook}"
      ((i++))
    fi
  done
  
  if [ "${#LIST_OF_HOOKS_TO_BE_ADDED[@]}" != "0" ]; then
    printf "$Green%s\n" "Adding the following hooks from $BASE_DIRECTORY/.hooks:"
    printf "$Green%s\n" "${LIST_OF_HOOKS_TO_BE_ADDED[@]}"
  fi

}

removing_old_hooks_from_git_hooks_direcotry() {
  let i=0
  for hook in $list_of_hook_in_git_directory; do 
    check_if_hook_in_managed_hooks=`echo $list_of_managed_hooks | grep -w $hook`
    if [[ $check_if_hook_in_managed_hooks == '' ]]; then
      rm  $BASE_DIRECTORY/.git/hooks/$hook
      LIST_OF_HOOKS_TO_BE_DELETED[i]="${hook}"
      ((i++))
    fi
  done
  
  if [ "${#LIST_OF_HOOKS_TO_BE_DELETED[@]}" != "0" ]; then
    printf "$Red%s\n" "Deleting the following hooks from $BASE_DIRECTORY/.git/hooks:"
    printf "$Red%s\n" "${LIST_OF_HOOKS_TO_BE_DELETED[@]}"
  fi
}

sync_managed_hooks_with_hooks_in_git_hook_direcotry() {

adding_new_managed_hooks_to_git_hooks_directory
removing_old_hooks_from_git_hooks_direcotry

}


main() {
  sync_managed_hooks_with_hooks_in_git_hook_direcotry
  
  echo -e "\033[0m"
}
main $@ 

 
