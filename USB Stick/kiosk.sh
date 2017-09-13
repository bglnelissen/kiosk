#!/bin/bash
# b.nelissen

logger "Start kiosk"

# Kill all previous instances of open office
killall soffice

# Open open office
while true; do
  logger "Start slideshow"
  export DISPLAY=:0.0
  
  if [ -f /media/kiosk/kiosk.odp ]; then\
    logger "Found: /media/kiosk/kiosk.odp"
    soffice --impress --nologo --norestore --show /media/kiosk/kiosk.odp
  elif [ -f /media/kiosk/kiosk.ppt ]; then\
    logger "Found: /media/kiosk/kiosk.ppt"
    soffice --impress --nologo --norestore --show /media/kiosk/kiosk.ppt
  elif [ -f /media/kiosk/kiosk.pptx ]; then\
    logger "Found: /media/kiosk/kiosk.odp"
    soffice --impress --nologo --norestore --show /media/kiosk/kiosk.pptx
  else
    logger "No slideshow found... (odp, ppt or pptx)"
  fi

  # we landed here because the line above did exit...
  logger "Slideshow exit, restart"
  sleep 6
done