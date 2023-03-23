SHELL:=/usr/bin/env bash

VENV:=source venv/bin/activate &&

PHONY:=help
help:
	@echo "Try make vps to deploy VPS"

vps: setup
	$(VENV) ansible-playbook -i inventory/personal.yml play-vps.yml

setup: venv
	$(VENV) pip install wheel
	$(VENV) pip install -r requirements.txt

venv:
	python3 -m venv venv
