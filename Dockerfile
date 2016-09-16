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
	wget \
	git \
	vim \
	&& rm -rf /var/lib/apt/lists/*


# INSTALL TORCH
WORKDIR "/opt/torch"
# http://torch.ch/docs/getting-started.html
# in a terminal, run the commands WITHOUT sudo
RUN git clone https://github.com/torch/distro.git ~/torch --recursive
WORKDIR $WORKDIR
# RUN cd $WORKDIR; bash install-deps;
# RUN ./install.sh

