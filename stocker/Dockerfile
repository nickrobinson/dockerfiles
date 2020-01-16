FROM alpine:3

RUN mkdir -p /deploy
RUN apk add --no-cache curl bash jq
RUN curl -o /deploy/ticker.sh https://raw.githubusercontent.com/pstadler/ticker.sh/master/ticker.sh
RUN ["chmod", "+x", "/deploy/ticker.sh"]

ENTRYPOINT ["/deploy/ticker.sh"]
