FROM golang:1.9.3

ADD simsun.ttc /usr/share/fonts/chinese/TrueType/
ADD start.sh /go/src/github.com/lifei6671/mindoc

ENV GLIBC_VERSION 2.26-r0

# Download and install glibc
RUN apt-get update && apt-get install -y curl  \
  ca-certificates \
  python \
  wget \
  xdg-utils \
  git \
  bash \
  make \
  gcc \
  g++ \
  libc6 \
  libxrender-dev \
  libxcomposite-dev
  
# install calibre
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/opt/calibre/lib
ENV PATH $PATH:/opt/calibre/bin
ENV CALIBRE_INSTALLER_SOURCE_CODE_URL https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py
RUN wget -O- ${CALIBRE_INSTALLER_SOURCE_CODE_URL} | python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main(install_dir='/opt', isolated=True)" && \
    rm -rf /tmp/calibre-installer-cache

WORKDIR /go/src/github.com/lifei6671/mindoc

RUN git clone https://github.com/lifei6671/mindoc.git && \
	go get -d ./... && \
	CGO_ENABLE=1 go build -v -o mindoc_linux_amd64 -ldflags="-w -X main.VERSION=$TAG -X 'main.BUILD_TIME=`date`' -X 'main.GO_VERSION=`go version`'" && \
    rm -rf commands controllers models modules routers tasks vendor docs search data utils graphics .git Godeps uploads/* .gitignore .travis.yml Dockerfile gide.yaml LICENSE main.go README.md conf/enumerate.go conf/mail.go install.lock

RUN chmod +x start.sh
	
CMD ["./start.sh"]