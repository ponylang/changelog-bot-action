FROM ponylang/changelog-tool:release AS changelog-tool
FROM alpine:3.12

COPY --from=changelog-tool /usr/local/bin/changelog-tool /usr/local/bin/changelog-tool

COPY entrypoint.py /entrypoint.py

RUN apk add --update --no-cache \
  git \
  py3-pip

RUN pip3 install \
  gitpython \
  PyGithub==v1.54.1 \
  pylint

ENTRYPOINT ["/entrypoint.py"]
