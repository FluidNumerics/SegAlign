#!/bin/bash

INSTALL_ROOT=${HOME}/software/segalign
TEST_DIR=/scratch/$(whoami)/SegAlign

module purge
# module load gcc/10.5.0 cmake/3.29.6 cuda/12.5.0
module load gcc/10.5.0 cmake/3.29.6 rocm/6.1.2
module load zlib/1.3.1 lastz/1.04.22 boost/1.85.0 intel-tbb/2020.3
module list
export PATH=${PATH}:${INSTALL_ROOT}/bin

mkdir -p ${TEST_DIR}/test1
cd ${TEST_DIR}/test1

if ! test -f ${TEST_DIR}/test1/ce11.2bit; then
  wget https://hgdownload.soe.ucsc.edu/goldenPath/ce11/bigZips/ce11.2bit
  twoBitToFa ce11.2bit ce11.fa
fi

if ! test -f ${TEST_DIR}/test1/cb4.2bit; then
  wget https://hgdownload-test.gi.ucsc.edu/goldenPath/cb4/bigZips/cb4.2bit
  twoBitToFa cb4.2bit cb4.fa
fi

#nvprof --profile-child-processes run_segalign ce11.fa cb4.fa --output=ce11.cb4.maf
#rocprof --stats ${INSTALL_ROOT}/bin/segalign ${TEST_DIR}/test1/ce11.fa ${TEST_DIR}/test1/cb4.fa ${TEST_DIR}/test1/output_23786/data_23032/  --output=ce11.cb4.maf
run_segalign ce11.fa cb4.fa --output=ce11.cb4.maf
