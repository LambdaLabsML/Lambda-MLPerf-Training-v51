#!/bin/bash

source $(dirname ${BASH_SOURCE[0]})/config_common.sh

# hyperparameters
export MAX_STEPS=1150
export LR=0.0004
export MINIBS=4
export TP=1
export SP=0
export CP=2

# Have to disable MCore CG and use our implementation, otherwise if using  with CP_EVAL, it fails with
# AssertionError: Tried replaying a cudagraph with different arguments than what if was created with!
export LAYER_CUDA_GRAPH=0
export MCORE_CUDA_GRAPH=1

# system parameters
export VBOOST_VALUE=0
export DGXNNODES=1
export DGXNGPU=4
export WALLTIME_RUNANDTIME=40
export WALLTIME=$((5 + ${NEXP:-1} * ($WALLTIME_RUNANDTIME + 5)))

