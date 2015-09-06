#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
#echo $DIR
export TEXINPUTS="$DIR;.:"
texFiles=(*.tex)
numOfTexs=$(find -maxdepth 1 -name '*.tex' | wc -l)
if [ $numOfTexs -lt 1 ]; then
  echo No tex files in current directory
  exit 1
fi
if [ $numOfTexs -gt 1 ]; then
  if [ $# -lt 1 ]; then
    echo There are $numOfTexs tex files in current directory: ${texFiles[@]}
    echo Specify one as a command-line argument
    exit 1
  else
    texFile=$1
  fi
else
  texFile=${texFiles[0]}
fi

if [ ! -f $texFile ]; then
  echo file $texFile not found
  exit 1
fi

filename=$(basename "$texFile")
extension="${filename##*.}"
if [ "$extension" != "tex" ]; then
  echo $texFile has no tex extension
  exit 1
fi
echo processing $texFile
filename="${filename%.*}"
rm IEEEtran.bst
ln -s $DIR/IEEEtran.bst .
#rm IDAACS.cls
pdflatex --shell-escape $texFile
bibtex $filename.aux
pdflatex --shell-escape $texFile
pdflatex --shell-escape $texFile
result=${PWD##*/}
mv $filename.pdf $result.pdf
