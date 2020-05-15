FROM alpine

COPY entrypoint.sh /entrypoint.sh

RUN apk add --update bash \
  jq \
  git \
  grep \
  curl

ENTRYPOINT ["/entrypoint.sh"]
