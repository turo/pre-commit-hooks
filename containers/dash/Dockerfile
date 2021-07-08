#############
# Build stage
#
# Build a statically linked dash shell for simple wrapper scripts around hooks
ARG debian_version
FROM debian:${debian_version} AS build

# Install build dependencies
RUN apt-get update -yqq && \
    apt-get install -yq build-essential wget automake binutils

WORKDIR /build
# Get our source tree
ARG dash_version
RUN wget --quiet https://git.kernel.org/pub/scm/utils/dash/dash.git/snapshot/dash-${dash_version}.tar.gz -O dash.tgz && \
	tar -xzf dash.tgz && \
	mv dash-* dash

WORKDIR /build/dash
# Build our binary
RUN ./autogen.sh && \
	./configure --enable-static && \
	make

WORKDIR /build/out
# Move the binary to our output, fix the permissions, and strip debug symbols
RUN cp /build/dash/src/dash /build/out/dash && \
	chmod a+rx /build/out/dash && \
	strip /build/out/dash


###############
# Minimal stage
#
FROM scratch AS minimal
# Associate this image with our repository
LABEL org.opencontainers.image.source https://github.com/turo/pre-commit-hooks
# Get our shell
COPY --from=build /build/out/dash /bin/dash
# And set it as the default
SHELL ["/bin/dash", "-c"]
# The following lines are needed to create the /tmp directory and fix the
# permissions so that we can write to it when running as a no-privilege user
COPY --from=busybox /tmp /tmp
COPY --from=busybox /bin/chmod /bin/rm /bin/
RUN chmod a+rwx /tmp && rm /bin/chmod /bin/rm

#############
# Final stage
#
# Compress the minimal stage into a single layer to erase its history
FROM scratch AS bin
COPY --from=minimal / /
ENTRYPOINT ["/bin/dash"]
