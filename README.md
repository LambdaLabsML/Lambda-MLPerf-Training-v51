## MLPerf Training v5.1 Unofficial Submission Results for Lambda
Lambda created an official submission for the latest round of MLPerf Training benchmarking, where we were able to submit results for the Llama2 70b LoRa and Llama3.1 8b models.
We were able to create acceptable results on a full-rack (18 nodes) for GB300s, amongst only two other submitters. However, our B200 submissions were rejected due to faulty
performance. In light of this, we have posthumously rerun these benchmarks such that we could achieve results that are on-par with industry leaders such as Oracle, Dell, and
NVIDIA. This README is aimed to help customers and clients reproduce the same benchmarks on our systems. 

### 1) Docker login + NGC container pull
Firstly, you must login to the NGC registries using your private login credentials:
```bash
docker login nvcr.io
Username: $oauthtoken
Password: <enter NGC password>
```
Once you have gotten access to the containers, you must pull the latest container for your respective model
```bash
export CONT=<container name>    # I.e. the latest container for llama2 70b LoRa at the time of writing is at nvcr.io/nvdlfwea/mlperftv51/llama2_70b_lora-amd:20251008
docker pull $CONT
```

This will pull the docker container that will be used to run the benchmark

### 2) Acquire data and model

For each model, the general process is to download the model itself and the data that it will train on. Continuing with the llama2 70b LoRa example,
we will first enter the docker container with mounted directories back to our shared storage, use the downloading scripts that are provided in the 
docker container to get the model and data in the right format, and then exit the docker container.
```bash
docker run -it --rm --gpus all --network=host --ipc=host --volume <path you want to download dataset + model to>:/data $CONT
python scripts/download_dataset.py --data_dir /data/gov_report     # Downlaods the govreport data and preprocesses it for us
python scripts/download_model.py --model_dir /data/model        # Downloads and preprocesses model checkpoints for us
exit
```

### 3) Get the config files appropriate for your system setup
MLCommons provides optimized configuration files for several different system setups. For our general purpose guide, we will copy all of the provided 
config files over to our shared storage so that we have access to anything that is needed. First, we will go back into the docker container with a 
different directory mounted (it can be the same one as before, but this makes it easier to differentiate), grab all the config files and run.sub file
that runs that actual training, and exit the docker container.
```bash
docker run -it --rm --network=host --ipc=host --volume <path you want to keep config files + run.sub file at>:/mounted $CONT
cp /workspace/ft-llm/config_*.sh /mounted/ && chmod 664 /mounted/config_*.sh      # Copies all the config files and changes their permissions so we can read from them and source them
cp /workspace/ft-llm/run.sub /mounted/ && chmod 775 /mounted/run.sub          # Copies over run.sub file to run the traininga dn changes permissions so we can run it
exit
```

We now have everything we need to actually run the training

### 4) Set correct environment variables and run the training
Now that we have everything set, navigate to the directory with your config and run.sub files. We will source the config files we need and
run the training from here. We need to let our environment know where everything is located by using specified environment variables. They are
different for each model, but generally include the container CONT, where your data DATADIR and model MODEL are stored, and a directory to keep
your logs. Following our guideline for llama2 70b LoRa, the environment variables are listed below:
```bash
export DATADIR="</path/to/dataset>/gov_report"      # set your <path to where the data is>
export MODEL="</path/to/dataset>/model"      # set your <path to where the model is>
export LOGDIR="</path/to/output_logdir>"  # set the place where the output logs will be saved
export CONT=</url/to/container>  # set the container (should have been set before, but no hurt in double-checking)
source config_<system>.sh  # For example if we were using the B200s, we would choose the config_DGXB200_...sh that runs the model the quickest
sbatch -N $DGXNNODES -t $WALLTIME run.sub
```

That is all! The NGC containers with the step-by-step process for each model can be found at https://registry.ngc.nvidia.com.

