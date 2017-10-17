#!/bin/bash

if [ $# -eq 0 ] || [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]
  then
    echo "Invalid arguments supplied."
    echo "Usage: enc-web.sh <source video file> <MP4 video output file> <WEBM VP9 video output file>"
    exit 1;
fi

THREADS=8

ffmpeg -y -i $1 -vf scale=1920x1080 -c:v libx264 -preset medium -b:v 1500k -maxrate 3M -bufsize 2M -pass 1 -threads $THREADS -acodec aac -profile:v baseline -level 3.0 -pix_fmt yuv420p -f mp4 -strict -2 -passlogfile x264 /dev/null
ffmpeg -i $1 -vf scale=1920x1080 -c:v libx264 -movflags +faststart -preset medium -b:v 1500k -maxrate 3M -bufsize 2M -threads $THREADS -acodec aac -profile:v baseline -level 3.0 -pix_fmt yuv420p -f mp4 -strict -2 -passlogfile x264 $2

ffmpeg -y -i $1 -vf scale=1920x1080 -b:v 1800k -minrate 900k -maxrate 2610k -tile-columns 2 -g 240 -threads $THREADS -quality good -crf 31 -c:v libvpx-vp9 -c:a libopus -pass 1 -speed 4 -pix_fmt yuv420p -f webm /dev/null
ffmpeg -i $1 -vf scale=1920x1080 -b:v 1800k -minrate 900k -maxrate 2610k -tile-columns 4 -g 240 -threads $THREADS -quality good -crf 31 -c:v libvpx-vp9 -c:a libopus -pass 2 -pix_fmt yuv420p -speed 4 -f webm $3
