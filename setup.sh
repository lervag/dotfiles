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

  #
  # Check if argument file does not exist
  #
  if [ ! -e $file ]; then
    echo "File does not exist: $file"
    exit 1
  fi

  #
  # Initial output
  #
  echo "Linking: ~/.$file"

  #
  # Create directory if needed
  #
  [ ! "$dir" = "." ] && [ ! -d "$dir" ] && mkdir -p $dir

  #
  # Check if file is already present
  #
  [ -L $link ] && remove_link $link
  [ -e $link ] && safe_remove_file $link

  #
  # Create link
  #
  ln -s $target $link
}
function remove_link
{
  echo "  -- Removed old link"
  rm $1
}
function safe_remove_file
{
  bfile=/tmp/$(basename $1)_$RANDOM
  echo " -- Backup of existing file: $bfile"
  mv $1 $bfile
}

files=$(find -type f ! -path "./.*" ! -name "setup.sh")
for file in $files; do
  link ${file:2}
done
