FROM alpine:latest


RUN apk update && apk add --no-cache \
    bash \
    vim

CMD ["/bin/bash"]

