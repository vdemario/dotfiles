function disable-auto-focus
	if test -e /usr/bin/v4l2-ctl
		# find out which /dev/videoN the logitech camera is on	
		set dev_video_id (/usr/bin/v4l2-ctl --list-devices | grep 'C920' -A 1 | grep '/dev/' | cut -d '/' -f 3)
		
		# disable the auto focus
		/usr/bin/v4l2-ctl -d /dev/$dev_video_id --set-ctrl=focus_auto=0
	end
end
