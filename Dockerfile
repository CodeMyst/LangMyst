FROM ubuntu:22.04

RUN apt update && apt install -y curl wget libevent-dev gcc libc6-dev libssl-dev zip git

# install guesslang-bun
RUN curl -fsSL https://bun.sh/install | bash
RUN git clone https://github.com/CodeMyst/guesslang-bun.git
WORKDIR /guesslang-bun
RUN bun install
RUN cp node_modules/@vscode/vscode-languagedetection/model/model.json .
RUN cp node_modules/@vscode/vscode-languagedetection/model/group1-shard1of1.bin .
RUN bun build index.ts --compile --outfile /bin/guesslang-bun --assets model.json group1-shard1of1.bin

# install d
RUN wget https://downloads.dlang.org/releases/2.x/2.109.1/dmd_2.109.1-0_amd64.deb
RUN dpkg -i dmd_2.109.1-0_amd64.deb && rm -rf dmd_2.109.1-0_amd64.deb

COPY . /app
WORKDIR /app

RUN dub build -b release

ENTRYPOINT [ "./langmyst" ]
