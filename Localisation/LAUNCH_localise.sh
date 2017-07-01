#!/bin/bash
#
#  Created by Ian Munro on 01/09/2016.
#

USAGE="Usage: LAUNCH_localise filename <calibration_filename>"

#1) if [[ $1 == 'general']]; then  echo $USAGE; exit 0 ;;

# fogim queue by default
FOGIM=1;

case "$#" in
1)
   if [[ $1 == "general" ]]
   then
   echo $USAGE;
   exit 0
   else
   ARGS="$WORK":"$1"
   fi
   ;;
2)
   if [[ $2 == "general" ]]
   then
   FOGIM=0
   ARGS="$WORK":"$1"
   else
   ARGS="$WORK":"$1":"$2"
   fi
   ;;
3)
   ARGS="$WORK":"$1":"$2"
   FOGIM=0
   ;;
*)
   echo $USAGE;
   exit 0
   ;;
esac

# set no of jobs
NJOBS=8;
ARGS="$ARGS":"$NJOBS"

if [[ $FOGIM -ne 1 ]]
then

one=$(qsub -v SETUP_ARGS=$ARGS $HOME/Localisation/setupScript.pbs)
echo "launching setup job"
echo $one
two=$(qsub -W depend=afterok:$one $HOME/Localisation/loc_ARRScript.pbs )
echo "launching processing job"
echo $two
three=$(qsub -W depend=afterok:$two $HOME/Localisation/loc_MERGEScript.pbs )
echo "launching merge job"
echo $three

else

echo "fogim queue"
QUEUE="pqfogim"

one=$(qsub -q $QUEUE -v SETUP_ARGS=$ARGS $HOME/Localisation/loc_ARRScript.pbs)
echo "launching processing job"
echo $one
two=$(qsub -q $QUEUE -W depend=afterok:$one -v SETUP_ARGS=$ARGS $HOME/Localisation/loc_MERGEScript.pbs )
echo "launching merge job"
echo $two
three=$(qsub -q $QUEUE -W depend=afterok:$one $HOME/Localisation/loc_TIDYScript.pbs )
echo "launching tidy job"
echo $three

fi




