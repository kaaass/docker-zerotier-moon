ARG ALPINE_VERSION=edge

FROM alpine:${ALPINE_VERSION} as builder

RUN apk add --no-cache alpine-sdk sudo

# Add builder user and setup sudoer
RUN adduser -G abuild -s /bin/sh -D builder && \
    echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /home/builder/package && \
    chown builder:abuild /home/builder/package
USER builder
WORKDIR /home/builder/package

# Create RSA key
RUN abuild-keygen -a -i -n

# Build package
COPY ./package /home/builder/package
RUN sudo apk update && abuild -r

# Start creating production image
FROM alpine:${ALPINE_VERSION}

LABEL maintainer="seedgou <seedgou@gmail.com>"

COPY --from=builder /home/builder/package/pkg/*.apk /tmp/

RUN apk add --no-cache /tmp/*.apk

COPY startup.sh /startup.sh
EXPOSE 9993/udp

ENTRYPOINT ["/startup.sh"]
