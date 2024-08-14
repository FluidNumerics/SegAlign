#!/bin/bash

INSTALL_ROOT=${MYSCRATCH}/software/segalign
TEST_DIR=${MYSCRATCH}/SegAlign
SEGALIGN_SRC=${MYSCRATCH}/SegAlign

source ${MYSCRATCH}/spack/share/spack/setup-env.sh
spack env activate -d ${SEGALIGN_SRC}
module load gcc/12.2.0
module load rocm/5.6.1
#module load rocm/5.7.3
module list
export PATH=${PATH}:${INSTALL_ROOT}/bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${INSTALL_ROOT}/lib

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
run_segalign_repeat_masker ce11.fa --output=ce11.seg
#rocprof --stats ${INSTALL_ROOT}/bin/segalign_repeat_masker ${TEST_DIR}/test2/ce11.fa
