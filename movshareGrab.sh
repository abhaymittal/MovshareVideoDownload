#! /bin/bash

# Bash scripts accepts a movshare url and downloads the corresponding video using aria2c

# Author: Abhay Mittal
url=$1
page_source=$(lynx -source "$url") # Grab the html source

#Grab the necessary parameters to identify video"
filekey=$(echo "$page_source" | grep "filekey")
file=$(echo "$page_source" | grep "file=")

filekey=${filekey:`expr index "$filekey" \"`}
filekey=${filekey:0:${#filekey}-2}

file=${file:`expr index "$file" \"`}
file=${file:0:${#file}-2}

echo $filekey
echo $file
echo `expr index "$filekey" .`
#target_page=$(lynx -source "www.movshare.net/api/player.api.php?key=$filekey&file=$file")

