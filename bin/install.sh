#!/usr/bin/env bash

GIT_CLONE="git clone https://github.com"
GIT_USER=grundstein

CONTAINER_DIR=containers
MAGIC_HOSTS=containers/magic/hosts

$GIT_CLONE/$GIT_USER/redis ./$CONTAINER_DIR/redis
$GIT_CLONE/$GIT_USER/postgres ./$CONTAINER_DIR/postgres
$GIT_CLONE/$GIT_USER/gitlab ./$CONTAINER_DIR/gitlab
$GIT_CLONE/$GIT_USER/redmine ./$CONTAINER_DIR/redmine
$GIT_CLONE/$GIT_USER/magic ./$CONTAINER_DIR/magic
$GIT_CLONE/$GIT_USER/nginx ./$CONTAINER_DIR/nginx

$GIT_CLONE/wiznwit/wiznwit.com ./$MAGIC_HOSTS/wiznwit.com
$GIT_CLONE/wiznwit/wizardsat.work ./$MAGIC_HOSTS/wizardsat.work
