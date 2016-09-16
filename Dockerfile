# https://github.com/jcjohnson/neural-style
FROM nvidia/cuda:8.0-cudnn5-runtime


#
# MIRROR FOR APT-GET.
# This significantly speeds up buid time
# http://layer0.authentise.com/docker-4-useful-tips-you-may-not-know-about.html
RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    DEBIAN_FRONTEND=noninteractive apt-get update

# CACHE APT-GET REQUESTS LOCALLY. 
# Requires: docker run -d -p 3142:3142 --name apt_cacher_run apt_cacher
# https://docs.docker.com/engine/examples/apt-cacher-ng/
RUN  echo 'Acquire::http { Proxy "http://192.168.150.50:3142"; };' >> /etc/apt/apt.conf.d/01proxy

RUN apt-get update && apt-get install -y --no-install-recommends \
	build-essential \
    software-properties-common \
    gcc \
    cmake \
	wget \
	git \
	vim \
	curl \
	libprotobuf-dev \
	protobuf-compiler \
	lua5.2 \
	lua5.2-dev \
	&& rm -rf /var/lib/apt/lists/*


# # INSTALL TORCH
# WORKDIR "/opt/torch"
# # http://torch.ch/docs/getting-started.html
# # in a terminal, run the commands WITHOUT sudo
# RUN git clone https://github.com/torch/distro.git $WORKDIR --recursive
# # WORKDIR $WORKDIR
# RUN cd distro; ./install-deps;
# RUN ./install.sh



# INSTALL LOADCAFFE
WORKDIR "/opt/lua"
RUN wget http://luarocks.org/releases/luarocks-2.4.0.tar.gz
RUN tar zxpf luarocks-2.4.0.tar.gz
RUN cd luarocks-2.4.0; ./configure; sudo make bootstrap;
RUN sudo luarocks install luasec; sudo luarocks install luasocket

WORKDIR "/opt/loadcaffe"
RUN git clone https://github.com/szagoruyko/loadcaffe
RUN luarocks install loadcaffe
