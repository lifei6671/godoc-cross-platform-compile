FROM golang:1.9

RUN apt-get update && apt-get install -y --no-install-recommends \
	git \
	gcc \
	python \
	curl

RUN curl -L https://calibre-ebook.com/dist/src | tar xvJ  && cd calibre* && python2 setup.py install

RUN ebook-convert --version

ENV TAG=0.7.2

RUN mkdir -p /go/src/github.com/lifei6671 && \
    cd /go/src/github.com/lifei6671 && \
    git clone https://github.com/lifei6671/mindoc.git 
	
ADD start.sh /go/src/github.com/lifei6671/mindoc

WORKDIR /go/src/github.com/lifei6671/mindoc

ENV	CALIBRE_INSTALLER_LOCAL_URL=http://cdn.iminho.me/calibre-3.16.0-x86_64.txz



RUN chmod +x start.sh

RUN  go get -d ./... && \
	CGO_ENABLE=1 go build -v -o mindoc_linux_amd64 -ldflags="-w -X main.VERSION=$TAG -X 'main.BUILD_TIME=`date`' -X 'main.GO_VERSION=`go version`'" && \
    rm -rf commands controllers models modules routers tasks vendor docs search data utils graphics .git Godeps uploads/* .gitignore .travis.yml Dockerfile gide.yaml LICENSE main.go README.md conf/enumerate.go conf/mail.go install.lock



CMD ["./start.sh"]