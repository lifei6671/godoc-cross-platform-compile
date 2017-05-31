FROM golang:1.8.1-alpine

RUN apk add --update git

ENV TAG=0.1.2

RUN mkdir -p /go/src/github.com/lifei6671 && \
    cd /go/src/github.com/lifei6671 && \
    git clone https://github.com/lifei6671/godoc.git

WORKDIR /go/src/github.com/lifei6671/godoc

RUN chmod +x start.sh

RUN  go get -d ./... && \
    go build -v -o godoc_linux_amd64 -ldflags="-w -X main.VERSION=$TAG -X 'main.BUILD_TIME=`date`' -X 'main.GO_VERSION=`go version`'" && \
    rm -rf commands controllers models modules routers tasks vendor docs search data utils graphics .git Godeps uploads/* .gitignore .travis.yml Dockerfile gide.yaml LICENSE main.go README.md conf/enumerate.go conf/mail.go install.lock

CMD ["./start.sh"]