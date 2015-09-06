#!/bin/bash
if [ $# -ne 1 ]; then
  echo no file specified
  exit 1
fi
if [ ! -f $1 ]; then
  echo file $1 not found
  exit 1
fi
baseFilename=$(basename "$1")
extension="${baseFilename##*.}"
filename="${baseFilename%.*}"
#echo $extension
if [ "$extension" != "zip" ]; then
  echo $1 has no zip extension
  exit 1
fi

mkdir $filename
cd $filename
unzip ../$baseFilename

