#!/bin/bash
PRESET=fast
CRF=24
PARAMS=vbv-maxrate=32768:vbv-bufsize=8192
THREADS=16

FILES=$1
for f in $FILES
do
  LEN=`expr length $f`
  NF=${f:0:($LEN - 4)}

  echo "file: $f"

#ffmpeg -y -i $f -c:v libx265 -x265-params pass=1:$PARAMS -preset $PRESET -crf $CRF -threads $THREADS -c:a aac -b:a 128k -f mp4 -strict -2 -passlogfile $f.x265 /dev/null
#ffmpeg -y -i $f -c:v libx265 -x265-params pass=2:$PARAMS -preset $PRESET -crf $CRF -threads $THREADS -c:a aac -b:a 128k -f mp4 -strict -2 -passlogfile $f.x265 $NF.hevc.mp4

  HandBrakeCLI -i $f -o $NF.hevc.mp4 -m -E copy –audio-copy-mask ac3,dts,dtshd –audio-fallback ffac3 --two-pass --turbo --use-opencl -e x265 -q $CRF -x $PARAMS

done
