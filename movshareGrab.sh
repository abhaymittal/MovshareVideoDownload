#! /bin/bash

# Bash scripts accepts a movshare url and downloads the corresponding video using aria2c

# Author: Abhay Mittal
url=$1
page_source=$(curl "$url") # Grab the html source

#Grab the necessary parameters to identify video"
filekey=$(echo "$page_source" | grep "filekey")
file=$(echo "$page_source" | grep "file=")

filekey=${filekey:`expr index "$filekey" \"`}
filekey=${filekey:0:${#filekey}-2}
filekey=${filekey//./%2E}

file=${file:`expr index "$file" \"`}
file=${file:0:${#file}-2}

echo "FILEKEY = $filekey"
echo "FILE = $file"

#Generate the target url
target_url=$(lynx -source "http://www.movshare.net/api/player.api.php?key=$filekey&file=$file")
target_url=${target_url:4}
target_url=${target_url:0:`expr index "$target_url" \&`-1}
#target_url=$(echo "http://$target_url")
echo "TARGET URL = $target_url"

#Grab File Name
file_name=$(echo $page_source | xmllint --html --xpath '/html/head/title/text()' - 2> /dev/null )
file_name=${file_name// /_}
echo "$file_name"

#Download the file
aria2c -o "$file_name" -s 5 "$target_url"
