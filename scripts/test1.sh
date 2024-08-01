#!/bin/bash

INSTALL_ROOT=${HOME}/software/segalign
SEGALIGN_SRC=${HOME}/SegAlign

module purge
module load gcc/10.5.0 cmake/3.29.6 cuda/12.5.0
module load zlib/1.3.1 lastz/1.04.22 boost/1.85.0 intel-tbb/2020.3
export PATH=${PATH}:${INSTALL_ROOT}/bin

mkdir -p ${SEGALIGN_SRC}/test1
cd ${SEGALIGN_SRC}/test1

if ! test -f ${SEGALIGN_SRC}/test1/ce11.2bit; then
  wget https://hgdownload.soe.ucsc.edu/goldenPath/ce11/bigZips/ce11.2bit
  twoBitToFa ce11.2bit ce11.fa
fi

if ! test -f ${SEGALIGN_SRC}/test1/cb4.2bit; then
  wget https://hgdownload-test.gi.ucsc.edu/goldenPath/cb4/bigZips/cb4.2bit
  twoBitToFa cb4.2bit cb4.fa
fi

#nvprof --profile-child-processes run_segalign ce11.fa cb4.fa --output=ce11.cb4.maf
run_segalign ce11.fa cb4.fa --output=ce11.cb4.maf
