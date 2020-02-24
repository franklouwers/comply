FROM golang:1.13 as builder
WORKDIR /src
COPY . .
RUN make 

#FROM pandoc/latex:2.9.2
FROM franklouwers/comply-pandoc
# based on implementation by James Gregory <james@jagregory.com>
MAINTAINER Comply <comply@strongdm.com>

RUN apt-get -y update && apt-get -y install curl 
#RUN cd /tmp && curl https://noto-website-2.storage.googleapis.com/pkgs/Noto-hinted.zip -o noto-hinted.zip \
RUN cd /tmp && curl https://noto-website-2.storage.googleapis.com/pkgs/NotoSerifCJKtc-hinted.zip -o noto.zip && \
  unzip noto.zip && mkdir -p /usr/share/fonts/opentype/noto && \
  (cp *otf /usr/share/fonts/opentype/noto || cp *otc /usr/share/fonts/opentype/noto || true)
RUN fc-cache -f -v

EXPOSE 4000/tcp

COPY --from=builder /src/comply /usr/local/bin/comply

WORKDIR /source

ENTRYPOINT ["/bin/bash"]
