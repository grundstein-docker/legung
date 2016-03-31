#!/usr/bin/env bash

HOSTS_DIR=hosts

CONTAINER_DIR=containers

NGINX_DIR=$CONTAINER_DIR/nginx
REDIS_DIR=$CONTAINER_DIR/redis
POSTGRES_DIR=$CONTAINER_DIR/postgres
GITLAB_DIR=$CONTAINER_DIR/gitlab
MONGO_DIR=$CONTAINER_DIR/mongodb
MAGIC_DIR=$CONTAINER_DIR/magic
REDMINE_DIR=$CONTAINER_DIR/redmine

BACKUP_DIR=../backups

source ./bin/tasks.sh

# general

function deploy() {
  env
  build
  run
}

function env() {
  ./bin/create_env.sh
}

function build() {
  redis-build
  postgres-build
  gitlab-build
  redmine-build
  magic-build
  nginx-build
}

function run() {
  redis-run
  postgres-run
  gitlab-run
  redmine-run
  magic-run
  nginx-run
}

function clean() {
  echo "removing configuration files:"
  echo "$$(ls -l ./**/ENV.sh)"
  rm -f ./**/ENV.sh
}

function ps() {
  docker ps
}

function stop() {
  postgres-stop
  redis-stop
  nginx-stop
  gitlab-stop
}

function backup() {
  gitlab-backup

  echo "creating backup"

  mkdir -p $BACKUP_DIR

  echo "start copying files"
  cp -rf ./* $BACKUP_DIR/grundstein/
  cp -rf ../data $BACKUP_DIR/
  echo "finished copying files"

  echo "committing changes"
  cd $BACKUP_DIR && \
  git init && \
  git add -A ./* && \
  git commit -m "backup $$(date +\%Y-\%m-\%d-\%H:\%M:\%S)" ./*

  echo "backup finished"

  nginx
}

function crontab() {
  ./bin/create_crontab.sh
}

function git-status-containers() {

  for container_dir in $(ls ./containers/); do \
    if [ -d ./containers/$container_dir ]; then
      cd ./containers/$container_dir && git status && cd ../../
    fi
  done
}

function update-containers() {
  loop-dirs ./containers update
}

function update-magic() {

  root_dir=./containers/magic
  make -C $root_dir update

  hosts_dir=$root_dir/hosts

  loop-dirs $hosts_dir update
}

function update() {
  update-containers

  update-magic

}

# POSTGRES tasks

function postgres() {
  postgres-build
  postgres-run
  postgres-logs
}

function postgres-build() {
  cd $POSTGRES_DIR; ./cli.sh build; cd ../..
}

function postgres-run() {
  cd $POSTGRES_DIR; ./cli.sh run; cd ../..
}

function postgres-logs() {
  cd $POSTGRES_DIR; ./cli.sh logs; cd ../..
}

function postgres-debug() {
  cd $POSTGRES_DIR; ./cli.sh debug; cd ../..
}

function postgres-rm() {
  cd $POSTGRES_DIR; ./cli.sh remove; cd ../..
}

function postgres-stop() {
  cd $POSTGRES_DIR; ./cli.sh stop; cd ../..
}


# REDIS tasks

function redis() {
  redis-build
  redis-run
  redis-logs
}

function redis-build() {
  cd ${REDIS_DIR} && ./cli.sh build; cd ../..
}

function redis-run() {
  cd ${REDIS_DIR} && ./cli.sh run; cd ../..
}

function redis-logs() {
  cd ${REDIS_DIR} && ./cli.sh logs; cd ../..
}

function redis-debug() {
  cd ${REDIS_DIR} && ./cli.sh debug; cd ../..
}

function redis-rm() {
  cd ${REDIS_DIR} && ./cli.sh remove; cd ../..
}

function redis-stop() {
  cd ${REDIS_DIR} && ./cli.sh stop; cd ../..
}

# GITLAB tasks

function gitlab() {
  gitlab-run
  gitlab-logs
}

function gitlab-run() {
  cd ${GITLAB_DIR} && ./cli.sh run; cd ../..
}

function gitlab-build() {
  cd ${GITLAB_DIR} && ./cli.sh build; cd ../..
}

function gitlab-debug() {
  cd ${GITLAB_DIR} && ./cli.sh debug; cd ../..
}

function gitlab-logs() {
  cd ${GITLAB_DIR} && ./cli.sh logs; cd ../..
}

function gitlab-rm() {
  cd ${GITLAB_DIR} && ./cli.sh remove; cd ../..
}

function gitlab-stop() {
  cd ${GITLAB_DIR} && ./cli.sh stop; cd ../..
}

function gitlab-backup() {
  cd ${GITLAB_DIR} && ./cli.sh backup; cd ../..
}


# REDMINE tasks

function redmine() {
  redmine-run
  redmine-logs
}


function redmine-run() {
  cd ${REDMINE_DIR} && ./cli.sh run; cd ../..
}

function redmine-build() {
  cd ${REDMINE_DIR} && ./cli.sh build; cd ../..
}

function redmine-debug() {
  cd ${REDMINE_DIR} && ./cli.sh debug; cd ../..
}

function redmine-logs() {
  cd ${REDMINE_DIR} && ./cli.sh logs; cd ../..
}

function redmine-rm() {
  cd ${REDMINE_DIR} && ./cli.sh remove; cd ../..
}

function redmine-stop() {
  cd ${REDMINE_DIR} && ./cli.sh stop; cd ../..
}

function redmine-backup() {
  cd ${REDMINE_DIR} && ./cli.sh backup; cd ../..
}


# NGINX tasks

function nginx() {
  nginx-build
  nginx-run
  nginx-logs
}

function nginx-build() {
  cd ${NGINX_DIR} && ./cli.sh build; cd ../..
}

function nginx-run() {
  cd ${NGINX_DIR} && ./cli.sh run; cd ../..
}

function nginx-logs() {
  cd ${NGINX_DIR}; ./cli.sh logs; cd ../..
}

function nginx-debug() {
  cd ${NGINX_DIR} && ./cli.sh debug; cd ../..
}

function nginx-rm() {
  cd ${NGINX_DIR} && ./cli.sh remove; cd ../..
}

function nginx-clean() {
  cd ${NGINX_DIR} && ./cli.sh clean; cd ../..
}

function nginx-stop() {
  cd ${NGINX_DIR} && ./cli.sh stop; cd ../..
}


# MAGIC tasks

function magic() {
  magic-build
  magic-run
}

function magic-run() {
  cd ${MAGIC_DIR} && ./cli.sh run; cd ../..
}

function magic-build() {
  cd ${MAGIC_DIR} && ./cli.sh build; cd ../..
}

function magic-rm() {
  cd ${MAGIC_DIR} && ./cli.sh remove; cd ../..
}

function magic-stop() {
  cd ${MAGIC_DIR} && ./cli.sh stop; cd ../..
}

# help output

function help() {
  echo "\
GrundSteinLegung V0.0.1 Help
Usage
make TASK
deploy    - runs and builds all containers
build     - builds all containers
run       - runs all containers
ps        - show all running containers
env       - generates environment vars for all containers
stop      - stop all containers

TASKS:
postgres redis gitlab magic nginx

Usage:
  make TASK
  example make nginx

  SUBTASKS:
  Usage:
    make TASK-SUBTASK
    example make nginx-build

    run   - run the container
    build - build the container
    debug - drop into a container bash
    log   - tail the container logs

HELP TASKS
help           - this help text

some container provide additional tasks,
see the help tasks for more info:

help-postgres  - postgres cli help
help-redis     - redis cli help
help-gitlab    - gitlab cli help
help-magic     - magic cli help
help-nginx - nginx cli help \
"
}

function help-postgres() {
  ./postgres/cli.sh help
}

function help-redis() {
  ./redis/cli.sh help
}

function help-gitlab() {
  ./gitlab/cli.sh help
}

function help-nginx() {
  ./nginx/cli.sh help
}

function help-magic() {
  ./magic/cli.sh help
}


if [ $1 ]
then
  function=$1
  shift
  $function $@
else
  help $@
fi
