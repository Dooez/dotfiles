#!/bin/sh
sed -i \
         -e 's/#242730/rgb(0%,0%,0%)/g' \
         -e 's/#c1bab3/rgb(100%,100%,100%)/g' \
    -e 's/#1c1f26/rgb(50%,0%,0%)/g' \
     -e 's/#d9b445/rgb(0%,50%,0%)/g' \
     -e 's/#22252d/rgb(50%,0%,50%)/g' \
     -e 's/#c1bab3/rgb(0%,0%,50%)/g' \
	"$@"
