#!/bin/bash
set -e
docker run --rm \
    --user "${USER}" \
    --workdir "${HOME}" \
    --volume="${HOME}":"${HOME}" \
    --env TERM=xterm-256color \
    --env DISPLAY=${DISPLAY} \
    --net=host \
    -it my-gnuradio-image
