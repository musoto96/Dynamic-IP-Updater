#!/usr/bin/bash

# 
#  Quick and dirty utility for building, pruning and runing
# ipupdt docker image for debugging in text based environments.
# 
#  Usage:
# To use first comment out the line 
#      await browser.close();
# and uncomment the next one
#      await page.screenshot({path: 'ss.png'});
# in ipupdt.js
# 
#   Description:
#  The script builds a new image, prunes the old one, runs 
#  the new one, takes a screenshot and copies it over from 
#  the docker container into the host machine, stopping the 
#  container afterwards.
# 
# 
#     ~Moisés Uriel Soto Pedrero.
#       github.com/musoto96
# 


echo "Building new image"
docker build -t ipupdt:latest ./

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
