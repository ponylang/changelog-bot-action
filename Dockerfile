FROM ponylang/changelog-tool:release AS changelog-tool
FROM alpine

COPY --from=changelog-tool /usr/local/bin/changelog-tool /usr/local/bin/changelog-tool

COPY entrypoint.sh /entrypoint.sh

RUN apk add --update jq

ENTRYPOINT ["/entrypoint.sh"]
