#!/bin/bash

# Copyright 2017 Théo Chamley
# Permission is hereby granted, free of charge, to any person obtaining a copy of 
# this software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
# to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or
# substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
# BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,


echo "============= ALL Images"
docker images
echo "============="

echo "# delete not keep images" > /tmp/clean-docker.txt
docker images >> /tmp/clean-docker.txt
sed 's/^REPOSITORY/# REPOSITORY/g' /tmp/clean-docker.txt > /tmp/clean-docker.txt.s
mv /tmp/clean-docker.txt.s /tmp/clean-docker.txt
vim /tmp/clean-docker.txt
IMAGES=`cat /tmp/clean-docker.txt | sed '/^#/d'| sed -e 's/[ ][ ]*/:/g' | cut -d ':' -f1-2`

echo "This will remove all your current containers and images except for:"
echo "============= Not Delete Images"
cat /tmp/clean-docker.txt | sed 's/^# REPOSITORY/REPOSITORY/g' | sed '/^#/d'
echo "============="
read -p "Are you sure? [yes/NO] " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

TMP_DIR=$(mktemp -d)

pushd $TMP_DIR >/dev/null

open -a Docker
echo "=> Saving the specified images"
for image in ${IMAGES}; do
    echo "==> Saving ${image}"
    tar=$(echo -n ${image} | base64)
    docker save -o ${tar}.tar ${image}
    echo "==> Done."
done

echo "=> Cleaning up"
echo -n "==> Quiting Docker"
osascript -e 'quit app "Docker"'
while docker info >/dev/null 2>&1; do
    echo -n "."
    sleep 1
done;
echo ""

echo "==> Removing Docker.qcow2 file"
rm ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/Docker.qcow2

echo "==> Launching Docker"
open -a Docker
echo -n "==> Waiting for Docker to start"
until docker info >/dev/null 2>&1; do
    echo -n "."
    sleep 1
done;
echo ""

echo "=> Done."

echo "=> Loading saved images"
for image in ${IMAGES}; do
    echo "==> Loading ${image}"
    tar=$(echo -n ${image} | base64)
    docker load -q -i ${tar}.tar || exit 1
    echo "==> Done."
done

popd >/dev/null
rm -r ${TMP_DIR}
