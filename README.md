# gnuradio-image
Quick and easy Docker image for running GNURadio.
This leverages the Docker images defined by official GNURadio maintainers, used in Github workflows of the GNURadio repository.

## Usage Summary

Make sure you have docker installed.
On a Linux, makke sure and that your user credentials have been added to the `docker` group: `sudo groupadd docker && sudo usermod -aG $USER docker`.

Executing `./build.sh` will build a Docker image with GNURadio ready to go.

Executing `./run.sh` will start a container with the GNURadio image.
Any files saved in your home directory in the container will be saved to your host system and persist even when the container is closed.
You will be able to run graphical applications such as GNURadio Companion, or flowgraphs with GUI components from this container.

## Building

[`build.sh`](./build.sh) does the following things for you:

1. Build a Docker image with GNURadio compiled from source.
An optional positional argument can be provided to specify the version/tag/branch of GNURadio you wish to build.  E.g. `./build.sh main` for latest developer build, or `./build.sh v3.9.6.0` for version 3.9.6.0 (defaults to v3.10.10.0).

1. Creates a user account in the container mirroring your local user account.
User is added to `sudoers` and will not be prompted for a password when running a command with elevated privileges.
Additionally, any files created and saved in a shared volume by the container will have the same ownership and permissions as if they were created outside of the container.
This saves the user the hassle of changing ownership of shared files constantly.


## Running

Other than saving the user a few dozen key strokes, [`run.sh`](./run.sh) does the following for you:

1. Starts an interactive `bash` terminal in the container with your local user credentials.

1. Sets the `DISPLAY` environment variable to match your host system.
This is one of the pre-requisites for running graphical applications via X11 from within a container.

1. Mounts your user's home directory as a volume, so any files created there will be shared between the host system and container.
This has been done for two reasons:
    - Your `.Xauthority` needs to be shared with the container if you wish to run any graphical applications via X11 forwarding.
   This is conveniently located in your home directory.
    - If you develop GNURadio flowgraphs or create signal recordings and with to keep them, the easiest way is to save them in a shared volume between host system and container.

1. Shares your host system's network access with the container.


### Running Graphical Applications over SSH

Here's a list of things you'll need to check if you want to run GNURadio Companion, or any other GUI application remotely:

- (Windows only) Do I have an X11 display server installed?
  E.g. Xming/VcXsrv

- (Windows only) Is my X11 display server currently running?

- (Windows only) Is my `DISPLAY` environment variable set when executing my SSH command?
  This is not set by default on Windows.
  Your X11 server should tell you what to set this to - usually `localhost:0.0` or `:0.0`.
  As a once-off, you can just prefix your ssh command.  
  E.g. `DISPLAY=localhost:0.0 ssh user@remote-server -Y`
  
  The following are persistent soulutions:
  - **Windows cmd**: run `setx DISPLAY localhost:0.0`.

  - **Bash-like terminal**: Add the following line to your `~/.bashrc` - `export DISPLAY=localhost:0.0`.

- Have I enabled X11 Forwarding in my SSH connection command?
  Either with the `-Y` flag, or modify your `~/.ssh/config` file to override defaults for your remote server.

  ```bash
  Host remote-server-name optional-alias
    ForwardAgent yes
    ForwardX11 yes
    ForwardX11Trusted yes
  ```
  Note: if you wish to override defaults for all servers, replace the first line with `Host *`, as the wildcard will match all hostnames.

- Have I enabled X11 Forwarding in the SSHD config on the remote server? 
  Check that `/etc/ssh/sshd_config` contains the following un-commented lines.

  ```bash
  X11Forwarding yes
  X11DisplayOffset 10
  ```
  
  If not, add them and restart the ssh service: `sudo service ssh restart`

- (Optional) Create a private-public key pair for your SSH connection(s), and use `ssh-copy-id` to copy the public key to the remote server.
  This allows you to start SSH connections without a login prompt.

## Different Linux OS for Docker Image

If you don't want an Ubuntu based image, head to https://github.com/gnuradio/gnuradio-docker/tree/master/ci 
for a list of images you can use as a base. 
Most of these images are hosted on docker, so you should just need to modify the first line of the Dockerfile provided in this repository.
