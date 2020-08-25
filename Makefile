TAG := docker.pkg.github.com/ponylang/changelog-bot-action/changelog-bot:latest

all: build

build:
	docker build --pull -t ${TAG} .

pylint: build
	docker run --entrypoint pylint --rm ${TAG} /entrypoint.py

.PHONY: build pylint
