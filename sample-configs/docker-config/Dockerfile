FROM ubuntu:latest

# Update package index and install 
RUN apt-get update
RUN apt-get -y install golang git gcc g++

# Set up GOPATH
RUN mkdir /go
ENV GOPATH /go

#clone go-ethereum
RUN mkdir -p $GOPATH/src/github.com/ethereum && \
    cd $GOPATH/src/github.com/ethereum && \
    git clone https://github.com/ethereum/go-ethereum

# Get dependencies
RUN cd $GOPATH/src/github.com/ethereum/go-ethereum && \
    go get github.com/ethereum/go-ethereum && \
    go get . && go get ./cmd/geth && go get ./cmd/bzzd

RUN \
  cd $GOPATH/src/github.com/ethereum/go-ethereum && \
  go build ./cmd/geth ./cmd/bzzd 
  
#move binaries to root
RUN \
  cp $GOPATH/bin/bzzd /bzzd && \
  cp $GOPATH/bin/geth /geth

#cleanup
RUN \
  apt-get -y purge git golang gcc g++           && \
  rm -rf $GOPATH && rm -rf /var/cache/apt/*

EXPOSE 8080
EXPOSE 30399

# Inject the startup script
ADD run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
