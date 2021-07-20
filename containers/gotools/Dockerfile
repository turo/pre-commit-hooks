# Args for images
ARG registry
ARG dash_version
ARG gosec_version
ARG golang_version

FROM securego/gosec:v${gosec_version} AS gosec

#############
# Build stage
#
# Build standalone binaries for our pre-commit tooling
FROM golang:${golang_version} AS build
ARG gocyclo_version
ARG goimports_version

# Get bulid our binary, which will be in /go/bin
RUN go install --ldflags "-s -w" github.com/fzipp/gocyclo/cmd/gocyclo@v${gocyclo_version}
RUN go install --ldflags "-s -w" golang.org/x/tools/cmd/goimports@v${goimports_version}

#############
# Final stage
#
FROM ${registry}/dash:${dash_version} AS bin
# Associate this image with our repository
LABEL org.opencontainers.image.source https://github.com/turo/pre-commit-hooks
# Get our statically built binaries
COPY --from=build /usr/local/go/bin/gofmt /bin/
COPY --from=build /go/bin/* /bin/
COPY --from=gosec /bin/gosec /bin/
# Get our hook scripts
COPY hooks/golang/gocyclo.sh /bin/
COPY hooks/golang/goimports.sh /bin/
COPY hooks/golang/go-fmt.sh /bin/
# Default entrypoint for now
ENTRYPOINT ["/bin/dash"]
