FROM alpine:3.23

RUN apk add --no-cache build-base cmake git bison libpng-dev rsync

WORKDIR /src
