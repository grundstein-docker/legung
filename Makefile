CLI=./cli.sh

.PHONY: \
	help \
	all \
	env \
	install \
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

install:
	@${CLI} $@

deploy:
	@${CLI} $@

env:
	@${CLI} $@

build:
	@${CLI} $@

run:
	@${CLI} $@

clean:
	@${CLI} $@

ps:
	@docker ps

stop:
	@${CLI} $@

backup:
	@${CLI} $@

create-crontab:
	@${CLI} $@


# POSTGRES tasks

postgres:
	@${CLI} postgres

postgres-build:
	@${CLI} $@

postgres-run:
	@${CLI} $@

postgres-logs:
	@${CLI} $@

postgres-debug:
	@${CLI} $@

postgres-rm:
	@${CLI} $@

postgres-stop:
	@${CLI} $@


# REDIS tasks

redis:
	@${CLI} $@

redis-build:
	@${CLI} $@

redis-run:
	@${CLI} $@

redis-logs:
	@${CLI} $@

redis-debug:
	@${CLI} $@

redis-rm:
	@${CLI} $@

redis-stop:
	@${CLI} $@

# GITLAB tasks

gitlab:
	@${CLI} $@

gitlab-build:
	@${CLI} $@

gitlab-run:
	@${CLI} $@

gitlab-logs:
	@${CLI} $@

gitlab-debug:
	@${CLI} $@

gitlab-rm:
	@${CLI} $@

gitlab-stop:
	@${CLI} $@

# NGINX tasks

nginx:
	@${CLI} $@

nginx-build:
	@${CLI} $@

nginx-run:
	@${CLI} $@

nginx-logs:
	@${CLI} $@

nginx-debug:
	@${CLI} $@

nginx-rm:
	@${CLI} $@

nginx-stop:
	@${CLI} $@

nginx-clean:
	@${CLI} $@


# MAGIC tasks

magic:
	@${CLI} $@

magic-run:
	@${CLI} $@

magic-build:
	@${CLI} $@

magic-rm:
	@${CLI} $@

magic-stop:
	@${CLI} $@


# REDMINE tasks

redmine:
	@${CLI} $@

redmine-build:
	@${CLI} $@

redmine-run:
	@${CLI} $@

redmine-logs:
	@${CLI} $@

redmine-debug:
	@${CLI} $@

redmine-rm:
	@${CLI} $@

redmine-stop:
	@${CLI} $@

# container git helpers

update:
	@${CLI} $@

status:
	@${CLI} $@

container-status:
	@${CLI} $@

container-update:
	@${CLI} $@


# help output

help:
	@${CLI} $@

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

remote-backup:
	ssh  -p 2222 root@77.244.245.117 "cd /root/grundstein.legung && make backup"

copy-latest-backup:
	echo "$(shell  ssh  -p 2222 root@77.244.245.117 ls -dAprt /root/backups/* | tail -n 1)"
	scp -P 2222 root@77.244.245.117:"$(shell  ssh  -p 2222 root@77.244.245.117 ls -dAprt /root/backups/* | tail -n 1)" ../backups/ 

unpack-latest-backup:
	#echo "$(shell cd ../ && ls -dAprt backups/* | tail -n 1)"
	tar xvf "$(shell ls -dAprt ../backups/* | tail -n 1)" -C ../

