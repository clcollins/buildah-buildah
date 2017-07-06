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

# Build with Buildah native commands (in a Bash script)
bash ./buildah-build-buildah.sh
```

Install Options
---------------

**Install with Docker**

```
# Runs in privileged mode

# Install
sudo docker run --privileged -v /usr/local:/usr/local:z -it \${IMAGE} ./install.sh

# Uninstall
sudo docker run --privileged -v /usr/local:/usr/local:z -it \${IMAGE} ./install.sh
```

**Install with the Atomic Command**

Systems with the [Atomic Run Tool](https://github.com/projectatomic/atomic) can install and uninstall buildah using the Atomic CLI.

```
# Install
atomic install buildah

# Uninstall
atomic uninstall buildah
```
=======
# buildah-buildah
Build buildah two ways: buildah native or buildah bud
