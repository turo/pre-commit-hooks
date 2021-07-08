############################
# docker-compose build image
#
# Build a statically linked docker-compose binary from scratch
FROM python:3 AS build-docker-compose

# Install UPX and patchelf for smaller binaries
RUN apt-get update -yqq && \
    apt-get install -y upx && \
	apt-get install -y patchelf

WORKDIR /build/
# Download our target docker-compose source tree
ARG DOCKER_COMPOSE_VERSION=1.29.2
RUN wget --quiet https://github.com/docker/compose/archive/refs/tags/${DOCKER_COMPOSE_VERSION}.tar.gz -O compose.tgz && \
	tar -xzf compose.tgz && \
	mv compose-* compose

WORKDIR /build/compose
# Install our dependencies for building docker-compose and pyinstaller and staticx for binary buliding
RUN pip3 install -q -r requirements.txt -r requirements-indirect.txt pyinstaller staticx

# Manually create a GITSHA file which is needed by the pyinstaller spec
RUN echo "${DOCKER_COMPOSE_VERSION}-static" > compose/GITSHA

# Create our single-file output binary with pyinstaller
RUN pyinstaller -F --exclude-module pycrypto --exclude-module PyInstaller docker-compose.spec

# Statically link the supporting libraries into our binary
RUN mkdir -p /build/out && \
	staticx /build/compose/dist/docker-compose /build/out/docker-compose && \
	chmod a+rx /build/out/docker-compose

#####################
# golang build image
#
# Build the golang binaries that don't have release binaries
FROM golang AS build-golang

# Get bulid our binary, which will be in /go/bin
RUN go install github.com/fzipp/gocyclo/cmd/gocyclo@latest
RUN go install golang.org/x/tools/cmd/goimports@latest

########################
# dash shell build image
#
# Build a statically linked dash shell for simple wrapper scripts around hooks
FROM debian AS build-dash

# Install build dependencies
RUN apt-get update -yqq && \
    apt-get install -yq build-essential wget automake

WORKDIR /build
# Get our source tree
ARG DASH_SHELL_VERSION=0.5.11.4
RUN wget --quiet https://git.kernel.org/pub/scm/utils/dash/dash.git/snapshot/dash-${DASH_SHELL_VERSION}.tar.gz -O dash.tgz && \
	tar -xzf dash.tgz && \
	mv dash-* dash

WORKDIR /build/dash
# Build our binary
RUN ./autogen.sh && \
	./configure --enable-static && \
	make

WORKDIR /build/out
# Move the binary to our output, and fix the permissions
RUN cp /build/dash/src/dash /build/out/dash && \
	chmod a+rx /build/out/dash


##############################
# dash shell minimal image
#
FROM scratch AS minimal-dash
# The following 3 lines are needed to create the /tmp directory and fix the
# permissions so that we can write to it when running as a no-privilege user
COPY --from=busybox /tmp /tmp
COPY --from=busybox /bin/chmod /bin/chmod
RUN ["/bin/chmod", "a+rwx", "/tmp"]
COPY --from=build-dash /build/out/dash /bin/dash
ENTRYPOINT ["/bin/dash"]


###################################
# docker-compose binary-only image
#
FROM minimal-dash AS bin-docker-compose
# Get our statically built binary
COPY --from=build-docker-compose /build/out/docker-compose /bin/docker-compose
# Default entrypoint for now
ENTRYPOINT ["/bin/docker-compose"]


############################
# combined binary-only image
#
FROM minimal-dash AS combined
# Copy in our static binaries
COPY --from=bin-docker-compose /bin/docker-compose /bin/
COPY --from=build-golang /go/bin/ /bin/
RUN ["/bin/dash", "echo", "/bin/*"]
# Copy in our scripts
COPY hooks/* /
