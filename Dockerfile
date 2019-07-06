FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && \
    apt-get install -y sudo wget netbase bzip2 ca-certificates curl git libglib2.0-0 libgl1-mesa-glx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.6.14-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "export PATH=/opt/conda/bin:$PATH" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

ADD environment.yml /tmp/environment.yml
RUN conda env update --file /tmp/environment.yml

ADD run.sh /run.sh

ENTRYPOINT [ "/run.sh" ]
