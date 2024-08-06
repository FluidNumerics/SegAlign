#!/bin/bash

INSTALL_ROOT=${HOME}/software/segalign
TEST_DIR=/scratch/$(whoami)/SegAlign

module purge
# module load gcc/10.5.0 cmake/3.29.6 cuda/12.5.0
module load gcc/10.5.0 cmake/3.29.6 rocm/6.1.2
module load zlib/1.3.1 lastz/1.04.22 boost/1.85.0 intel-tbb/2020.3
module list
export PATH=${PATH}:${INSTALL_ROOT}/bin

mkdir ${TEST_DIR}/test2
cd ${TEST_DIR}/test2

if ! test -f ${TEST_DIR}/test2/ce11.2bit; then
  wget https://hgdownload.soe.ucsc.edu/goldenPath/ce11/bigZips/ce11.2bit
  twoBitToFa ce11.2bit ce11.fa
fi

if ! test -f ${TEST_DIR}/test2/cb4.2bit; then
  wget https://hgdownload-test.gi.ucsc.edu/goldenPath/cb4/bigZips/cb4.2bit
  twoBitToFa cb4.2bit cb4.fa
fi

#nvprof --profile-child-processes run_segalign_repeat_masker ce11.fa --output=ce11.seg
#run_segalign_repeat_masker ce11.fa --output=ce11.seg
rocprof --stats ${INSTALL_ROOT}/bin/segalign_repeat_masker ${TEST_DIR}/test2/ce11.fa
