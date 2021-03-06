#!/bin/bash
# b. nelissen

# example: find . -name "git.sh" -exec {} "update script"  \;

# memo:
# add the dir on the server: ~/git/project.git
# add the server as a remote: git remote add pi "bas@guu.st:git/project.git"
# do the first commit manually: git add . ; git commit -a -m "initial commit" ; git push pi master

# set file variables
CURRENTDIR="$(pwd)"
FILE="$0"
FILEFULL="$(echo "$(cd "$(dirname "$FILE")"; pwd)"/"$(basename "$FILE")")" # full path $FULL
DIRNAME="$(dirname "$FILEFULL")"      # dirname

# start
clear
echo "Running: ""$FILE"

# change to working dir
cd "$DIRNAME"
if [ 0 == $? ]; then
  echo "Succes: changed working dir to: ""$(pwd)"; echo "-------"; echo
else
  echo "FAIL: could not change working directory"; exit 1
fi

# easy GIT upload script for KoekoekPi
commitmessage="$@"

while [[ "" == "$commitmessage" ]]; do
  read -p "Commit message: " commitmessage
done

# git pull
git pull pi master
if [ 0 == $? ]; then
  echo "Succes: git pull pi master"; echo "-------"; echo
else
  echo "FAIL: git pull pi master"; exit 1
fi

# git status
git status
if [ 0 == $? ]; then
  echo "Succes: git status"; echo "-------"; echo
  git add *
else
  echo "FAIL: git status"; exit 1
fi

# # git add
# git add *
# if [ 0 == $? ]; then
#   echo "Succes: git add *"; echo "-------"; echo
#   git commit -m "$commitmessage"
# else
#   echo "FAIL: git add *"; exit 1
# fi

# git commit
git commit -a -m "$commitmessage"
if [ 0 == $? ]; then
  echo "Succes: git commit -a -m "$commitmessage""; echo "-------"; echo
  git push pi master
fi

# git push
git push pi master
if [ 0 == $? ]; then
  echo "Succes: git push pi master"; echo "-------"; echo
fi

# change working dir back to previous one
cd "$CURRENTDIR"
if [ 0 == $? ]; then
  echo "Succes: changed working dir back to: ""$(pwd)"; echo "-------"; echo
else
  echo "FAIL: could not change working directory"; exit 1
fi

# fin
echo "Succes: all done."; echo "-------"; echo