# https://github.com/jcjohnson/neural-style
# http://www.makeuseof.com/tag/create-neural-paintings-deepstyle-ubuntu/
# https://github.com/kchen-tw/docker_neural-style/blob/master/Dockerfile
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

# RUN apt-get update && apt-get install -y --no-install-recommends \
# 	build-essential \
# 	software-properties-common \
# 	gcc \
# 	cmake \
# 	unzip \
# 	wget \
# 	git \
# 	vim \
# 	curl \
# 	libprotobuf-dev \
# 	protobuf-compiler \
# 	lua5.2 \
# 	lua5.2-dev \
# 	luarocks \
# 	luajit 
# 	# && 

# RUN apt-get update && apt-get install -y --no-install-recommends \
# 	luarocks \
# 	build-essential \
# 	unzip



# INSTALL LUA DEPENDENCIES
# RUN luarocks install luasocket
# RUN luarocks install image
# RUN luarocks install nn
# RUN /usr/local/bin/luarocks install nn
# Step 5 : RUN . ~/.bashrc && /usr/local/bin/luarocks install nn
#  ---> Running in 45c960af92e0
# /bin/sh: 13: /root/.bashrc: shopt: not found
# /bin/sh: 21: /root/.bashrc: shopt: not found
# /bin/sh: 1: /usr/local/bin/luarocks: not found


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


# https://github.com/kchen-tw/docker_neural-style/blob/master/Dockerfile
# FROM ubuntu:14.04
# MAINTAINER kChen "kchen.ntu@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y curl wget software-properties-common

# Install torch7
WORKDIR /root
RUN curl -s https://raw.githubusercontent.com/torch/ezinstall/master/install-deps | bash
RUN git clone https://github.com/torch/distro.git ~/torch --recursive
WORKDIR /root/torch
RUN /root/torch/install.sh


# Install loadcaffe./r
RUN apt-get install -y libprotobuf-dev protobuf-compiler
RUN /root/torch/install/bin/luarocks install loadcaffe

# luarocks install torch
RUN /root/torch/install/bin/luarocks install cutorch

# Install neural-style
WORKDIR /root
RUN git clone --depth 1 https://github.com/jcjohnson/neural-style.git

WORKDIR /root/neural-style
RUN bash models/download_models.sh


# https://github.com/jcjohnson/neural-style
# th neural_style.lua -gpu -1 -style_image /projects/photos/style/The-Tree-Of-Life.jpg -content_image /projects/photos/source/amy_b-w.jpeg -output_image /projects/photos/output/amy_tree_of_life.png

# /root/torch/install/bin/luajit: /root/torch/install/share/lua/5.1/trepl/init.lua:384: module 'cutorch' not found:No LuaRocks module found for cutorch
#        	no field package.preload['cutorch']
#        	no file '/root/.luarocks/share/lua/5.1/cutorch.lua'
#        	no file '/root/.luarocks/share/lua/5.1/cutorch/init.lua'
#        	no file '/root/torch/install/share/lua/5.1/cutorch.lua'
#        	no file '/root/torch/install/share/lua/5.1/cutorch/init.lua'
#        	no file './cutorch.lua'
#        	no file '/root/torch/install/share/luajit-2.1.0-beta1/cutorch.lua'
#        	no file '/usr/local/share/lua/5.1/cutorch.lua'
#        	no file '/usr/local/share/lua/5.1/cutorch/init.lua'
#        	no file '/root/.luarocks/lib/lua/5.1/cutorch.so'
#        	no file '/root/torch/install/lib/lua/5.1/cutorch.so'
#        	no file '/root/torch/install/lib/cutorch.so'
#        	no file './cutorch.so'
#        	no file '/usr/local/lib/lua/5.1/cutorch.so'
#        	no file '/usr/local/lib/lua/5.1/loadall.so'
# stack traceback:
#        	[C]: in function 'error'
#        	/root/torch/install/share/lua/5.1/trepl/init.lua:384: in function 'require'
#        	neural_style.lua:51: in function 'main'
#        	neural_style.lua:515: in main chunk
#        	[C]: in function 'dofile'
#        	/root/torch/install/lib/luarocks/rocks/trepl/scm-1/bin/th:145: in main chunk
#        	[C]: at 0x00406670

