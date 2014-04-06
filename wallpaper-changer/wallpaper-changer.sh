#!/bin/bash

FOLDER=/home/mint/Obrázky/wallpapers

while true;do
	sleep 15
	PICTURE=$(ls $FOLDER/*.jpg | shuf -n1)

	gsettings set org.mate.background picture-filename $PICTURE
done
