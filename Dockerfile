FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && \
    apt-get install -y sudo wget netbase bzip2 ca-certificates curl git libglib2.0-0 libgl1-mesa-glx libqt5x11extras5 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.6.14-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" > /etc/profile.d/use_conda.sh && \
    echo "export PATH=/opt/conda/bin:$PATH" >> /etc/profile.d/use_conda.sh && \
    echo "source activate base" >> /etc/profile.d/use_conda.sh

RUN chmod +x /etc/profile.d/use_conda.sh

ADD environment.yml /tmp/environment.yml
RUN conda env update --file /tmp/environment.yml

ADD run.sh /run.sh

ENTRYPOINT [ "/run.sh" ]
