# Base image versions
ARG registry
ARG dash_version
ARG docker_compose_version

#############
# Build stage
#
# Build a statically linked docker-compose binary from scratch
FROM python:3 AS build

# Install UPX and patchelf for smaller binaries
RUN apt-get update -yqq && \
    apt-get install -y upx patchelf binutils

WORKDIR /build/
# Download our target docker-compose source tree
ARG docker_compose_version
RUN wget --quiet https://github.com/docker/compose/archive/refs/tags/${docker_compose_version}.tar.gz -O compose.tgz && \
	tar -xzf compose.tgz && \
	mv compose-* compose

WORKDIR /build/compose
# Install our dependencies for building docker-compose and pyinstaller and staticx for binary buliding
RUN pip3 install -q -r requirements.txt -r requirements-indirect.txt pyinstaller staticx

# Manually create a GITSHA file which is needed by the pyinstaller spec
RUN echo "${docker_compose_version}-static" > compose/GITSHA

# Create our single-file output binary with pyinstaller
RUN pyinstaller -F --exclude-module pycrypto --exclude-module PyInstaller docker-compose.spec

# Statically link the supporting libraries into our binary
RUN mkdir -p /build/out && \
	staticx /build/compose/dist/docker-compose /build/out/docker-compose && \
	chmod a+rx /build/out/docker-compose && \
	strip /build/out/docker-compose


#############
# Final stage
#
FROM ${registry}/dash:${dash_version} AS bin
# Associate this image with our repository
LABEL org.opencontainers.image.source https://github.com/turo/pre-commit-hooks
# Get our statically built binary
COPY --from=build /build/out/docker-compose /bin/
# Copy in the pre-commit hook
COPY hooks/docker/docker-compose-lint.sh /bin/
# Default entrypoint to the hook
ENTRYPOINT ["/bin/docker-compose-lint.sh"]
