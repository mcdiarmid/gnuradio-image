FROM gnuradio/ci:ubuntu-24.04-3.10
LABEL maintainer="campbell.mcdiarmid@icloud.com"

# User:Group for volume file permissions
ARG USER=docker
ARG UID=1000
ARG GID=1000

# For particular builds specify tag, e.g. GNURADIO_TAG=v3.10.9.2
ARG GR_BRANCH="main"
ARG GR_PREFIX="/usr/local/"
ENV GR_CLONE_DIR="gnuradio"

# Configure User
RUN groupadd --gid ${GID} ${USER} && \
    useradd --create-home ${USER} --uid=${UID} --gid=${GID} --groups root && \
    passwd --delete ${USER}

RUN apt update && \
    apt install -y sudo && \
    adduser ${USER} sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt -y install tzdata

# Clone, build, and install GNURadio
WORKDIR /tmp/
RUN git clone --recursive --depth 1 --branch ${GR_BRANCH} \
    https://github.com/gnuradio/gnuradio.git ${GR_CLONE_DIR}
RUN mkdir -p ${GR_CLONE_DIR}/build/ && cd ${GR_CLONE_DIR}/build/ && \
    cmake ../ -DCMAKE_INSTALL_PREFIX=${GR_PREFIX} && \
    make -j$((`nproc`+1)) && \
    make install && \
    ldconfig

RUN rm -rf ${GR_CLONE_DIR}/

# Set User and Workdir after installing GNURadio
USER ${UID}:${GID}
WORKDIR /home/${USER}
ENTRYPOINT [ "/bin/bash" ]