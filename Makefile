#!/usr/bin/make
#@ FaceBox

#@ Commands:
.PHONY: help-env
SHELL := /bin/bash

CONTEXT_FACEBOX := $(or $(CONTEXT_FACEBOX),${PWD})
CONTEXT_BACKEND := $(or $(CONTEXT_BACKEND),$(CONTEXT_FACEBOX)/src)
CONTEXT_NOTEBOOKS := $(or $(CONTEXT_NOTEBOOKS),$(CONTEXT_FACEBOX)/notebooks)

-include ${CONTEXT_FACEBOX}/.env
export
include */Makefile


#- Check if required parameter has been set
check-%:
	@test -n "${$(*)}"

#- Show all commands.
help:
	@awk '{ if (match(lastLine, /^#- (.*)/)) printf "- %s: %s\n", substr($$1, 0, index($$1, ":")-1), substr(lastLine, RSTART + 3, RLENGTH); else if (match($$0, /^[a-zA-Z\-\_0-9]+:/)) printf "- %s:\n", substr($$1, 0, index($$1, ":")-1); else if (match($$0, /^#@ (.*)/)) printf "%s\n", substr($$0, RSTART + 3, RLENGTH); } { lastLine = $$0 }' $(MAKEFILE_LIST)

init:
# 	@docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD} https://${DOCKER_REGISTRY}
	@cd ${CONTEXT_FACEBOX} && \
	docker-compose pull

build:
	@cd ${CONTEXT_FACEBOX} && \
	docker-compose build

run: check-JUPYTER_PORT
	@cd ${CONTEXT_FACEBOX} && \
	docker-compose up -d
	@open http://localhost:${JUPYTER_PORT}


debug:
	@cd ${CONTEXT_FACEBOX} && \
	docker-compose run --rm jupyter bash

status:
	@cd ${CONTEXT_FACEBOX} && \
	docker-compose logs

stop:
	@cd ${CONTEXT_FACEBOX} && \
	docker-compose stop

clean: stop-facebox
	@cd ${CONTEXT_FACEBOX} && \
	docker-compose rm