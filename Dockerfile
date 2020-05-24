FROM mono:slim

# Update and install needed utils
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl nuget nano zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# fix for favorites.json error
RUN favorites_path="/root/My Games/Terraria" && mkdir -p "$favorites_path" && echo "{}" > "$favorites_path/favorites.json"

# Download and install Vanilla Server
# ENV VANILLA_VERSION=1404

RUN mkdir /tmp/terraria && \
    cd /tmp/terraria && \
    curl -sL https://www.terraria.org/system/dedicated_servers/archives/000/000/038/original/terraria-server-1404.zip?1590253816 --output terraria-server.zip && \
    unzip -q terraria-server.zip && \
    mv */Linux /vanilla
COPY ./serverconfig.txt /tmp/terraria/Windows/serverconfig-default.txt
RUN rm -R /tmp/* && \
    chmod +x /vanilla/TerrariaServer* && \
    if [ ! -f /vanilla/TerrariaServer ]; then echo "Missing /vanilla/TerrariaServer"; exit 1; fi

COPY run-vanilla.sh /vanilla/run.sh

# Commit Hash Metadata
ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/beardedio/terraria"

# Allow for external data
VOLUME ["/config"]

# Run the server
WORKDIR /vanilla
CMD ["./run.sh"]
