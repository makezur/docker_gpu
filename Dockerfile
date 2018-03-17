FROM nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04

MAINTAINER Kirill Mazur <makezur@gmail.com>

# ------ System packages ------

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        rsync \
        unzip \
        vim \
        bzip2 \
        ca-certificates \
        cmake \
        git \
        wget \
        curl \
        tmux \
        graphicsmagick \
        pkg-config \
        zip \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*



# ------- Conda -------

RUN apt-get -qq update && apt-get -qq -y install curl bzip2 \
    && curl -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /usr/local \
    && rm -rf /tmp/miniconda.sh \
    && conda install -y python=3 \
    && conda update conda \
    && apt-get -qq -y remove curl bzip2 \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log \
    && conda clean --all --yes

ENV PATH /opt/conda/bin:$PATH


#  ------- Pytorch -------
RUN conda install pytorch torchvision -c pytorch


# Install TensorFlow (gpu version)
RUN pip install tensorflow-gpu==1.4

# For CUDA profiling, TensorFlow requires CUPTI.
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH


# Install tensorboardX for pytorch

RUN pip install tensorboardX


# Python libs
RUN conda install \
        jupyter \
        matplotlib \
        numpy \
        keras \
        pandas \
        scipy \
    scikit-learn \
        seaborn \
        tqdm \
        scikit-image \
        beautifulsoup4 \
        tensorboard \
        nbconvert \
        nltk \
        joblib


# Install gym

RUN pip install gym

# ------ Jupyter ------

# Install python3 kernel
RUN python -m ipykernel.kernelspec

# Setup extensions
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension

# Set up notebook config
COPY ./build_sources/jupyter_notebook_config.py /root/.jupyter/
COPY ./build_sources/run_jupyter.sh /
RUN chmod +x /run_jupyter.sh


# ------ Docker setup ------

# TensorBoard
EXPOSE 6006

# Jupyter notebook
EXPOSE 8888

WORKDIR "/playground"

CMD ["bash"]