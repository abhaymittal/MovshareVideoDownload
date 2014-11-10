#! /bin/bash

# Bash scripts accepts a movshare url and downloads the corresponding video using aria2c

# Author: Abhay Mittal
url=$1
page_source=$(curl -s "$url") # Grab the html source

#Grab the video site domain name
domain=$(echo "$page_source" | grep "domain=");
domain=${domain:`expr index "$domain" \"`}
domain=${domain:0:${#domain}-2}
echo $domain

#Grab the necessary parameters to identify video"
filekey=$(echo "$page_source" | grep "filekey")
file=$(echo "$page_source" | grep "file=")


filekey=${filekey:`expr index "$filekey" =`}
filekey=${filekey:0:${#filekey}-1}

#Check if the filekey is stored indirectly in a variable. Happens in case of nowvideo
if [[ $filekey != \"* ]]
then
    filekey=$(echo "$page_source" | grep "var $filekey=")
    filekey=${filekey:`expr index "$filekey" =`}
    filekey=${filekey:0:${#filekey}-1}
    
fi
filekey=${filekey:`expr index "$filekey" \"`}
filekey=${filekey:0:${#filekey}-1}
filekey=${filekey//./%2E}

file=${file:`expr index "$file" \"`}
file=${file:0:${#file}-2}


echo "FILEKEY = $filekey"
echo "FILE = $file"


#Generate the target url
target_url=$(lynx -source  "$domain/api/player.api.php?key=$filekey&file=$file")
target_url=${target_url:4}
target_url=${target_url:0:`expr index "$target_url" \&`-1}
echo "TARGET URL = $target_url"

#Grab File Name
file_name=$(echo $page_source | xmllint --html --xpath '/html/head/title/text()' - 2> /dev/null )
file_name=${file_name// /_}
file_name=$(echo "$file_name.flv")

#Download the file
aria2c -o "$file_name" -x 5 -s 5 "$target_url"
