FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

# MAINTAINER Kirill Mazur <makezur@gmail.com>
ARG opencv_version=3.4.1
ARG tf_version=1.11
ARG torch_verion=1.0
# ------ System packages ------

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
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
        ffmpeg \
        xvfb \
        pkg-config \
        zip \
        zlib1g-dev \ 
        g++ \
        libatlas-base-dev \
        libavcodec-dev \
        libavformat-dev \
        libavresample-dev \
        libgtk2.0-dev \
        libgtk-3-dev \
        libjasper-dev \
        libjpeg-dev \
        libpng-dev \
        libswscale-dev \
        libtiff5-dev \
        libv4l-dev \
        libxvidcore-dev \
        libx264-dev \
        pkg-config \
        libvtk5-dev \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


WORKDIR /opt
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/${opencv_version}.zip \
    && unzip opencv.zip
RUN wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/${opencv_version}.zip \
    && unzip opencv_contrib.zip

WORKDIR /opt/opencv-${opencv_version}/build
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-${opencv_version}/modules \
    -D ENABLE_NEON=ON \
    -D ENABLE_VFPV3=ON \
    -D BUILD_TESTS=OFF \
    -D WITH_VTK=ON \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D BUILD_EXAMPLES=OFF ..

RUN make -j4 \
    && make install \
    && make clean

WORKDIR /
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
RUN pip install tensorflow-gpu==${tf_version}}

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

# RUN pip install gym
# RUN pip install gym[atari]


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

# WORKDIR 

CMD ["bash"]