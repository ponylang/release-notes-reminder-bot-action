TAG := docker.pkg.github.com/ponylang/release-notes-reminder-bot-action/release-notes-reminder-bot:latest

all: build

build:
	docker build --pull -t ${TAG} .

pylint: build
	docker run --entrypoint pylint --rm ${TAG} /entrypoint.py

.PHONY: build pylint
