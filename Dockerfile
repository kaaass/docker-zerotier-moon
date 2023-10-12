FROM ubuntu:22.04

LABEL maintainer="KAAAsS <admin@kaaass.net>"

RUN apt update && \
    apt install -y curl && \
    curl -s https://install.zerotier.com | bash

COPY startup.sh /startup.sh
EXPOSE 9993/udp

ENTRYPOINT ["/startup.sh"]
