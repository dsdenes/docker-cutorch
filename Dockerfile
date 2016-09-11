FROM nvidia/cuda:7.5
MAINTAINER Denes Pal "dsdenes@gmail.com"

COPY . ~/

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# Required packages
RUN apt-get update
RUN apt-get -y install \
    python \
    build-essential \
    python2.7-dev \
    python-pip \
    git \
    software-properties-common

# Torch and luarocks
RUN git clone https://github.com/torch/distro.git ~/torch --recursive && cd ~/torch && \
    bash install-deps && \
    ./install.sh -b

ENV LUA_PATH='~/.luarocks/share/lua/5.1/?.lua;~/.luarocks/share/lua/5.1/?/init.lua;~/torch/install/share/lua/5.1/?.lua;~/torch/install/share/lua/5.1/?/init.lua;./?.lua;~/torch/install/share/luajit-2.1.0-beta1/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua'
ENV LUA_CPATH='~/.luarocks/lib/lua/5.1/?.so;~/torch/install/lib/lua/5.1/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so'
ENV PATH=~/torch/install/bin:$PATH
ENV LD_LIBRARY_PATH=~/torch/install/lib:$LD_LIBRARY_PATH
ENV DYLD_LIBRARY_PATH=~/torch/install/lib:$DYLD_LIBRARY_PATH
ENV LUA_CPATH='~/torch/install/lib/?.so;'$LUA_CPATH

WORKDIR ~

RUN && \
  pip install -r ./python_requirements.txt && \
  luarocks install torch && \
  luarocks install nn && \
  luarocks install rnn && \
  luarocks install optim && \
  luarocks install lua-cjson

RUN && \
  luarocks install cutorch && \
  luarocks install cunn && \
  
