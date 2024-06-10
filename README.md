# gnuradio-image
Quick and easy Docker image for running GNURadio.
This leverages the Docker images defined by official GNURadio maintainers, used in Github workflows of the GNURadio repository.

## Building

For the latest on GNURadio's main branch:
```bash
docker build --tag=my-gnuradio-image .
```

For a specific release, e.g. v3.10.10.0:
```bash
docker build --build-arg="GR_BRANCH=v3.10.10.0" --tag=my-gnuradio-image .
```

## Running (Locally or over SSH with X11 Forwarding)

```bash
docker run --rm -e DISPLAY=$DISPLAY --volume ~/.Xauthority:/root/.Xauthority:ro -it --net=host --entrypoint bash my-gnuradio-image
```

### Persisting Files
If you'd like your files to persist, or if you wish to develop using files on your host system, the easiest way is to share volume(s) between your system and the Docker container.

Below is a modified version of the above command, with two new volumes specified:

```bash
docker run --rm -e DISPLAY=$DISPLAY \
  --volume ~/.Xauthority:/root/.Xauthority:ro \
  --volume ~/Documents/flowgraphs/:/root/flowgraphs/:rw \
  --volume ~/Documents/recordings/:/root/recordings/:rw \
  -it --net=host --entrypoint bash my-gnuradio-image
```

### X11 Forwarding over SSH

Speaking of volumes, why does the first command contain `--volume ~/.Xauthority:/root/.Xauthority:ro`?
Sharing this between the host system and the container, along with the `DISPLAY` environment variable allows the user to run X11 applications from the container.

This might not work out of the box for you though.
Here's a list of things you'll need to check if you're running GNURadio remotely:
- (Windows only) Do I have an X11 display server installed?  E.g. Xming/VcXsrv
- (Windows only) Is my X11 display server currently running?
- Is my `DISPLAY` environment variable set when executing my SSH command?
- Have I enabled X11 Forwarding in my SSH connection command?  Either with the `-Y` flag, or modify your `~/.ssh/config` file to override defaults for your remote server.
- Have I enabled X11 Forwarding in the SSHD config on the remote server?

## Running Different GNURadio Versions

If you want a different version of GNURadio, or you don' want an Ubuntu based image, head to https://github.com/gnuradio/gnuradio-docker/tree/master/ci 
for a list of images you can use as a base. 
Most of these images are hosted on docker, so you should just need to modify the first line of the Dockerfile provided in this repository.
