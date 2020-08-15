FROM ponylang/changelog-tool:release AS changelog-tool
FROM alpine:3.12

COPY --from=changelog-tool /usr/local/bin/changelog-tool /usr/local/bin/changelog-tool

COPY entrypoint.py /entrypoint.py

RUN apk add --update \
  git \
  py3-pip

RUN pip3 install gitpython PyGithub

ENTRYPOINT ["/entrypoint.py"]
