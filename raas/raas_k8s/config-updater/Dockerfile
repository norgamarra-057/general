FROM debian

# allow https API calls:
RUN apt-get update && apt-get install -y ca-certificates

COPY ./config-updater /usr/bin/config-updater
ENTRYPOINT ["/usr/bin/config-updater"]
