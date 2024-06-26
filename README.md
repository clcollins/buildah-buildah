#This repository is archived and will no longer receive updates.

buildah-buildah
===============

A container for building and installing [Buildah](https://github.com/projectatomic/buildah), "a tool which facilitates building OCI container images"

Once the image is built, a container can be run to install the application on your host.

Build Options
-------------

**Build with Docker**

```
# Build from a Dockerfile, with Moby/Docker
docker build -t buildah .
```

**Build with Buildah**

Hey, why not?

```
# Build from a Dockerfile, with Buildah
buildah bud .

# Build with Buildah native commands

# Create a container
container=$(buildah from centos:centos7)

# Mount the container filesystem 
mountpoint=$(buildah mount $container)

# Some vars for ease of use
buildah_dir="${mountpoint}/buildah"
buildah_dst="${buildah_dir}/src/github.com/projectatomic/buildah"
working_dir='/buildah/src/github.com/projectatomic/buildah'

# Make the $buildah_dir in the container
mkdir $buildah_dir

# Clone the source
git clone https://github.com/projectatomic/buildah $buildah_dst

# Build Buildah
pushd $buildah_dir
export GOPATH=$(pwd)
pushd $buildah_dst
make
popd ; popd

# Add the install and uninstall scripts
buildah copy $container 'install.sh' '/install.sh'
buildah copy $container 'uninstall.sh' '/uninstall.sh'
chmod +x ${mountpoint}/install.sh ${mountpoint}/uninstall.sh

# Set the Atomic install & uninstall labels
buildah config --label INSTALL="sudo docker run --privileged -v /usr/local:/usr/local:z -it \${IMAGE} ./install.sh" $container
buildah config --label UNINSTALL="sudo docker run --privileged -v /usr/local:/usr/local:z -it \${IMAGE} ./uninstall.sh" $container
buildah config --workingdir $working_dir $container

# Create a container image from the container (Docker formatted)
buildah unmount $container
buildah commit -f docker $container buildah

# Move the image to your local Docker storage
buildah push buildah docker-daemon:buildah:latest

# The image is now available to the Docker daemon to see and interact with, too.
docker inspect buildah:latest
```

Install Options
---------------

**Install with Docker**

```
# Runs in privileged mode

# Install
sudo docker run --privileged -v /usr/local:/usr/local:z -it buildah:latest ./install.sh

# Uninstall
sudo docker run --privileged -v /usr/local:/usr/local:z -it buildah:latest ./uninstall.sh
```

**Install with the Atomic Command**

Systems with the [Atomic Run Tool](https://github.com/projectatomic/atomic) can install and uninstall buildah using the Atomic CLI.

```
# Install
atomic install buildah

# Uninstall
atomic uninstall buildah
```
