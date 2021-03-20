#!/usr/bin/bash

echo "Building new image"
docker build -t musoto96/ipupdt:1.0 ./

echo "Pruning old images"
echo "y" | docker image prune

IMG=$(docker image ls | grep ipupdt | awk '{print $3}')
echo "New image id: $IMG"

docker run --rm -d $IMG

CTR=$(docker ps | grep $IMG | awk '{print $1}')
echo "New container id: $CTR"

while [ true ]
do
  docker cp $CTR:/app/ss.png ./ 2>/dev/null
  if [ $? -eq 0 ]
  then
    break
  else
    sleep 1
  fi
done

echo "Stopping container"
docker container stop $CTR
