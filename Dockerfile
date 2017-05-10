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
#RUN  echo 'Acquire::http { Proxy "http://192.168.150.50:3142"; };' >> /etc/apt/apt.conf.d/01proxy

# ROUTE OTHER REQUESTS THROUGH SQUID PROXY

# RUN  echo 'http_proxy="http://192.168.150.50:3128/"' >> /etc/environment; \
# 	echo 'https_proxy="http://192.168.150.50:3128/"' >> /etc/environment; \
# 	echo 'ftp_proxy="http://192.168.150.50:3128/"' >> /etc/environment; \
# 	echo 'no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"' >> /etc/environment; \
# 	echo 'HTTP_PROXY="http://192.168.150.50:3128/"' >> /etc/environment; \
# 	echo 'HTTPS_PROXY="http://192.168.150.50:3128/"' >> /etc/environment; \ 
# 	echo 'FTP_PROXY="http://192.168.150.50:3128/"' >> /etc/environment; \ 
# 	echo 'NO_PROXY="localhost,127.0.0.1,localaddress,.localdomain.com"' >> /etc/environment; \ 
# 	echo 'use_proxy=yes' >> /root/.wgetrc; \
# 	echo 'http_proxy=192.168.150.50:3128' >> /root/.wgetrc
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
RUN /opt/torch/install/bin/luarocks install loadcaffe; \
	/opt/torch/install/bin/luarocks install nn; \
	/opt/torch/install/bin/luarocks install image; \
	/opt/torch/install/bin/luarocks install paths

# Install neural-style
WORKDIR /opt
RUN git clone --depth 1 https://github.com/jcjohnson/neural-style.git

WORKDIR /opt/neural-style
RUN bash models/download_models.sh
# ADD models /opt/neural-style/models/

# https://github.com/jcjohnson/neural-style
# WORKS! th neural_style.lua -gpu 1 -backend cudnn -style_image /projects/photos/style/The-Tree-Of-Life.jpg -content_image /projects/photos/source/amy_b-w.jpeg -output_image /projects/photos/output/amy_tree_of_life.png

# cpu based
# time th neural_style.lua -gpu -1 -style_image /projects/photos/style/The-Tree-Of-Life.jpg -content_image /projects/photos/source/amy_b-w.jpeg -output_image /projects/photos/output/amy_tree_of_life.png
# real    95m34.102s                                                                                                                                                                          │·············
# user    554m23.064s                                                                                                                                                                         │·············
# sys     511m15.812s


# Adam optimizer. fast, but not great 
# th neural_style.lua -gpu 1 -backend cudnn -cudnn_autotune -optimizer adam -style_image /projects/photos/style/The-Tree-Of-Life.jpg -content_image /projects/photos/source/amy_b-w.jpeg -output_image /projects/photos/output/amy_tree_of_life2.png


# highly opimized for Titan X Pascal
# time th neural_style.lua -gpu 1 -backend cudnn -cudnn_autotune -optimizer lbfgs -style_image /projects/photos/style/The-Tree-Of-Life.jpg -content_image /projects/photos/source/amy_b-w.jpeg -output_image /projects/photos/output/amy_tree_of_life2.png
# real    0m59.122s
# user    0m51.156s
# sys     0m7.460s


# time th neural_style.lua -num_iterations 2000 -gpu 1 -backend cudnn -cudnn_autotune -optimizer lbfgs -style_image examples/inputs/starry_night.jpg -content_image /projects/photos/source/amy_b-w.jpeg -output_image /projects/photos/output/amy_starry_night.png


# customize the model to be used:
# neural_style.lua -gpu 1 -backend cudnn -proto_file models/VGG_ILSVRC_19_layers_deploy.prototxt -model_file models/vgg_normalised.caffemodel -style_image /projects/photos/style/The-Tree-Of-Life.jpg -content_image /projects/photos/source/amy_b-w.jpeg -output_image /projects/photos/output/amy_tree_of_life.png








