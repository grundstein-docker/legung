#!/bin/bash


SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPT_PATH=$(dirname "$SCRIPT")

function logs() {
  echo-start $@

  docker logs --follow $CONTAINER_NAME

  echo-finished $@
}

function stop() {
  echo-start $@

  docker stop $CONTAINER_NAME \
  && echo "stopped $CONTAINER_NAME" \
  || echo "container $CONTAINER_NAME not started"

  echo-finished $@
}

function debug() {
  remove
  build

  echo-start $@

  docker run \
    --interactive \
    --tty \
    --name "$CONTAINER_NAME" \
    --entrypoint=sh "$CONTAINER_NAME"

  echo-finished $@
}

function remove() {
  echo-start $@
  stop \
  && docker rm $CONTAINER_NAME \
  && echo "removed $CONTAINER_NAME" \
  || echo "container $CONTAINER_NAME does not exist"

  echo-finished $@
}

function ip() {
  echo-start $@

  ip=$(python $PWD/../../bin/ip.py $CONTAINER_NAME)
  echo "container $CONTAINER_NAME ip: $ip"
  echo $ip > $PWD/SERVER_IP

  echo-finished $@
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
