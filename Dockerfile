# ########################################################################################
# POCKETMINE-MP Docker Image
#
# This is a stand-alone image that utilizes the latest version of the Pocketmine-MP PHP
# based server (https://pmmp.io/)
#
# You can run using this:
#
# Start in headless mode
# 	docker run -d -v /data/minecraft/data:/data -p 19132:19132/udp --name minecraft cscheide/pocketmine-mp
#
# Start in interactive mode
# 	docker start -ai minecraft
#
# Start creating new data
# 	docker run -d -p 19132:19132/udp --name minecraft cscheide/pocketmine-mp
#

FROM ubuntu:latest

MAINTAINER Christopher Scheidel edit by Onekintaro <kintaro221@gmail.com>

# Install dependencies
RUN apt-get update && \
	apt-get -y install wget && \
	rm -rf /var/lib/apt/lists/*

# Make the directory we will need
RUN	mkdir -p /data /home/container
WORKDIR /home/container

# Grab the pre-built PHP 7.2 distribution from PMMP
RUN wget -q -O - https://jenkins.pmmp.io/job/PHP-7.2-Aggregate/lastSuccessfulBuild/artifact/PHP-7.2-Linux-x86_64.tar.gz > /home/container/PHP-7.2-Linux-x86_64.tar.gz && \
  cd /home/container && \
	tar -xvf PHP-7.2-Linux-x86_64.tar.gz

# Grab the latest Alpha PHAR
RUN wget -q -O - https://jenkins.pmmp.io/job/PocketMine-MP/Alpha/artifact/PocketMine-MP.phar > /home/container/PocketMine-MP.phar

# Grab the start script and make it executable
RUN wget -q -O - https://raw.githubusercontent.com/pmmp/PocketMine-MP/master/start.sh > /home/container/start.sh && \
  chmod +x /home/container/start.sh

# Add the custom properties from our docker project
ADD server.properties /data/server.properties
ADD pocketmine.yml /data/pocketmine.yml

# Touch the remaining files
RUN touch /data/banned-ips.txt && \
	touch /data/banned-players.txt && \
	touch /data/ops.txt && \
	mkdir -p /data/players && \
	touch /data/white-list.txt && \
	mkdir -p /data/worlds && \
	mkdir -p /data/plugins && \
	mkdir -p /data/resource_packs && \
	touch /data/server.log

# Move the configuration items out of the main directory and sym link items back
RUN ln -s /data/banned-ips.txt /home/container/banned-ips.txt && \
	ln -s /data/banned-players.txt /home/container/banned-players.txt && \
	ln -s /data/ops.txt /home/container/ops.txt && \
	ln -s /data/players /home/container/players && \
	ln -s /data/pocketmine.yml /home/container/pocketmine.yml && \
	ln -s /data/server.properties /home/container/server.properties && \
	ln -s /data/white-list.txt /home/container/white-list.txt && \
	ln -s /data/worlds /home/container/worlds && \
	ln -s /data/plugins /home/container/plugins && \
	ln -s /data/resource_packs /home/container/resource_packs && \
	ln -s /data/server.log /home/container/server.log


# Expose the right port
#EXPOSE 19132/udp

# Set up the volume for the data
#VOLUME /data

# Run the app when launched
#CMD [ "bash", "/minecraft/start.sh", "--no-wizard"]
