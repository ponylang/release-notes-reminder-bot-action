IMAGE := ponylang/release-notes-reminder-bot-action

ifndef tag
  IMAGE_TAG := $(shell cat VERSION)
else
  IMAGE_TAG := $(tag)
endif

all: build

build:
	docker build --pull -t "${IMAGE}:${IMAGE_TAG}" .
	docker build --pull -t "${IMAGE}:latest" .
	docker build --pull -t "ghcr.io/${IMAGE}:${IMAGE_TAG}" .
	docker build --pull -t "ghcr.io/${IMAGE}:latest" .

push: build
	docker push "${IMAGE}:${IMAGE_TAG}"
	docker push "${IMAGE}:latest"
	docker push "ghcr.io/${IMAGE}:${IMAGE_TAG}"
	docker push "ghcr.io/${IMAGE}:latest"

pylint: build
	docker run --entrypoint pylint --rm "ghcr.io/${IMAGE}:latest" /entrypoint.py

.PHONY: build pylint
