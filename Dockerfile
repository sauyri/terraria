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
    apt-get install -y nuget && \
    rm -rf /var/lib/apt/lists/* /tmp/*

    # create directories
RUN mkdir -m 777 /tshock /world /plugins /log && \
    chown -R terraria:terraria /tshock && \
    chown -R terraria:terraria /world && \
    chown -R terraria:terraria /plugins

# copy in bootstrap
COPY --chown=terraria:terraria --from=base bootstrap.sh /tshock/bootstrap.sh
COPY --chown=terraria:terraria --from=base serverconfig.txt /world/serverconfig.txt

# copy game files
COPY --chown=terraria:terraria --from=base /tshock/* /tshock/
COPY --chown=terraria:terraria --from=base /tshock/BCrypt.Net.dll /tshock/
COPY --chown=terraria:terraria --from=base /tshock/HttpServer.dll /tshock/ServerPlugins/BCrypt.Net.dll
COPY --chown=terraria:terraria --from=base /tshock/Mono.Data.Sqlite.dll /tshock/ServerPlugins/Mono.Data.Sqlite.dll
COPY --chown=terraria:terraria --from=base /tshock/MySql.Data.dll /tshock/ServerPlugins/MySql.Data.dll

# Allow for external data
#VOLUME ["/world", "/tshock", "/plugins"]

# Set working directory to server
WORKDIR /tshock

USER terraria

#CMD [ "-config /world/serverconfig.txt" ]

# run the bootstrap, which will copy the TShockAPI.dll before starting the server
ENTRYPOINT [ "/bin/sh", "bootstrap.sh" ]