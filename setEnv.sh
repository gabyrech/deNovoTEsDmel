#!/usr/bin/bash
#SBATCH --job-name=repet
#SBATCH --cpus-per-task=1 
#SBATCH --mem-per-cpu=8G 


module load REPET/2.5-linux-x64

#Modify this accordingly...
export REPET_HOST=
export REPET_USER=
export REPET_PW=
export REPET_DB=
export REPET_PORT=

export REPET_PATH=
export SMART=$REPET_PATH/SMART/Java/Python
export PYTHONPATH=$REPET_PATH
export REPET_JOBS=MySQL
export REPET_JOB_MANAGER=SLURM
export REPET_QUEUE=SLURM
export PATH=$REPET_PATH/bin:$SMART:$PATH
