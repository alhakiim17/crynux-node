#!/bin/bash
# Example call: ./package.sh

## Package the worker
source worker/venv/bin/activate
# change in controlnet_aux/zoe/zoedepth/models/layers/attractor.py
TAR_FILE=worker/venv/lib/python3.10/site-packages/controlnet_aux/zoe/zoedepth/models/layers/attractor.py
sed -i.bak "s/@torch.jit.script/#@torch.jit.script/g" $TAR_FILE

pyinstaller crynux_worker_process.spec

## Package the node
source venv/bin/activate
pyinstaller crynux.spec

## Copy the worker
mv "dist/crynux_worker_process" "dist/crynux_node/crynux_worker_process"

## Create the data and config folders
mkdir "dist/crynux_node/config"
cp "../../config/config.yml.package_example" "dist/crynux_node/config/config.yml"

mkdir "dist/crynux_node/data"
mkdir "dist/crynux_node/data/external"
mkdir "dist/crynux_node/data/huggingface"
mkdir "dist/crynux_node/data/results"
mkdir "dist/crynux_node/data/inference-logs"

## Copy the Web UI
mkdir "dist/crynux_node/webui"
cp -r "webui/dist" "dist/crynux_node/webui/"

## Copy the resources
cp -r "res" "dist/crynux_node/"

## Generate the tar file
tar -czvf crynux_node.tar.gz "dist/crynux_node"
