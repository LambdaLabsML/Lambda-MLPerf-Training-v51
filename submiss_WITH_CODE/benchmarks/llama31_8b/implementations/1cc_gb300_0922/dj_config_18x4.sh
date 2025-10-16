source $(dirname ${BASH_SOURCE[0]})/config_common.sh
source $(dirname ${BASH_SOURCE[0]})/config_common_cg.sh
source $(dirname ${BASH_SOURCE[0]})/config_common_8b.sh

export MINIBS=1
export TENSOR_MODEL_PARALLEL=1
export SEQ_PARALLEL=False

export PIPELINE_MODEL_PARALLEL=1
# DM: Was null
export INTERLEAVED_PIPELINE=null
export CONTEXT_PARALLEL=2

export TP_COMM_OVERLAP=False
# DM: Was 1
export MICRO_BATCH_SIZE=1

# DM: Was 98
export WARMUP_STEPS=98
export VAL_CHECK_INTERVAL=342

# DM: Was 0.0008
export LR=0.0008

export DGXNNODES=18
export DGXNGPU=4
export SEGMENT=18
export DGXSYSTEM=$(basename $(readlink -f ${BASH_SOURCE[0]}) | sed 's/^config_//' | sed 's/\.sh$//' )

# DM: 10/15 first borrow from Supermicro, MBS and GBS
export GBS=72
export MBS=2
export GLOBAL_BATCH_SIZE=72
export _GLOBAL_NUM_MICROBATCHES_CALCULATOR=72
export MICRO_BATCH_SIZE=2

export WALLTIME_RUNANDTIME=30
export WALLTIME=$((5 + ${NEXP:-1} * ($WALLTIME_RUNANDTIME + 5)))
