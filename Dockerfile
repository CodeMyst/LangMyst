FROM golang:alpine3.12 AS build

RUN apk add git && \
    git clone https://github.com/CodeMyst/pastemyst-autodetect.git /src

WORKDIR /src
RUN go build -o /usr/bin/pastemyst-autodetect .

FROM ubuntu:22.04

COPY --from=build /usr/bin/pastemyst-autodetect /usr/bin/

RUN apt update && apt install -y curl wget libevent-dev gcc libc6-dev libssl-dev

RUN wget https://downloads.dlang.org/releases/2.x/2.105.3/dmd_2.105.3-0_amd64.deb
RUN dpkg -i dmd_2.105.3-0_amd64.deb && rm -rf dmd_2.105.3-0_amd64.deb

COPY . /app
WORKDIR /app

RUN dub build -b release

ENTRYPOINT [ "./langmyst" ]
