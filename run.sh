#!/bin/sh

# variables
script_dir=$(cd $(dirname $0); pwd)
env_name="proxy"

# init conda
eval "$(conda shell.bash hook)"

# check if conda environment is installed
if ! conda env list | grep -q "$env_name"; then
    echo "creating conda environment $env_name ..."
    conda create --name "$env_name" python=3.12 -y
    conda activate "$env_name"
    pip install --no-input -r $script_dir/requirements.txt
fi

# activate conda environment
echo "activating conda environment $env_name ..."
conda activate "$env_name"

# run mitmdump
echo "starting mitmdump ..."
mitmdump -s proxy.py -k --listen-port 8090