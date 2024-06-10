FROM gnuradio/ci:ubuntu-24.04-3.10
LABEL maintainer="campbell.mcdiarmid@icloud.com"

# For particular builds specify tag, e.g. GNURADIO_TAG=v3.10.9.2
ARG GR_BRANCH="main"
ARG GR_PREFIX="/usr/local/"

WORKDIR /root

RUN git clone --depth 1 --branch ${GR_BRANCH} https://github.com/gnuradio/gnuradio.git
RUN mkdir -p gnuradio/build/ && cd gnuradio/build/ \
  && cmake ../ -DCMAKE_INSTALL_PREFIX=${GR_PREFIX} \
  && make -j8 \
  && make install \
  && ldconfig

RUN rm -rf gnuradio/
