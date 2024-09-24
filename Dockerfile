FROM ubuntu:22.04

RUN apt update && apt install -y curl wget libevent-dev gcc libc6-dev libssl-dev zip git

# install guesslang-bun
RUN curl -fsSL https://bun.sh/install | bash
RUN git clone https://github.com/CodeMyst/guesslang-bun.git
WORKDIR /guesslang-bun
RUN ~/.bun/bin/bun install
RUN ~/.bun/bin/bun build ./index.ts --compile --outfile /bin/guesslang-bun

# install d
RUN wget https://downloads.dlang.org/releases/2.x/2.109.1/dmd_2.109.1-0_amd64.deb
RUN dpkg -i dmd_2.109.1-0_amd64.deb && rm -rf dmd_2.109.1-0_amd64.deb

COPY . /app
WORKDIR /app

RUN dub build -b release

ENTRYPOINT [ "./langmyst" ]
