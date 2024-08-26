#!/bin/bash

INSTALL_ROOT=${MYSCRATCH}/software/segalign
TEST_DIR=/nvme/SegAlign
SEGALIGN_SRC=${MYSCRATCH}/SegAlign

source ${MYSCRATCH}/spack/share/spack/setup-env.sh
spack env activate -d ${SEGALIGN_SRC}
module load gcc/11.2.0
module load rocm/5.7.3
module list
export PATH=${PATH}:${INSTALL_ROOT}/bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${INSTALL_ROOT}/lib

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

run_segalign ce11.fa cb4.fa --output=ce11.cb4.maf --debug
