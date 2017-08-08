#!/bin/bash

if [ $1 == ""]; then
  echo "Symlinking based off of s2017 folder structure"
  PCL_DIR="../pcl"
else
  PCL_DIR="$1"
fi

for i in ` find $PCL_DIR/gpu/kinfu_large_scale/* -type d -maxdepth 0` ; do
  ln  -s $i ./
done

