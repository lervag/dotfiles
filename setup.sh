#!/bin/bash
#
# Setup system files
#

function link
{
  #
  # Argument is only the filename of file to link relative to dotfiles
  # directory
  #
  file=$1
  dir=$(dirname $file)
  target=$PWD/$file
  link=~/.$file

  if [ "$safemode" -eq 1 ]; then
    echo " $link"
  else
    if [ ! -e $file ]; then
      echo "Error: File does not exist: $file"
      exit 1
    fi
    echo "  ~/.$file"
    remove_link $link
    safe_remove_file $link
    create_directory $dir
    ln -s $target $link
  fi
}
function remove_link
{
  [ -L $1 ] && rm $1
}
function safe_remove_file
{
  bfile=/tmp/$(basename $1)_$RANDOM
  if [ -e $1 ]; then
    mv $1 $bfile
    file_removed=1
  fi
}
function create_directory
{
  if [ ! "$1" = "." ]; then
    checkdir=$HOME/.$1
    [ -d "$checkdir" ] && return
    mkdir -p "$checkdir"
    dir_created=1
  fi
}

file_removed=0
dir_created=0
safemode=0
if [ "$#" -eq 0 -o "$1" != "-r" ]; then
  safemode=1
  echo "Please run the script with option -r to apply changes."
  echo "This run will only show which files will be linked."
fi

echo "Linking files"
for file in $(cat list-of-files.txt); do
  link ${file}
done

[ "$file_removed" -eq "1" ] && echo "Note: Some files were moved to /tmp"
[ "$dir_created"  -eq "1" ] && echo "Note: Some dirs were created"
