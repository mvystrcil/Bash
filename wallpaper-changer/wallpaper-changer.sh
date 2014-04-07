#!/bin/bash

function changeWallpaper {
	PICTURE=$(ls $FOLDER/*.jpg | shuf -n1)
	EVAL="$COMMAND$PICTURE"
        eval "$EVAL"
}

# Support more desktop managers - automatically choose available one
# Please keep order in SET<-->GET arrays
GET_COMMANDS=("gsettings get org.mate.background picture-filename"
		"gsettings get org.gnome.desktop.background picture-uri")

SET_COMMANDS=("gsettings set org.mate.background picture-filename "
		"gsettings set org.gnome.desktop.background picture-uri file://")

CRON=""

# Parse input arguments if any
while getopts f:t:c option
do
        case "${option}"
        in
		c ) CRON="EXIT"
			;;
                f ) FOLDER=${OPTARG}
                        ;;
                t ) TIME=${OPTARG}
                        ;;
                * ) echo -e "Usage: $0 [-f folder -t timeout -c]"
		    echo -e "\t -f folder with wallpapers to change between"
		    echo -e "\t -t specify timeout how fast change"
		    echo -e "\t -c only if used in cron"
                        exit
                        ;;
        esac
done

# User didn't specified Wallpapers folder - try to use some default
if [ -z $FOLDER ]; then
	# Check for default PICTURE directory location
	if [ -z $XDG_PICTURES_DIR ]; then
	        source ~/.config/user-dirs.dirs

		if [ $? -ne 0 ]; then
			echo "Cannot dedicate default wallpaper path - you have to specify some"
			exit
		else
			FOLDER=$XDG_PICTURES_DIR
		fi
	else
		FOLDER=$XDG_PICTURES_DIR
	fi
fi

# User didn't specified timeout - set some default
if [ -z $TIME ]; then
	TIME=60
fi

# Figure out which environment should be used
for command in ${!GET_COMMANDS[*]}
do
	eval "${GET_COMMANDS[$command]}" > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		COMMAND="${SET_COMMANDS[$command]}"
		break
	fi
done

echo "Wallpapers from: $FOLDER"
echo "Timeout change: $TIME"

if [ "$CRON" == "EXIT" ];then
	changeWallpaper
	exit
fi

# Change wallpaper in loop
while true;do
	sleep $TIME
	changeWallpaper
done
