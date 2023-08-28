function config-webcam
	if count $argv > /dev/null
		set zoom $argv
	else
		set zoom 120
	end

	# test the binary exists
	if not test -e /usr/bin/v4l2-ctl
		echo "v4l2-ctl not found" >&2
		return 1
	end

	# v4l2-ctl exists, but we'll use the alias that discards stderr messages

	# find out which /dev/videoN the logitech camera is on	
	set dev_video_id (v4l2 --list-devices | grep 'C920' -A 1 | grep '/dev/' | cut -d '/' -f 3)
	
	# disable the auto focus
	v4l2 --device=/dev/$dev_video_id --set-ctrl=focus_auto=0
	
	# set zoom to focus only on the face
	v4l2 --device=/dev/$dev_video_id --set-ctrl=zoom_absolute=$zoom
end
