#!/bin/bash
# SUPERSMART commands for inefernce of serpentes phylogeny

INGROUP=Serpentes
OUTGROUP=Basiliscus
#FOSSILS=fossils.tsv

export WORKDIR=$PWD/results/`date +%Y-%m-%d`

if [ ! -d $WORKDIR ]; then
    mkdir $WORKDIR
fi

# copy this script in the working directory so 
# parameter settings are stored
cp $BASH_SOURCE $WORKDIR

# Start the SUPERSMART pipeline

if [ ! -e 'species.tsv']; then
    smrt taxize -r $INGROUP,$OUTGROUP -b -e Species -w $WORKDIR
fi

if [ ! -e 'aligned.txt']; then
    smrt align -w $WORKDIR
fi

if [ ! -e 'merged.txt']; then
    smrt orthologize -w $WORKDIR
fi

export SUPERSMART_BACKBONE_MAX_DISTANCE="0.1"
export SUPERSMART_BACKBONE_MIN_COVERAGE="3"
export SUPERSMART_BACKBONE_MAX_COVERAGE="5"

if [ ! -e 'supermatrix.phy']; then
    smrt bbmerge -w $WORKDIR
fi

export SUPERSMART_EXABAYES_NUMGENS="100000"
export SUPERSMART_EXABAYES_NUMRUNS="8"

if [ ! -e 'backbone.dnd']; then
    smrt bbinfer --inferencetool=exabayes -t species.tsv -o backbone.dnd -w $WORKDIR
fi

if [ ! -e 'backbone-rerooted.dnd']; then
    smrt bbreroot -g $OUTGROUP --smooth -w $WORKDIR
fi

# exit since we do not have calibration data yet
exit 0

#smrt bbcalibrate -f $FOSSILS -w $WORKDIR

#smrt consense -b 0.2 --prob -w $WORKDIR

export SUPERSMART_CLADE_MAX_DISTANCE="0.2"
export SUPERSMART_CLADE_MIN_DENSITY="0.5"

#smrt bbdecompose -w $WORKDIR

#smrt clademerge --enrich -w $WORKDIR

#smrt cladeinfer --ngens=15_000_000 --sfreq=1000 --lfreq=1000 -w $WORKDIR

#smrt cladegraft -w $WORKDIR
