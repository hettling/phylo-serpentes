#!/bin/bash

#SBATCH -A snic2015-1-72
#SBATCH -J snakes
#SBATCH -o snakes.out

#SBATCH -t 168:00:00

#SBATCH -p node -n 16

module load openmpi/1.6.5 
module load bioinfo-tools
module load blast/2.2.24+
module load perl

export PATH=$PATH:/home/hannesh/SUPERSMART/tools/bin/
export PATH=$PATH:/home/hannesh/SUPERSMART/src/supersmart/script

sh workflow.sh
