FROM alpine:3.11.6 AS base

RUN apk add --update-cache \
    unzip curl jq nano

# Download and install TShock
RUN curl -s https://api.github.com/repos/pryaxis/tshock/releases | jq --raw-output '.[0].assets[0].browser_download_url' | xargs -n1 curl -L -o terrariaserver.zip
RUN unzip terrariaserver.zip -d /tshock && \
    rm terrariaserver.zip && \
    chmod +x /tshock/TerrariaServer.exe

# Add bootstrap.sh and make sure it's executable.
# This will be pulled into the final stage.
ADD bootstrap.sh .
ADD serverconfig.txt .
RUN chmod +x bootstrap.sh

FROM mono:6.8.0.96-slim

LABEL maintainer="Ryan Sheehan <rsheehan@gmail.com>"

# documenting ports
EXPOSE 7777 7878

# add terraria user to run as
RUN groupadd -r terraria && \
    useradd -m -r -g terraria terraria && \
    # install nuget to grab tshock dependencies
    apt-get update -y && \
    apt-get install -y nuget nano curl wget && \
    rm -rf /var/lib/apt/lists/* /tmp/*

    # create directories
RUN mkdir -m 777 /tshock 
RUN mkdir -m 777 /tshock/ServerPlugins
RUN mkdir -m 777 /world
RUN mkdir -m 777 /plugins 
RUN mkdir -m 777 /log
RUN chown -R terraria:terraria /tshock
RUN chown -R terraria:terraria /world
RUN chown -R terraria:terraria /plugins
RUN chown -R terraria:terraria /log

# copy in bootstrap
COPY --chown=terraria:terraria --from=base bootstrap.sh /tshock/bootstrap.sh
COPY --chown=terraria:terraria --from=base serverconfig.txt /world/serverconfig.txt

# copy game files
COPY --chown=terraria:terraria --from=base /tshock/* /tshock/

# Allow for external data
VOLUME /world /tshock /plugins /log

# Set working directory to server
WORKDIR /tshock

USER terraria

# run the bootstrap, which will copy the TShockAPI.dll before starting the server
ENTRYPOINT [ "/bin/sh", "bootstrap.sh" ]