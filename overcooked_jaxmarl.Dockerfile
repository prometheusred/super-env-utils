# FROM ghcr.io/nvidia/jax:jax
FROM nvcr.io/nvidia/jax:23.10-py3

RUN apt-get update && apt-get install -y \
    wget \
    git \
    ffmpeg \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /miniconda.sh && \
    bash /miniconda.sh -b -p /miniconda3 && \
    rm -rf /miniconda.sh

RUN /miniconda3/bin/conda create -y --name jaxmarl python=3.10 notebook imageio && \
    /miniconda3/bin/conda clean -a -y

WORKDIR /usr/src/app

RUN git clone https://github.com/FLAIROx/JaxMARL.git

WORKDIR /usr/src/app/JaxMARL

RUN /miniconda3/bin/conda run -n jaxmarl pip install -e .
ENV PYTHONPATH /usr/src/app/JaxMARL:$PYTHONPATH

# Expose the port Jupyter Notebook runs on
EXPOSE 8888

# Set the default command to run when starting the container
CMD ["/miniconda3/bin/conda", "run", "-n", "jaxmarl", "--no-capture-output", "jupyter", "notebook", "--ip=0.0.0.0", "--allow-root", "--no-browser"]

