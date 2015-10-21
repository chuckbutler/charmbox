FROM ubuntu:14.04.3
VOLUME ["/home/ubuntu/.juju", "/home/ubuntu/trusty", "/home/ubuntu/precise"]

ENV HOME=/home/ubuntu
ENV GOPATH=/home/ubuntu/go
ENV GOROOT=/usr/lib/go

RUN apt-get update -qy && apt-get -y --no-install-recommends install \
bzr \
ca-certificates \
git \
golang-go \
golang-src \
mercurial \
make \
openssh-client \
cython \
gcc

ADD install-review-tools.sh /install-review-tools.sh
RUN /install-review-tools.sh
ADD run.sh /run.sh
CMD /run.sh
