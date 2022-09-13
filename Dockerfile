FROM ubuntu:20.04

USER root

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y curl \
    build-essential \
    ccache \
    wget \
    zlib1g-dev \
    liblapack-dev \
    libblas-dev \
    apt-transport-https \
    git \
    tar && \
    apt-get update -y && \
    apt-get upgrade -y

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-py37_4.10.3-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-py37_4.10.3-Linux-x86_64.sh -b \
    && rm -f Miniconda3-py37_4.10.3-Linux-x86_64.sh

WORKDIR /tmp

RUN git clone https://github.com/ChristophKirst/ClearMap2.git && \
    cd ClearMap2 && \
    conda env update --name base -f ClearMap_stable.yml --prune

#RUN conda env update --name base -f local.yml

#RUN apt-get install -y mesa-common-dev \
#    libglu1-mesa-dev \
#    xcb

#RUN apt-get install --reinstall libxcb-xinerama0 -y

#RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

#RUN apt-get install -y ffmpeg \
#    libsm6 \
#    libxext6

#RUN export QT_QPA_PLATFORM=offscreen

RUN apt-get install apt-file -y && \
    apt-file update

RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
RUN apt-get install ffmpeg libsm6 libxext6 -y

COPY init.py .

RUN python init.py

COPY local.yml .

RUN conda env update --name base -f local.yml

RUN pip install notebook jupyterlab

ENTRYPOINT [ "jupyter", "lab" ]
