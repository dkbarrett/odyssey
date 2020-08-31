#!/bin/bash

xvfbMaxStartWaitTime=120
displayNumber=99
screenNumber=0

echo "Starting Xvfb on display ${displayNumber}"
start-stop-daemon --start --pidfile ~/xvfb.pid --make-pidfile --background --exec /usr/bin/Xvfb -- :${displayNumber} -screen ${screenNumber} 1024x768x24  -ac +extension GLX +render -noreset

# Wait to be able to connect to the port. This will exit if it cannot in 2 minutes.
timeout ${xvfbMaxStartWaitTime} bash -c "while  ! xdpyinfo -display :${displayNumber} >/dev/null; do sleep 0.5; done"
if [ $? -ne 0 ]; then
  echo "Could not connect to display ${displayNumber} in ${xvfbMaxStartWaitTime} seconds time."
  exit 1
fi

export DISPLAY=:${displayNumber}.${screenNumber}

cd /opt/odyssey/bin
./odyssey

start-stop-daemon --stop --retry 5 --pidfile ~/xvfb.pid # stop xvfb when exiting
rm ~/xvfb.pid