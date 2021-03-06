# ########################################################################################
# POCKETMINE-MP Docker Image (pterodactyl.io mod for egg)
#

FROM ubuntu:latest

MAINTAINER Christopher Scheidel edit by Onekintaro <kintaro221@gmail.com>

# Install dependencies
RUN apt update \
    && apt upgrade -y \
    && apt install -y tar wget curl iproute2 openssl \
    && apt update -y \
    && useradd -d /home/container -m container

USER container
ENV USER=container HOME=/home/container


COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
