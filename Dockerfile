FROM golang:1.8.1-alpine

RUN apk add --update bash git make gcc

ENV TAG=0.1

RUN mkdir -p /go/src/github.com/lifei6671 && \
    cd /go/src/github.com/lifei6671 && \
    git clone https://github.com/lifei6671/godoc.git

WORKDIR /go/src/github.com/lifei6671/godoc

RUN chmod +x start.sh



RUN  go get -d ./... && \
    go get github.com/mitchellh/gox && \
    gox -os "windows linux darwin" -arch amd64 -ldflags="-w -X main.VERSION=$TAG -X 'main.BUILD_TIME=`date`' -X 'main.GO_VERSION=`go version`'" && \
    gox -os "windows" -arch amd64 -ldflags="-H=windowsgui -w -X main.VERSION=$TAG -X 'main.BUILD_TIME=`date`' -X 'main.GO_VERSION=`go version`'"
    rm -rf commands controllers models modules routers tasks vendor docs search data utils graphics .git Godeps uploads/* .gitignore .travis.yml Dockerfile gide.yaml LICENSE main.go README.md conf/enumerate.go conf/mail.go && \
    tar -zcvf godoc.tar.gz . && \
    cp godoc.tar.gz uploads && \
    rm -rf godoc.tar.gz

CMD ["./start.sh"]