# Args for images
ARG golangci_lint_version

# golangci-lint needs a full go env for it to work, so we just derive our image
FROM golangci/golangci-lint:v${golangci_lint_version} AS bin
# Associate this image with our repository
LABEL org.opencontainers.image.source https://github.com/turo/pre-commit-hooks
# Make our cache directory
RUN mkdir /.cache && chmod a+rwx /.cache
# Copy in our pre-commit hook
COPY hooks/golang/golangci-lint.sh /bin
# Force HOME to /src so we can cache packages in the external volume
ENV HOME=/src
# Set our hook entrypoint
ENTRYPOINT ["/bin/golangci-lint.sh"]
