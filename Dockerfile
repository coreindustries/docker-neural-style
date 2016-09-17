# https://github.com/jcjohnson/neural-style
# http://www.makeuseof.com/tag/create-neural-paintings-deepstyle-ubuntu/
FROM nvidia/cuda:8.0-cudnn5-runtime

ADD version.txt /opt/version

#
# MIRROR FOR APT-GET.
# This significantly speeds up buid time
# http://layer0.authentise.com/docker-4-useful-tips-you-may-not-know-about.html
# RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse" > /etc/apt/sources.list && \
#     echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
#     echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-security main restricted universe multiverse" >> /etc/apt/sources.list && \
#     DEBIAN_FRONTEND=noninteractive apt-get update

# CACHE APT-GET REQUESTS LOCALLY. 
# Requires: docker run -d -p 3142:3142 --name apt_cacher_run apt_cacher
# https://docs.docker.com/engine/examples/apt-cacher-ng/
RUN  echo 'Acquire::http { Proxy "http://192.168.150.50:3142"; };' >> /etc/apt/apt.conf.d/01proxy

RUN apt-get update && apt-get install -y --no-install-recommends \
	build-essential \
	software-properties-common \
	gcc \
	cmake \
	unzip \
	wget \
	git \
	vim \
	curl \
	libprotobuf-dev \
	protobuf-compiler \
	lua5.2 \
	lua5.2-dev \
	luarocks \
	luajit 
	# && 

# RUN apt-get update && apt-get install -y --no-install-recommends \
# 	luarocks \
# 	build-essential \
# 	unzip



# INSTALL LUA DEPENDENCIES
# RUN luarocks install luasocket
# RUN luarocks install image
# RUN luarocks install nn
RUN . ~/.bashrc && /usr/local/bin/luarocks install nn


# # INSTALL LOADCAFFE
# WORKDIR "/opt/"
# RUN git clone https://github.com/szagoruyko/loadcaffe
# RUN luarocks install loadcaffe


# # # INSTALL TORCH
# WORKDIR "/opt/torch"
# RUN curl -s https://raw.githubusercontent.com/torch/ezinstall/master/install-all | bash

# WORKDIR "/opt"

# # # INSTALL NEURAL STYLE
# RUN git clone https://github.com/jcjohnson/neural-style.git
# WORKDIR "/opt/neural-style"
# RUN sh models/download_models.sh

# WORKDIR "/opt"

# RUN rm -rf /var/lib/apt/lists/*






