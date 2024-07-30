#!/bin/bash

# Submit this script with: qsub thefilename
#PBS -l select=3:ncpus=48
#PBS -l walltime=24:00:00
#PBS -j oe
#PBS -N STOMP_comparison
#PBS -P geotherm
#PBS -m bea
#PBS -M precious.oyenowo@inl.gov


module load use.moose moose-dev
cd $PBS_O_WORKDIR

mpiexec ~/sawtooth/projects/alangba/alangba-opt -i ~/sawtooth/projects/alangba/STOMPcomparison/Remade_example_file.i
