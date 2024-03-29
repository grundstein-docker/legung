#!/usr/bin/env bash

HOSTS_DIR=hosts

CONTAINER_DIR=containers

CONTAINER_NAME="grundstein/legung"

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

function install() {
  ./bin/install.sh
}

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
  # magic-build
  nginx-build
}

function run() {
  redis-run
  postgres-run
  gitlab-run
  redmine-run
  # magic-run
  nginx-run
}

function network() {
  docker network create \
    --driver bridge \
    --subnet 172.18.0.0/24 \
    user-defined
}

function clean() {
  echo-start "clean"
  rm -f ./**/ENV.sh
  echo-finished "clean"
}

function ps() {
  docker ps
}

function stop() {
  echo-start "stopping containers"
  postgres-stop
  redis-stop
  nginx-stop
  gitlab-stop
  redmine-stop
  echo-finished "stopping containers"
}

function backup() {
  stop

  echo-start "creating backup"

  mkdir -p $BACKUP_DIR

  echo "start copying files"

  tar -cf ../backups/backup-$(date +\%Y-\%m-\%d-\%H-\%M-\%S).tar ../data/

  echo-finished "backup finished"

  run
  # sleep 30
  # nginx
}

function create-crontab() {
  echo-start "create crontab"

  CRONTAB_FILE=$PWD/crontab.txt

  rm -f $CRONTAB_FILE

  echo "23 05 * * * \"make -C ${PWD} backup\" > /dev/null" >> $CRONTAB_FILE

  crontab $CRONTAB_FILE

  echo-finished "create crontab"
}

function status() {
  echo-start "status"

  container-status

  # magic-status

  echo-finished "status"
}

function container-status() {
  echo-start "container-status"

  loop-dirs ./containers status

  echo-finished "container-status"
}

function container-update() {
  echo-start "container-update"

  loop-dirs ./containers update

  echo-finished "container-update"
}

function magic-status() {
  echo-start "magic-status"

  root_dir=./containers/magic
  make -C $root_dir status

  hosts_dir=$root_dir/hosts

  loop-dirs $hosts_dir status

  echo-finished "magic-status"
}

function magic-update() {
  echo-start "magic-update"

  root_dir=./containers/magic
  make -C $root_dir update

  hosts_dir=$root_dir/hosts

  loop-dirs $hosts_dir update

  echo-finished "magic-update"
}

function update() {
  echo-start "update"

  container-update

  # magic-update

  echo-finished "update"
}

# POSTGRES tasks

function postgres() {
  postgres-build
  postgres-run
  postgres-logs
}

function postgres-build() {
  make -C $POSTGRES_DIR build
}

function postgres-run() {
  make -C $POSTGRES_DIR run
}

function postgres-logs() {
  make -C $POSTGRES_DIR logs
}

function postgres-debug() {
  make -C $POSTGRES_DIR debug
}

function postgres-rm() {
  make -C $POSTGRES_DIR remove
}

function postgres-stop() {
  make -C $POSTGRES_DIR stop
}


# REDIS tasks

function redis() {
  redis-build
  redis-run
  redis-logs
}

function redis-build() {
  make -C $REDIS_DIR build
}

function redis-run() {
  make -C $REDIS_DIR run
}

function redis-logs() {
  make -C $REDIS_DIR logs
}

function redis-debug() {
  make -C $REDIS_DIR debug
}

function redis-rm() {
  make -C $REDIS_DIR remove
}

function redis-stop() {
  make -C $REDIS_DIR stop
}

# GITLAB tasks

function gitlab() {
  gitlab-run
  gitlab-logs
}

function gitlab-run() {
  make -C $GITLAB_DIR run
}

function gitlab-build() {
  make -C $GITLAB_DIR build
}

function gitlab-debug() {
  make -C $GITLAB_DIR debug
}

function gitlab-logs() {
  make -C $GITLAB_DIR logs
}

function gitlab-rm() {
  make -C $GITLAB_DIR remove
}

function gitlab-stop() {
  make -C $GITLAB_DIR stop
}

function gitlab-backup() {
  make -C $GITLAB_DIR backup
}


# REDMINE tasks

function redmine() {
  redmine-run
  redmine-logs
}


function redmine-run() {
  make -C $REDMINE_DIR run
}

function redmine-build() {
  make -C $REDMINE_DIR build
}

function redmine-debug() {
  make -C $REDMINE_DIR debug
}

function redmine-logs() {
  make -C $REDMINE_DIR logs
}

function redmine-rm() {
  make -C $REDMINE_DIR remove
}

function redmine-stop() {
  make -C $REDMINE_DIR stop
}

function redmine-backup() {
  make -C $REDMINE_DIR backup
}


# NGINX tasks

function nginx() {
  nginx-build
  nginx-run
  nginx-logs
}

function nginx-build() {
  make -C $NGINX_DIR build
}

function nginx-run() {
  make -C $NGINX_DIR run
}

function nginx-logs() {
  cd ${NGINX_DIR}; ./cli.sh logs
}

function nginx-debug() {
  make -C $NGINX_DIR debug
}

function nginx-rm() {
  make -C $NGINX_DIR remove
}

function nginx-clean() {
  make -C $NGINX_DIR clean
}

function nginx-stop() {
  make -C $NGINX_DIR stop
}


# MAGIC tasks

function magic() {
  magic-build
  magic-run
}

function magic-run() {
  make -C $MAGIC_DIR run
}

function magic-build() {
  make -C $MAGIC_DIR build
}

function magic-rm() {
  make -C $MAGIC_DIR remove
}

function magic-stop() {
  make -C $MAGIC_DIR stop
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

function remote-backup() {
	ssh  -p 2222 root@77.244.245.117 "cd /root/grundstein.legung && make backup"
}

function remote-retrieve() {
	scp -P 2222 root@77.244.245.117:`ssh  -p 2222 root@77.244.245.117 ls -dAprt /root/backups/* | tail -n 1` ../backups/
}

function remote-unpack() {
	tar xvf `ls -dAprt ../backups/* | tail -n 1` -C ../
}


if [ $1 ]
then
  function=$1
  shift
  $function $@
else
  help $@
fi
