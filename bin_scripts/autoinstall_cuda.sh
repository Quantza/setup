#!/bin/bash

# NVIDIA CUDA
# Setup install

isVarDefined "$MY_DEV_DIR"
if [ $? -eq 0 ]; then
	export MY_DEV_DIR="$HOME/dev";
fi

CUDA75_DIR=$MY_DEV_DIR/cuda7.5

if [ ! -d $CUDA75_DIR ]; then
    mkdir $CUDA75_DIR
fi

cd $CUDA75_DIR

# Install
wget -v http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda_7.5.18_linux.run
chmod a+x ./cuda_7.5.18_linux.run
sudo ./cuda_7.5.18_linux.run

if [ "$DISTRO_ID" == "ubuntu" ]; then	
	$PKG_INSTALL_PREFIX ocl-icd-opencl-dev python-pycuda python3-pycuda
fi





