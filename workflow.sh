#!/bin/bash
# SUPERSMART commands for inefernce of serpentes phylogeny

INGROUP=Serpentes
OUTGROUP=Basiliscus
#FOSSILS=fossils.tsv

smrt taxize -r $INGROUP,$OUTGROUP -b -e Species

smrt align

smrt orthologize

export SUPERSMART_BACKBONE_MAX_DISTANCE="0.1"
export SUPERSMART_BACKBONE_MIN_COVERAGE="3"
export SUPERSMART_BACKBONE_MAX_COVERAGE="5"

smrt bbmerge

export SUPERSMART_EXABAYES_NUMGENS="100000"
export SUPERSMART_EXABAYES_NUMRUNS="8"

smrt bbinfer --inferencetool=exabayes -t species.tsv -o backbone-exabayes.dnd

smrt bbreroot -g $OUTGROUP --smooth 

# exit since we do not have calibration data yet
exit 0

#smrt bbcalibrate -f $FOSSILS

#smrt consense -b 0.2 --prob

export SUPERSMART_CLADE_MAX_DISTANCE="0.2"
export SUPERSMART_CLADE_MIN_DENSITY="0.5"

#smrt bbdecompose

#smrt clademerge --enrich

#smrt cladeinfer --ngens=15_000_000 --sfreq=1000 --lfreq=1000

#smrt cladegraft
