#!/bin/bash
# SUPERSMART commands for inefernce of serpentes phylogeny

INGROUP=Serpentes
OUTGROUP=Basiliscus
#FOSSILS=fossils.tsv

export WORKDIR=results/`date +%Y-%m-%d`

if [ ! -d $WORKDIR ]; then
    mkdir $WORKDIR
fi

# copy this script in the working directory so 
# parameter settings are stored
cp $BASH_SOURCE $WORKDIR

# Start the SUPERSMART pipeline
smrt taxize -r $INGROUP,$OUTGROUP -b -e Species -w $WORKDIR

smrt align -w $WORKDIR

smrt orthologize -w $WORKDIR

export SUPERSMART_BACKBONE_MAX_DISTANCE="0.1"
export SUPERSMART_BACKBONE_MIN_COVERAGE="3"
export SUPERSMART_BACKBONE_MAX_COVERAGE="5"

smrt bbmerge -w $WORKDIR

export SUPERSMART_EXABAYES_NUMGENS="100000"
export SUPERSMART_EXABAYES_NUMRUNS="8"

smrt bbinfer --inferencetool=exabayes -t species.tsv -o backbone.dnd -w $WORKDIR

smrt bbreroot -g $OUTGROUP --smooth -w $WORKDIR

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
