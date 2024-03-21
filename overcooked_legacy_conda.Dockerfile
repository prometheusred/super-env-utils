FROM ubuntu:22.04

RUN apt-get update && apt-get install -y wget git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /miniconda.sh && \
    bash /miniconda.sh -b -p /miniconda3 && \
    rm -rf /miniconda.sh

RUN /miniconda3/bin/conda create -y --name py37 python=3.7 numpy==1.15.1 pandas==1.0.5 tensorflow-gpu==1.13.1 mpi4py notebook && \
    /miniconda3/bin/conda clean -a -y

WORKDIR /usr/src/app

# Clone the legacy overcooked_ai repository
RUN git clone --recursive https://github.com/HumanCompatibleAI/human_aware_rl.git

WORKDIR /usr/src/app/human_aware_rl

RUN /miniconda3/bin/conda run -n py37 ./install.sh

# Expose the port Jupyter Notebook runs on
EXPOSE 8888

# Set the default command to run when starting the container
CMD ["/miniconda3/envs/py37/bin/jupyter", "notebook", "--ip=0.0.0.0", "--allow-root", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.password=''"]
