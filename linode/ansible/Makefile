SHELL:=/usr/bin/env bash

VENV:=source venv/bin/activate &&

PHONY:=help
help:
	@echo "Try make play args=\"-i myinventory --limit myhost play-myplay.yml\" to run Ansible"

play: setup
	$(VENV) ansible-playbook $(args)

# Pass in github.actor and github.token for example
play-ci: setup
	PODMAN_USER=$(PODMAN_USER) PODMAN_PASSWORD=$(PODMAN_PASSWORD) $(VENV) ansible-playbook $(args)

vps.puttehi.eu:
	$(VENV) ansible-playbook -i inventory/personal.yml --limit vps.puttehi.eu $(args)

setup: venv
	$(VENV) pip install wheel
	$(VENV) pip install -r requirements.txt
	$(VENV) ansible-galaxy install -r requirements.yml

venv:
	python3 -m venv venv
