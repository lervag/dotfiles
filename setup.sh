#!/bin/sh
#

# Create backupdir
bdir=old_dotfiles
mkdir -p $bdir

#
# Simple dotfiles
#
files="bashrc \
  cvsignore \
  bashrc \
  cvsignore \
  gitconfig \
  hgk \
  hgrc \
  inputrc \
  irbrc \
  latexmkrc \
  mailrc \
  sbclrc \
  screenrc \
  toprc \
  xsessionrc \
  zshenv \
  zshrc \
  dircolors.ansi-dark \
  reference.bib \
  tecplot.cfg \
  tmux.conf \
  clisprc.lisp"
for file in $files; do
  rootfile=~/.$file
  thisfile=$PWD/$file
  if [ -L $rootfile ]; then
    echo "Removing old symbolic link $rootfile"
    rm $rootfile
  elif [ -e $rootfile ]; then
    echo "Moving old $rootfile to backupdir"
    mv $rootfile $bdir/$file
  fi

  echo "Linking $file -> ~/.$file"
  ln -s $thisfile $rootfile
done

#
# ssh files
#
sshdir=~/.ssh
sshconfig=~/.ssh/config
if [ -d $sshdir ]; then
  if [ -L $sshconfig ]; then
    echo "Removing old symbolic link $sshconfig"
    rm $sshconfig
  elif [ -e $sshconfig ]; then
    echo "Moving old $sshconfig to backupdir"
    mv $sshconfig $backupdir
  fi
else
  mkdir $sshdir
fi
echo "Linking ssh/config -> ~/.ssh/config"
ln -s $PWD/ssh/config $sshdir/config
