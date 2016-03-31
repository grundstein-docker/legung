#!/bin/bash

SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPT_PATH=$(dirname "$SCRIPT")

function logs() {
  echo "connecting to container logs: $CONTAINER_NAME"
  docker logs --follow $CONTAINER_NAME
}

function stop() {
  echo "stopping $CONTAINER_NAME"
  docker stop $CONTAINER_NAME \
  && echo "stopped $CONTAINER_NAME" \
  || echo "container $CONTAINER_NAME not started"
}

function debug() {
  $PWD/cli.sh remove
  $PWD/cli.sh build

  echo "connecting to container $CONTAINER_NAME"
  docker run \
    --interactive \
    --tty \
    --name "$CONTAINER_NAME" \
    --entrypoint=sh "$CONTAINER_NAME"
}

function remove() {
  echo "removing container $CONTAINER_NAME"
  stop \
  && docker rm $CONTAINER_NAME \
  && echo "removed $CONTAINER_NAME" \
  || echo "container $CONTAINER_NAME does not exist"
}

function ip() {
  ip=$(python $PWD/../../bin/ip.py $CONTAINER_NAME)
  echo "container $CONTAINER_NAME ip: $ip"
  echo $ip > $PWD/SERVER_IP
}

function loop-dirs() {
  echo "START: loop over hosts in dir $1 with make task $2"
  root_dir=$1
  task=$2

  for sub_dir in $(ls $root_dir); do \
    full_dir=$root_dir/$sub_dir
    if [ -f $full_dir/Makefile ]; then
      echo "running 'make $task' in $full_dir"
      make -C $full_dir $task
      echo "SUCCESS: 'make $task' finished"
    else
      echo "FAIL: no Makefile found in: $full_dir"
    fi
  done

  echo "FINISHED: loop over hosts"
}
