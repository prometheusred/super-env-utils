FROM nvcr.io/nvidia/jax:23.10-py3

RUN apt-get update && apt-get install -y wget git ffmpeg \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install imageio notebook

WORKDIR /usr/src/app

RUN git clone https://github.com/FLAIROx/JaxMARL.git

WORKDIR /usr/src/app/JaxMARL
RUN pip install -e .

EXPOSE 8888

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--allow-root", "--no-browser"]
