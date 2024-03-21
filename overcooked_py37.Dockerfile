FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install software-properties-common to add PPAs and other system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    python3.7 \
    python3-pip \
    python3.7-dev \
    python3.7-venv \
    git && \
    python3.7 -m pip install --upgrade pip && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 1 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1 && \
    rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=""

# Create and use a virtual environment
RUN python3.7 -m venv /usr/src/app/venv
ENV PATH="/usr/src/app/venv/bin:$PATH"

# Set the working directory in the container
WORKDIR /usr/src/app

# Clone the overcooked_ai repository
RUN git clone https://github.com/HumanCompatibleAI/overcooked_ai.git

# Change to the cloned directory
WORKDIR /usr/src/app/overcooked_ai

# Install the overcooked_ai project in editable mode with the 'harl' extra
RUN pip install -e '.[harl]'

RUN pip install notebook

# Expose the port Jupyter Notebook runs on
EXPOSE 8888

# Set the default command to run when starting the container
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--allow-root", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.password=''"]
