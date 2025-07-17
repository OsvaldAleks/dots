#!/bin/bash

## Get data
STATUS="$(playerctl status)"
MUSIC_DIR="$HOME/Apps/utils"

## Get status
get_status() {
	if [[ $STATUS == *"Playing"* ]]; then
		echo $STATUS
	else
		echo Paused
	fi
}

## Get song
get_song() {
	song=`playerctl metadata title`
	if [[ -z "$song" ]]; then
		echo "Offline"
	else
		echo "$song"
	fi	
}

## Get artist
get_artist() {
	artist=`playerctl metadata artist`
	if [[ -z "$artist" ]]; then
		echo "Offline"
	else
		echo "$artist"
	fi	
}

## Get time
get_time() {
	time=`playerctl position`
	if [[ -z "$time" ]]; then
		echo "0"
	else
		echo "$time"
	fi	
}
get_ftime() {
	ftime=`playerctl metadata | grep length | awk '{ print $3 }'`
	if [[ -z "$ftime" ]]; then
		echo "1"
	else
		echo "$ftime"
	fi	
}

## Get cover
get_cover() {
	TIME=$(get_time)  

	if [[ "$1" == "--force" ]]; then
		NEW_SONG="1"
	else
		NEW_SONG="$(echo $TIME  1 | awk '{if (($1 < $2)) print 1; else print 0}')"
	fi

	ERRS=$?
	if [ "$NEW_SONG" -eq 1 ]; then
		IMAGE_URL="$(playerctl metadata | grep artUrl | awk '{print $3}')"
		curl -o $MUSIC_DIR/media-thumbnail.jpg $IMAGE_URL
		ERRS=$?
	fi

	# Check if the file has been downloaded
	if [ "$ERRS" -eq 0 ];then
		echo $MUSIC_DIR/media-thumbnail.jpg
	else
		echo $MUSIC_DIR/generic.jpg
	fi
}

## Control toggles
toggle_shuffle(){
	STATE="$(playerctl shuffle)"
	if [[ "$STATE" == "On" ]]; then
		playerctl shuffle Off
	else
		playerctl shuffle On
	fi
}

toggle_loop(){
	STATE="$(playerctl loop)"
	if [[ "$STATE" == "None" ]]; then
		playerctl loop playlist
	else
		playerctl loop none
	fi
}

## Execute accordingly
if [[ "$1" == "--song" ]]; then
	get_song
elif [[ "$1" == "--artist" ]]; then
	get_artist
elif [[ "$1" == "--status" ]]; then
	get_status
elif [[ "$1" == "--time" ]]; then
	get_time
elif [[ "$1" == "--length" ]]; then
	get_ftime
elif [[ "$1" == "--settime" ]]; then
	playerctl position $2
elif [[ "$1" == "--cover" ]]; then
	get_cover $2
elif [[ "$1" == "--getShuffle" ]]; then
	playerctl shuffle
elif [[ "$1" == "--toggleShuffle" ]]; then
	toggle_shuffle
elif [[ "$1" == "--getLoop" ]]; then
	playerctl loop
elif [[ "$1" == "--toggleLoop" ]]; then
	toggle_loop
elif [[ "$1" == "--toggle" ]]; then
	playerctl play-pause
elif [[ "$1" == "--next" ]]; then
	{ playerctl next; }
elif [[ "$1" == "--prev" ]]; then
	{ playerctl previous; }
fi