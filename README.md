# grundsteinlegung

Grundstein (plural Grundsteine) [german]

* A ceremonial stone set at the corner of a building.

* By extension, that which is prominent, fundamental, noteworthy, or central.
Exceptional service is the cornerstone of the hospitality industry.
That is the cornerstone of any meaningful debate about budgets and projects, regulations and policies.

via: [wiktionary](https://en.wiktionary.org/wiki/grundstein)

runs docker instances of the various webservices we use:
* [gitlab](https://github.com/grundstein/gitlab)
* [redmine](https://github.com/grundstein/redmine)
* [nginx](https://github.com/grundstein/nginx)
* [redis](https://github.com/grundstein/redis)
* [postgres](https://github.com/grundstein/postgres)

wip:
* [postfix](https://github.com/grundstein/postfix)
* [mongodb](https://github.com/grundstein/mongodb)
* [rocketchat](https://github.com/grundstein/rocketchat)
* mariadb
* wordpress

#### Usage:
```bash
  # run docker containers
  git clone git@github.com:grundstein/legung grundstein.legung
  cd grundstein.legung

  # install the docker containers
  make install

  # build and run all containers
  make deploy

  # stop containers
  make stop

  # remove containers
  make remove

  # update containers
  make update

  # stop, then backup, then restart containers:
  make backup

```
