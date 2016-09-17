# https://github.com/jcjohnson/neural-style
# http://www.makeuseof.com/tag/create-neural-paintings-deepstyle-ubuntu/
# https://github.com/kchen-tw/docker_neural-style/blob/master/Dockerfile
# FROM nvidia/cuda:8.0-cudnn5-runtime
FROM nvidia/cuda:8.0-cudnn5-devel

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

# ROUTE OTHER REQUESTS THROUGH SQUID PROXY

RUN  echo 'http_proxy="http://192.168.150.50:3128/"' >> /etc/environment; \
	echo 'https_proxy="http://192.168.150.50:3128/"' >> /etc/environment; \
	echo 'ftp_proxy="http://192.168.150.50:3128/"' >> /etc/environment; \
	echo 'no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"' >> /etc/environment; \
	echo 'HTTP_PROXY="http://192.168.150.50:3128/"' >> /etc/environment; \
	echo 'HTTPS_PROXY="http://192.168.150.50:3128/"' >> /etc/environment; \ 
	echo 'FTP_PROXY="http://192.168.150.50:3128/"' >> /etc/environment; \ 
	echo 'NO_PROXY="localhost,127.0.0.1,localaddress,.localdomain.com"' >> /etc/environment; \ 
	echo 'use_proxy=yes' >> /root/.wgetrc; \
	echo 'http_proxy=192.168.150.50:3128' >> /root/.wgetrc
# RUN  echo 'https_proxy=192.168.150.50:3142' >> /root/.wgetrc



ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
	curl \
	wget \
	software-properties-common \
	libprotobuf-dev \
	protobuf-compiler


# Install torch7
WORKDIR /opt
RUN curl -s https://raw.githubusercontent.com/torch/ezinstall/master/install-deps | bash
RUN git clone https://github.com/torch/distro.git /opt/torch --recursive
WORKDIR /opt/torch
RUN /opt/torch/install.sh


# Install loadcaffe./r
RUN /opt/torch/install/bin/luarocks install loadcaffe

# Install neural-style
WORKDIR /opt
RUN git clone --depth 1 https://github.com/jcjohnson/neural-style.git

WORKDIR /opt/neural-style
# RUN bash models/download_models.sh
ADD models /opt/neural-style/models/


# wget -c https://gist.githubusercontent.com/ksimonyan/3785162f95cd2d5fee77/raw/bb2b4fe0a9bb0669211cf3d0bc949dfdda173e9e/VGG_ILSVRC_19_layers_deploy.prototxt
# wget -c --no-check-certificate https://bethgelab.org/media/uploads/deeptextures/vgg_normalised.caffemodel
# wget -c http://www.robots.ox.ac.uk/~vgg/software/very_deep/caffe/VGG_ILSVRC_19_layers.caffemodel
# wget -c http://www.robots.ox.ac.uk/~vgg/software/very_deep/caffe/VGG_ILSVRC_19_layers.caffemodel -e use_proxy=yes -e http_proxy=http://192.168.150.50:3128




# https://github.com/jcjohnson/neural-style
# th neural_style.lua -gpu -1 -style_image /projects/photos/style/The-Tree-Of-Life.jpg -content_image /projects/photos/source/amy_b-w.jpeg -output_image /projects/photos/output/amy_tree_of_life.png


