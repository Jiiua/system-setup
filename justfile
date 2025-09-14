set working-directory := "./"
set shell := ["bash", "-cu"]
set dotenv-load := true


# Code Hygiene
lint:
    poetry run ansible-lint .

format:
    poetry run black .

check:
    just lint
    just format

# Deploy
bootstrap hosts:
    @echo "Bootstraping with:"
    @echo " - Hosts file: {{hosts}}"
    poetry run ansible-playbook -i {{hosts}} playbooks/bootstrap.yml --ask-pass # -vvvvv

setup-system hosts:
    @echo "Setting up system with:"
    @echo " - Hosts file: {{hosts}}"
    poetry run ansible-playbook -i {{hosts}} playbooks/setup-system.yml --ask-pass # --ask-become-pass

# Install
install:
    poetry install

# Tests
test-bootstrap:
    just bootstrap "../inventory/hosts.yml"

test-setup-system:
    just setup-system "../inventory/hosts.yml"
