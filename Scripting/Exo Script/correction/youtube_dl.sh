#!/bin/bash
url_encode=${1// /+}
url_prefix="https://www.youtube.com/results?search_query=$url_encode"
echo "Searching url : $url_prefix"
matches=$(curl -s $url_prefix | grep -Eo "\/watch\?v=[0-9A-Za-z]+")
url_suffix=$(echo $matches | cut -d " " -f 1)
video_full_url="https://www.youtube.com$url_suffix"
echo "Video url : $video_full_url"
yt-dlp -x $video_full_url --audio-format mp3 -o $url_encode.mp3