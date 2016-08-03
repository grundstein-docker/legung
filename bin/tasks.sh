#!/bin/bash

function logs() {
  echo-start "logs"

  docker logs --follow $CONTAINER_NAME

  echo-finished "logs"
}

function stop() {
  echo-start "stop"

  docker stop $CONTAINER_NAME \
  && echo "stopped $CONTAINER_NAME" \
  || echo "container $CONTAINER_NAME not started"

  echo-finished "stop"
}

function debug() {
  remove
  build

  echo-start "debug"

  docker run \
    --interactive \
    --tty \
    --name "$CONTAINER_NAME" \
    --entrypoint=sh "$CONTAINER_NAME"

  echo-finished "debug"
}

function remove() {
  echo-start "remove"
  stop \
  && docker rm $CONTAINER_NAME \
  && echo "removed $CONTAINER_NAME" \
  || echo "container $CONTAINER_NAME does not exist"

  echo-finished "remove"
}

function ip() {
  echo-start "get ip"

  ip=$(python $PWD/../../bin/ip.py $CONTAINER_NAME)
  echo "container $CONTAINER_NAME ip: $ip"
  echo $ip > $PWD/SERVER_IP

  echo-finished "get ip"
}

function loop-dirs() {
  echo-start "loop over hosts in dir $1 with make task $2"
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

  echo-finished "loop over hosts"
}

function update() {
  echo-start "update"

  git pull

  echo-finished "update"
}

function status() {
  echo-start "status"

  git status

  echo-finished "status"
}

function echo-start() {
  echo "START: $@ in $CONTAINER_NAME"
}

function echo-finished() {
  echo "FINISHED: $@ in $CONTAINER_NAME"
}

function echo-success() {
  echo "SUCCESS: $@ in $CONTAINER_NAME"
}

function echo-fail() {
  echo "FAIL: $@ in $CONTAINER_NAME"
}
