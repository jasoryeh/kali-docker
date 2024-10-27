#!/bin/bash

KILL_CONTAINER() {
  echo "Killing Kali container..."
  docker rm -f kali-linux || true
  echo "Done!"
}

KILL() {
  echo "Exiting..."
  KILL_CONTAINER
  exit 0
}

if [ ! -z $BUILD_KALI ]; then
    echo "BUILD_KALI specified- running Kali container build..."
    bash ~/Documents/kali/build.sh
fi

CONTAINER="kali-local"

KILL_CONTAINER

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

docker logs -f -n 999999 kali-linux

# TODO: fix docker logs exiting the script above here

echo "Exiting Kali container.."
KILL
echo ""
