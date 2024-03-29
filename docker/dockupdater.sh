#!/bin/bash
docker run -d --name dockupdater \
    -e CLEANUP=true \
    -e RUN_ONCE=true \
    -e LOG_LEVEL=info \
    -e CRON="*/5 * * * *" \
    -e WAIT=180 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    dockupdater/dockupdater
