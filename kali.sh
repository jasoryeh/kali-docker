#!/bin/bash

MAC_DONTSLEEPONCHARGER() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "(macOS) Setting your computer to not sleep on charger (you can revert these settings to your desired value in Settings > Battery > Options > Prevent automatic sleeping on power adapter when the display is off > Set to Off)"
        sudo pmset -c sleep 0
    fi
}

MAC_SLEEPONCHARGER() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "(macOS) Setting your computer to not sleep on charger (you can revert these settings to your desired value in Settings > Battery > Options > Prevent automatic sleeping on power adapter when the display is off)"
        sudo pmset -c sleep 1
    fi
}

KILL_CONTAINER() {
  echo "Killing Kali container..."
  docker rm -f kali-linux || true
  echo "Done!"
}

KILL() {
  echo "Exiting..."
  MAC_SLEEPONCHARGER
  KILL_CONTAINER
  exit 0
}

echo "$0 $1 - $*"
if [[ "$1" == "kill" ]]; then
    KILL
    echo "Exiting after removing container."
    exit 0
else
    KILL_CONTAINER
fi

CONTAINER="kali-local"

if [ ! -z $BUILD_KALI ]; then
    echo "BUILD_KALI specified- running Kali container build..."
    bash ~/Documents/kali/build.sh
fi

trap KILL SIGINT
echo "Running kali at $PWD"
docker run -d \
  --rm -it \
  --name=kali-linux \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=America/Los_Angeles \
  -e SUBFOLDER=/ \
  -e TITLE="Kali Linux" \
  -p 3000:3000 \
  -p 3001:3001 \
  -v ~/Documents/kali/config:/config \
  -v $PWD:/workspace \
  -v $PWD:/config/Desktop/workspace \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --shm-size="1gb" \
  $CONTAINER
#  --security-opt seccomp=unconfined \
#  --device /dev/dri:/dev/dri \

URL="http://localhost:3000"

until curl -s -f -o /dev/null "$URL"
do
  echo "Waiting for Kali container..."
  sleep 1
done

if [ -z $NOOPEN ]; then
    open $URL
fi

MAC_DONTSLEEPONCHARGER
docker logs -f -n 999999 kali-linux
# TODO: fix docker logs exiting the script above here
MAC_SLEEPONCHARGER

echo "Exiting Kali container.."
KILL
echo ""
