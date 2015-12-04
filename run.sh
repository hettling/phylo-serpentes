#!/bin/bash

#SBATCH -A snic2015-1-72
#SBATCH -J snakes-exabayes-1
#SBATCH -t 02:00:00
#SBATCH -p node -n 16
#SBATCH -o snakes-reroot-1.out

OUTFILE=snakes-exabayes-1.out
          
module load openmpi/1.6.5 
module load bioinfo-tools
module load blast/2.2.29+
export PATH=$PATH:/home/hannesh/SUPERSMART/tools/bin/
export PATH=$PATH:/home/hannesh/SUPERSMART/src/supersmart/script

########################
# SUPERSMART PIPELINE  #
########################

#NAMES=names.txt
#FOSSILS=fossils.tsv
INGROUP=Serpentes
OUTGROUP=Basiliscus
INFERENCE_TOOL="exabayes"

BACKBONE_STEM="backbone-"$INFERENCE_TOOL
REROOTED=$BACKBONE_STEM"-rerooted.dnd"

export SUPERSMART_BACKBONE_MAX_DISTANCE="0.2"
export SUPERSMART_BACKBONE_MIN_COVERAGE="4"
export SUPERSMART_EXABAYES_NUMGENS="100000"
export SUPERSMART_CLADE_MAX_DISTANCE="0.1"
export SUPERSMART_CLADE_MIN_DENSITY="0.5"

#smrt taxize -r $INGROUP,$OUTGROUP -b
#smrt align
#smrt orthologize
#smrt bbmerge

echo "Backbone inference with $INFERENCE_TOOL"
if [ $INFERENCE_TOOL == "exabayes" ]; then
    BACKBONE=$BACKBONE_STEM."dnd"
#    smrt bbinfer --inferencetool=exabayes --cleanup -o $BACKBONE
elif [ $INFERENCE_TOOL == "examl" ]; then
    BACKBONE=$BACKBONE_STEM."dnd"
#    smrt bbinfer --inferencetool=examl --cleanup -b 100 -t species.tsv -o $BACKBONE
elif [ $INFERENCE_TOOL == "raxml" ]; then
    BACKBONE=$BACKBONE_STEM."nex"
#    smrt bbinfer --inferencetool=raxml -b 400 -t species.tsv -r --cleanup -o $BACKBONE
fi

smrt bbreroot -g $OUTGROUP --smooth --backbone $BACKBONE -o $REROOTED
#smrt bbcalibrate -f $FOSSILS -t $REROOTED
#smrt consense -b 0.2 --prob
#smrt bbdecompose
#smrt clademerge --enrich
#smrt cladeinfer --ngens=15_000_000 --sfreq=1000 --lfreq=1000
#smrt cladegraft

(echo -e "OUTFILE:$OUTFILE\n"\
"OUTGROUP:$OUTGROUP\n"\
"INFERENCE_TOOL=$INFERENCE_TOOL\n"\
"MAXIDST:$SUPERSMART_BACKBONE_MAX_DISTANCE\n"\
"COVER:$SUPERSMART_BACKBONE_MIN_COVERAGE\nOUTFILE CONTENTS:" && cat $OUTFILE) | mail -s "smrt job $OUTFILE finished" hannes.hettling@gmail.com 
