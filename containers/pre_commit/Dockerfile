# Base image versions
ARG registry
ARG dash_version
ARG pre_commit_version

#############
# Build stage
#
# Build a statically linked binary from scratch
FROM python:3 AS build

# Install UPX and patchelf for smaller binaries
RUN apt-get update -yqq && \
    apt-get install -y upx patchelf binutils

WORKDIR /build/
# Download our target repo source tree
ARG pre_commit_version
RUN wget https://github.com/pre-commit/pre-commit/archive/refs/tags/v${pre_commit_version}.tar.gz -O repo.tgz
RUN tar -xzf repo.tgz && \
    rm repo.tgz && \
	mv * repo

WORKDIR /build/repo
# Install our dependencies for building and pyinstaller and staticx for binary buliding
RUN pip3 install -q . pyinstaller staticx
# Get the spec so we can build cleanly
COPY containers/pre_commit/pre-commit.spec .
# Build the binary
RUN pyinstaller --onefile --exclude-module PyInstaller pre-commit.spec

# Statically link the supporting libraries into our binary
RUN mkdir -p /build/out && \
	staticx /build/repo/dist/pre-commit /build/out/pre-commit && \
	chmod a+rx /build/out/pre-commit && \
	strip /build/out/pre-commit


#############
# Final stage
#
FROM ${registry}/dash:${dash_version} AS bin
# Associate this image with our repository
LABEL org.opencontainers.image.source https://github.com/turo/pre-commit-hooks
# Get our statically built binary
COPY --from=build /build/out/pre-commit /bin/
# Mountable directory for theoretically running hooks
WORKDIR /src
# Default entrypoint to the hook
ENTRYPOINT ["/bin/pre-commit"]
