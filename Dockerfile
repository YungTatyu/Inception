FROM alpine:latest

# Change to non-root privilege
# USER user

RUN apk update && apk add --no-cache \
    bash \
    vim

CMD ["/bin/bash"]

