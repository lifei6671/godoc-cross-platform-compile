FROM golang:1.10.3

# Download and install glibc
RUN apt-get update && apt-get install -y git gcc 

RUN go get -u github.com/golang/dep/cmd/dep

RUN mkdir -p /go/src/github.com/lifei6671/ && cd /go/src/github.com/lifei6671/ && git clone https://github.com/lifei6671/mindoc.git && cd mindoc \
	dep ensure  && \
	CGO_ENABLE=1 go build -v -o mindoc_linux_amd64 -ldflags="-w -X main.VERSION=$TAG -X 'main.BUILD_TIME=`date`' -X 'main.GO_VERSION=`go version`'" && \
    rm -rf commands controllers models modules routers tasks vendor docs search data utils graphics .git Godeps uploads/* .gitignore .travis.yml Dockerfile gide.yaml LICENSE main.go README.md conf/enumerate.go conf/mail.go install.lock

WORKDIR /go/src/github.com/lifei6671/mindoc

ADD start.sh /go/src/github.com/lifei6671/mindoc
	
RUN chmod +x start.sh
	
CMD ["./start.sh"]