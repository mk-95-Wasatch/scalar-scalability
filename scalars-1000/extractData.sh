#!/bin/bash

here=$PWD
cases="$(find ${here} -name "outputs")"

solverDataPaths="solverData"
scalingDataPaths="scalingData"
scalingMPIStatsPaths="mpiTimes"
aveComponentTimesPaths="aveComponentTimes"

for case in $cases;
do 
    echo "working on ${case}"
    cd $case
    # run the extraction scripts
    ./extractSolverScalingData *.out
    ./extractScalingData *.out
    ./extractMPIStats *.out

    solverDataPaths+=("${case}/solverScalingData")
    scalingDataPaths+=("${case}/scalingData")
    scalingMPIStatsPaths+=("${case}/mpiTimes")
    aveComponentTimesPaths+=("${case}/aveComponentTimes")
done
cd $here

echo "${solverDataPaths[*]}" > $here/dataPaths 
echo "${scalingDataPaths[*]}">> $here/dataPaths 
echo "${scalingMPIStatsPaths[*]}">> $here/dataPaths
echo "${aveComponentTimesPaths[*]}">> $here/dataPaths

python $here/dataFrameGen.py