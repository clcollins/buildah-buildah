FROM centos:centos7

LABEL maintainer Chris Collins <christopher.collins@duke.edu>
LABEL name "buildah-buildah"
LABEL version "0.1"
LABEL release "1"
LABEL Summary "Container to build and install Buildah"
LABEL Description "buildah - a tool which facilitates building OCI container images"
LABEL authoritative-source-url "https://github.com/clcollins/buildah-buildah"
LABEL changelog-url "https://github.com/clcollins/buildah-buildah/commits/master"

# Labels for installs using the Atomic command
LABEL INSTALL="sudo docker run --privileged -v /usr/local:/usr/local:z -it \${IMAGE} ./install.sh"
LABEL UNINSTALL="sudo docker run --privileged -v /usr/local:/usr/local:z -it \${IMAGE} ./uninstall.sh"

ENV BUILDAH_DIR='/buildah'
ENV BUILDAH_SRC='https://github.com/projectatomic/buildah'
ENV BUILDAH_DST="${BUILDAH_DIR}/src/github.com/projectatomic/buildah"
ENV GOPATH="${BUILDAH_DIR}"

ENV GO_VER='1.7.6'
ENV GO_VER_SHA='ad5808bf42b014c22dd7646458f631385003049ded0bb6af2efc7f1f79fa29ea'
ENV GO_PKG="go${GO_VER}.linux-amd64.tar.gz"
ENV GO_SRC="https://storage.googleapis.com/golang/${GO_PKG}"

RUN curl -sSL ${GO_SRC} -o /tmp/${GO_PKG}

RUN test $(sha256sum /tmp/${GO_PKG} |awk '{print $1}') == ${GO_VER_SHA}

RUN tar -C /usr/local -xzf /tmp/${GO_PKG}

RUN yum install -y gcc \
                   make \
                   bats \
                   btrfs-progs-devel \
                   device-mapper-devel \
                   glib2-devel \
                   gpgme-devel \
                   libassuan-devel \
                   ostree-devel \
                   git \
                   bzip2 \
                   go-md2man \
                   runc \
                   skopeo-containers

RUN mkdir ${BUILDAH_DIR}

WORKDIR ${BUILDAH_DIR}

RUN git clone ${BUILDAH_SRC} ${BUILDAH_DST}

WORKDIR ${BUILDAH_DST}

RUN PATH=$PATH:/usr/local/go/bin make

ADD install.sh install.sh
ADD uninstall.sh uninstall.sh
RUN chmod +x install.sh uninstall.sh
