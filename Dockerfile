FROM golang:1.9

RUN apt-get update && apt-get install -y --no-install-recommends \
	git \
	gcc \
	python \
	wget

ENV TAG=0.3

RUN mkdir -p /go/src/github.com/lifei6671 && \
    cd /go/src/github.com/lifei6671 && \
    git clone https://github.com/lifei6671/mindoc.git 
	
ADD start.sh /go/src/github.com/lifei6671/mindoc

WORKDIR /go/src/github.com/lifei6671/mindoc

RUN chmod +x start.sh

RUN  go get -d ./... && \
	CGO_ENABLE=1 go build -v -o mindoc_linux_amd64 -ldflags="-w -X main.VERSION=$TAG -X 'main.BUILD_TIME=`date`' -X 'main.GO_VERSION=`go version`'" && \
    rm -rf commands controllers models modules routers tasks vendor docs search data utils graphics .git Godeps uploads/* .gitignore .travis.yml Dockerfile gide.yaml LICENSE main.go README.md conf/enumerate.go conf/mail.go install.lock

ENV	CALIBRE_INSTALLER_LOCAL_URL=http://cdn.iminho.me/calibre-3.16.0-x86_64.txz

RUN wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"

CMD ["./start.sh"]