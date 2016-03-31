CLI=./cli.sh

.PHONY: \
	help \
	all \
	env \
	deploy \
	build \
	run \
	stop \
	ps \
	postgres \
	postgres-build \
	postgres-run \
	postgres-logs \
	postgres-rm \
	postgres-debug \
	redis \
	redis-build \
	redis-run \
	redis-logs \
	redis-rm \
	redis-debug \
	nginx \
	nginx-build \
	nginx-run \
	nginx-logs \
	nginx-rm \
	nginx-debug \
	magic \
	magic-build \
	magic-run \
	magic-debug \
	magic-logs \
	magic-rm \
	magic-stop \
	gitlab \
	gitlab-build \
	gitlab-run \
	gitlab-logs \
	gitlab-rm \
	gitlab-debug \
	redmine \
	redmine-build \
	redmine-run \
	redmine-logs \
	redmine-rm \
	redmine-debug


# general

all: help

deploy:
	@${CLI} deploy

env:
	@${CLI} env

build:
	@${CLI} build

run:
	@${CLI} run

clean:
	@${CLI} clean

ps:
	@docker ps

stop:
	@${CLI} stop

backup:
	@${CLI} backup

crontab:
	@${CLI} crontab


# POSTGRES tasks

postgres:
	@${CLI} postgres

postgres-build:
	@${CLI} postgres-build

postgres-run:
	@${CLI} postgres-run

postgres-logs:
	@${CLI} postgres-logs

postgres-debug:
	@${CLI} postgres-debug

postgres-rm:
	@${CLI} postgres-rm

postgres-stop:
	@${CLI} postgres-stop


# REDIS tasks

redis:
	@${CLI} redis

redis-build:
	@${CLI} redis-build

redis-run:
	@${CLI} redis-run

redis-logs:
	@${CLI} redis-logs

redis-debug:
	@${CLI} redis-debug

redis-rm:
	@${CLI} redis-rm

redis-stop:
	@${CLI} redis-stop

# GITLAB tasks

gitlab:
	@${CLI} gitlab

gitlab-build:
	@${CLI} gitlab-build

gitlab-run:
	@${CLI} gitlab-run

gitlab-logs:
	@${CLI} gitlab-logs

gitlab-debug:
	@${CLI} gitlab-debug

gitlab-rm:
	@${CLI} gitlab-rm

gitlab-stop:
	@${CLI} gitlab-stop

# NGINX tasks

nginx:
	@${CLI} nginx

nginx-build:
	@${CLI} nginx-build

nginx-run:
	@${CLI} nginx-run

nginx-logs:
	@${CLI} nginx-logs

nginx-debug:
	@${CLI} nginx-debug

nginx-rm:
	@${CLI} nginx-rm

nginx-stop:
	@${CLI} nginx-stop

nginx-clean:
	@${CLI} nginx-clean


# MAGIC tasks

magic:
	@${CLI} magic

magic-run:
	@${CLI} magic-run

magic-build:
	@${CLI} magic-build

magic-rm:
	@${CLI} magic-remove

magic-stop:
	@${CLI} magic-stop


# REDMINE tasks

redmine:
	@${CLI} redmine

redmine-build:
	@${CLI} redmine-build

redmine-run:
	@${CLI} redmine-run

redmine-logs:
	@${CLI} redmine-logs

redmine-debug:
	@${CLI} redmine-debug

redmine-rm:
	@${CLI} redmine-rm

redmine-stop:
	@${CLI} redmine-stop

# container git helpers

git-status-containers:
	@${CLI} git-status-containers

git-pull-containers:
	@${CLI} git-pull-containers


# help output

help:
	@${CLI} help

help-postgres:
	@./postgres/cli.sh help

help-redis:
	@./redis/cli.sh help

help-gitlab:
	@./gitlab/cli.sh help

help-nginx:
	@./nginx/cli.sh help

help-redmine:
	@./redmine/cli.sh help

help-magic:
	@./magic/cli.sh help
