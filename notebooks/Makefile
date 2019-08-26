#!/usr/bin/make
#@ FaceBox Notebooks

#@ Commands:
.PHONY: help-notebooks run-notebooks
SHELL := /bin/bash

CONTEXT_NOTEBOOKS := $(or $(CONTEXT_NOTEBOOKS),.)

-include ${CONTEXT_NOTEBOOKS}/.env
export

%: %-notebooks
	@true

#- Show all commands.
help-notebooks:
	@awk '{ if (match(lastLine, /^#- (.*)/)) printf "- %s: %s\n", substr($$1, 0, index($$1, ":")-1), substr(lastLine, RSTART + 3, RLENGTH); else if (match($$0, /^[a-zA-Z\-\_0-9]+:/)) printf "- %s:\n", substr($$1, 0, index($$1, ":")-1); else if (match($$0, /^#@ (.*)/)) printf "%s\n", substr($$0, RSTART + 3, RLENGTH); } { lastLine = $$0 }' $(MAKEFILE_LIST)

#- Build JupyterLab
build-notebooks:
	@cd ${CONTEXT_NOTEBOOKS} && \
	if [ ! -d ".venv" ]; then \
		python3 -m venv .venv; \
	fi && \
	source .venv/bin/activate && \
	pip3 install --upgrade pip && \
	pip3 install -r ../requirements.txt

#- Run JupyterLab.
run-notebooks:
	@cd ${CONTEXT_NOTEBOOKS} && \
	if [ ! -d ".venv" ]; then \
		${MAKE} build-notebooks; \
	fi && \
	source .venv/bin/activate && \
	jupyter lab --ip=0.0.0.0 --allow-root --notebook-dir=.
