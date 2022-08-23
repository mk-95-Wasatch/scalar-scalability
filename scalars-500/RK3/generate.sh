#!/bin/bash

#-------------------------------------------------------------------

function modify_ups() {
  ups=$1
  output_time=$2
  max_time=$3
  resolution=$4
  patches=$5
  timesteps=$6
  integ=$7
  uda="scalars-500.uda"
  perl -pi -w -e "s/<<output_time>>/$output_time/" $INPUT_DIR/$ups
  perl -pi -w -e "s/<<max_time>>/$max_time/" $INPUT_DIR/$ups
  perl -pi -w -e "s/<<resolution>>/$resolution/" $INPUT_DIR/$ups
  perl -pi -w -e "s/<<patches>>/$patches/" $INPUT_DIR/$ups
  perl -pi -w -e "s/<<timesteps>>/$timesteps/" $INPUT_DIR/$ups
  perl -pi -w -e "s/<<integ>>/$integ/" $INPUT_DIR/$ups
  perl -pi -w -e "s/<<uda>>/$uda/" $INPUT_DIR/$ups
}
#-------------------------------------------------------------------
PROJECT="Scalars"
SUS="sus"
OUTPUT_DIR="outputs"
INPUT_DIR="inputs"

# CORES="16 32 64 128 256 512 1024 2048 4096"
CORES="16 32 64 128 256 512 1024"
# CORES="16"

# MEMORY=":mem=110GB"      # use 128GB nodes

JOB="RK3"
THREADS="1"

#__________________________________
# common to all input files
max_time="10" # 10 seconds
output_time="0.005" # results 20 frame per second
timesteps="10"

NAME="RK3SSP"

#__________________________________
# 16 cores
ups="16.ups"
patches="[4,2,2]"
resolution="[128,64,64]"
cp ../scalars.ups $INPUT_DIR/$ups
modify_ups $ups $output_time $max_time $resolution $patches $timesteps $NAME

#__________________________________
# 32 cores
ups="32.ups"
patches="[4,4,2]"
resolution="[128,128,64]"
cp ../scalars.ups $INPUT_DIR/$ups
modify_ups $ups $output_time $max_time $resolution $patches $timesteps $NAME

#__________________________________
# 64 cores
ups="64.ups"
patches="[4,4,4]"
resolution="[128,128,128]"
cp ../scalars.ups $INPUT_DIR/$ups
modify_ups $ups $output_time $max_time $resolution $patches $timesteps $NAME

#__________________________________
# 128 cores
ups="128.ups"
patches="[8,4,4]"
resolution="[256,128,128]"
cp ../scalars.ups $INPUT_DIR/$ups
modify_ups $ups $output_time $max_time $resolution $patches $timesteps $NAME


#__________________________________
# 256 cores
ups="256.ups"
patches="[8,8,4]"
resolution="[256,256,128]"
cp ../scalars.ups $INPUT_DIR/$ups
modify_ups $ups $output_time $max_time $resolution $patches $timesteps $NAME

#__________________________________
# 512 cores
ups="512.ups"
patches="[8,8,8]"
resolution="[256,256,256]"
cp ../scalars.ups $INPUT_DIR/$ups
modify_ups $ups $output_time $max_time $resolution $patches $timesteps $NAME

#__________________________________
# 1024 cores
ups="1024.ups"
patches="[16,8,8]"
resolution="[512,256,256]"
cp ../scalars.ups $INPUT_DIR/$ups
modify_ups $ups $output_time $max_time $resolution $patches $timesteps $NAME

#__________________________________
# 2048 cores
ups="2048.ups"
patches="[16,16,8]"
resolution="[512,512,256]"
cp ../scalars.ups $INPUT_DIR/$ups
modify_ups $ups $output_time $max_time $resolution $patches $timesteps $NAME

#__________________________________
# 4096 cores
ups="4096.ups"
patches="[16,16,16]"
resolution="[512,512,512]"
cp ../scalars.ups $INPUT_DIR/$ups
modify_ups $ups $output_time $max_time $resolution $patches $timesteps $NAME


for cores in $CORES; do
    
    size=`expr $cores \* 1` # if using nodes instead of CORES #36 is the number of cores per node` 
    ups=$cores.ups
    
    # if [ $cores -lt 128 ]; then
    #   TIME=00:30:00
    # elif [ $cores -lt 256 ]; then
    #   TIME=00:20:00
    # elif [ $cores -lt 512 ]; then
    #   TIME=00:15:00
    # else
    #   TIME=00:30:00
    # fi

    TIME=00:30:00

    if [ $THREADS -eq 1 ]; then
      procs=$size
      threads=1
    else
      procs=$cores
      threads=$THREADS
    fi 

    export JOB
    export NAME
    export ups
    export size
    export procs
    export threads
    export nodes
    export SUS
    export OUTPUT_DIR
    export INPUT_DIR
    export TIME
    
    # echo "$JOB.$size ../runsus.sh"
    # ../runsus.sh" # uncomment if you want to test locally
    sbatch -t $TIME --ntasks=$procs --job-name=$JOB.$size ../runsus.sh
    # ../runsus.sh
    
done
