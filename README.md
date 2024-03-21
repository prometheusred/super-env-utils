# Environment setup


## CUDA containers

### prerequisites:
1. cuda drivers
2. nvidia container toolkit for GPU support: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
3. Make sure to use image with correct version of cuda toolkit / cudnn for version of TF 

### build

``` 
$ docker build -t overcooked_py37 -f overcooked_py37.Dockerfile .

$ docker run --name overcooked_gpu_instance --gpus all -p 8888:8888 -it overcooked_py37`

$ docker container prune
```


## ansible

### prerequisites:
1. setup tailscape
2. setup ansible hosts in config

### commands:

```
```
