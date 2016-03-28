HOSTS_DIR=hosts

NGINX_DIR=nginx
REDIS_DIR=redis
POSTGRES_DIR=postgres
GITLAB_DIR=gitlab
REDMINE_DIR=redmine
MONGO_DIR=mongodb
MAGIC_DIR=magic
BACKUP_DIR=../backups

.PHONY: \
	help \
	all \
	ips \
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
	mongo \
	mongo-build \
	mongo-run \
	mongo-logs \
	mongo-rm \
	mongo-debug \
	redmine \
	redmine-build \
	redmine-run \
	redmine-logs \
	redmine-rm \
	redmine-debug \
	hosts \
	hosts-build \
	hosts-run

# general

all: help

deploy:
	@${MAKE} \
		env \
		ips \
		build \
		run

env:
	@./bin/create_env.sh

ips:
	@./bin/create_ip_env.sh

build:
	@${MAKE} \
		redis-build \
		postgres-build \
		gitlab-build \
		redmine-build \
		nginx-build

run:
	@${MAKE} \
		redis-run \
		postgres-run

	@./bin/create_ip_env.sh

	@${MAKE} \
		gitlab-run \
		redmine-run \

	@./bin/create_ip_env.sh

	@${MAKE} \
		nginx-run

clean:
	@echo "removing configuration files:"
	@echo "$$(ls -l ./**/ENV.sh)"
	@rm -f ./**/ENV.sh

ps:
	@docker ps

stop:
	@${MAKE} -j5 \
		postgres-stop \
		redis-stop \
		nginx-stop \
		gitlab-stop \
		redmine-stop

backup: gitlab-backup redmine-backup
	echo "creating backup"

	mkdir -p ${BACKUP_DIR}

	echo "start copying files"
	cp -rf ./* ${BACKUP_DIR}
	echo "finished copying files"

	echo "committing changes"
	cd ${BACKUP_DIR}; \
	git init && \
	git add -A ./* && \
	git commit -m "backup $$(date +\%Y-\%m-\%d-\%H:\%M:\%S)" ./*

	echo "backup finished"

	${MAKE} ips nginx

init:
	@./bin/init.sh all

init_submodules:
	@./bin/init.sh init_submodules

crontab:
	@./bin/create_crontab.sh

update_submodules:
	@./bin/init.sh update_submodules

# POSTGRES tasks

postgres: postgres-build postgres-run postgres-logs

postgres-build:
	@cd ${POSTGRES_DIR}; ./cli.sh build

postgres-run:
	@cd ${POSTGRES_DIR}; ./cli.sh run

postgres-logs:
	@cd ${POSTGRES_DIR}; ./cli.sh logs

postgres-debug:
	@cd ${POSTGRES_DIR}; ./cli.sh debug

postgres-rm:
	@cd ${POSTGRES_DIR}; ./cli.sh remove

postgres-stop:
	@cd ${POSTGRES_DIR}; ./cli.sh stop


# REDIS tasks

redis: redis-build redis-run redis-logs

redis-build:
	@cd ${REDIS_DIR}; ./cli.sh build

redis-run:
	@cd ${REDIS_DIR}; ./cli.sh run

redis-logs:
	@cd ${REDIS_DIR}; ./cli.sh logs

redis-debug:
	@cd ${REDIS_DIR}; ./cli.sh debug

redis-rm:
	@cd ${REDIS_DIR}; ./cli.sh remove

redis-stop:
	@cd ${REDIS_DIR}; ./cli.sh stop


# GITLAB tasks

gitlab: gitlab-run gitlab-logs

gitlab-run:
	@cd ${GITLAB_DIR}; ./cli.sh run

gitlab-build:
	@cd ${GITLAB_DIR}; ./cli.sh build

gitlab-debug:
	@cd ${GITLAB_DIR}; ./cli.sh debug

gitlab-logs:
	@cd ${GITLAB_DIR}; ./cli.sh logs

gitlab-rm:
	@cd ${GITLAB_DIR}; ./cli.sh remove

gitlab-stop:
	@cd ${GITLAB_DIR}; ./cli.sh stop

gitlab-backup:
	@cd ${GITLAB_DIR}; ./cli.sh backup

# NGINX tasks

nginx: nginx-build nginx-run nginx-logs

nginx-build:
	@cd ${NGINX_DIR}; ./cli.sh build

nginx-run:
	@cd ${NGINX_DIR}; ./cli.sh run

nginx-logs:
	cd nginx; ./cli.sh logs

nginx-debug:
	@cd ${NGINX_DIR}; ./cli.sh debug

nginx-rm:
	@cd ${NGINX_DIR}; ./cli.sh remove

nginx-clean:
	@cd ${NGINX_DIR}; ./cli.sh clean

nginx-stop:
	@cd ${NGINX_DIR}; ./cli.sh stop


# REDMINE tasks

redmine: redmine-build redmine-run redmine-logs

redmine-run:
	@cd ${REDMINE_DIR}; ./cli.sh run

redmine-logs:
	@cd ${REDMINE_DIR}; ./cli.sh logs

redmine-build:
	@cd ${REDMINE_DIR}; ./cli.sh build

redmine-debug:
	@cd ${REDMINE_DIR}; ./cli.sh debug

redmine-rm:
	@cd ${REDMINE_DIR}; ./cli.sh remove

redmine-stop:
	@cd ${REDMINE_DIR}; ./cli.sh stop

redmine-backup:
	@cd ${REDMINE_DIR}; ./cli.sh backup


# MONGODB tasks

mongo: mongo-build mongo-run mongo-logs

mongo-run:
	@cd ${MONGO_DIR}; ./cli.sh run

mongo-logs:
	@cd ${MONGO_DIR}; ./cli.sh logs

mongo-build:
	@cd ${MONGO_DIR}; ./cli.sh build

mongo-debug:
	@cd ${MONGO_DIR}; ./cli.sh debug

mongo-rm:
	@cd ${MONGO_DIR}; ./cli.sh remove

mongo-stop:
	@cd ${MONGO_DIR}; ./cli.sh stop

# MAGIC tasks

magic: magic-build magic-run

magic-run:
	@cd ${MAGIC_DIR}; ./cli.sh run

magic-build:
	@cd ${MAGIC_DIR}; ./cli.sh build

magic-rm:
	@cd ${MAGIC_DIR}; ./cli.sh remove

magic-stop:
	@cd ${MAGIC_DIR}; ./cli.sh stop


# help output

help:
	@echo "\
GrundSteinLegung V0.0.1 Help \n\
Usage \n\
make TASK\n\
deploy    - runs and builds all containers \n\
build     - builds all containers \n\
run       - runs all containers \n\
ps        - show all running containers \n\
env       - generates environment vars for all containers \n\
ips       - gathers ip addresses of all containers \n\
stop      - stop all containers \n\
\n\
TASKS \n\
postgres redis gitlab redmine magic nginx \n\
run make TASK to build and run this \n\
\n\
SUBTASKS \n\
Usage \n\
  make TASK-SUBTASK \n\
  example make nginx-build \n\
\n\
  run   - run the container \n\
  build - build the container \n\
  debug - drop into a container bash \n\
  log   - tail the container logs \n\
\n\
HELP TASKS \n\
help           - this help text \n\
\n\
help-postgres  - postgres cli help \n\
help-redis     - redis cli help \n\
help-gitlab    - gitlab cli help \n\
help-redmine   - redmine cli help \n\
help-magic     - magic cli help \n\
help-nginx - nginx cli help \n\
"

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
