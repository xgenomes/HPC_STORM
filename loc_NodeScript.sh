#!/bin/sh

#  NodeScript.sh
#  
#
#  Created by Ian Munro on 4/07/2016.
#  The script that runs on each node

echo "Start time $(date)"

PBS_ARRAY_INDEX=$(( $1 ))

echo "ncpus on node = "
echo $NCPUS


#  hardwired paths TBD
HOME=/home/imunro
IJ=/apps/fiji/Fiji.app/ImageJ-linux64

#HOME=/Users/imunro/HPC_STORM
#IJ=/Applications/Fiji.app/Contents/MacOS/ImageJ-macosx

ARGSFILE=$HOME"/args"

#  get arg  list from config file
ARGS=$(head -$PBS_ARRAY_INDEX $ARGSFILE | tail -1)

module load sysconfcpus/0.5

echo "running TSTORM macro!"
# run ThunderSTORM
sysconfcpus -n $NCPUS $IJ --ij2 -macro $HOME/TSTORM_loc_macro.ijm $ARGS


echo "End time $(date)"
