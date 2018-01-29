FROM golang:1.9

RUN apt-get update && apt-get install -y --no-install-recommends \
	git \
	gcc \
	python \
	wget \
	python-apsw \
    python-beautifulsoup \
    python-chardet \
    python-cherrypy3 \
    python-cssselect \
    python-cssutils \
    python-dateutil \
    python-dbus \
    python-dnspython \
    python-feedparser \
    python-imaging \
    python-lxml \
    python-markdown \
    python-mechanize \
    python-netifaces \
    python-pil \
    python-pkg-resources \
    python-psutil \
    python-pygments \
    python-pyparsing \
    # python-qt4 \
    python-pyqt5 \
    python-pyqt5.qtsvg \
    python-pyqt5.qtwebkit \
    python-routes \
    python2.7


RUN wget -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | \
    python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()" && \
    rm -rf /tmp/*

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