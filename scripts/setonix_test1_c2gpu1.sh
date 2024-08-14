#!/bin/bash
#SBATCH -N1
#SBATCH --gres=gpu:1
#SBATCH --time=30:00 
#SBATCH --partition=gpu-dev
#SBATCH --account=pawsey0007-gpu

INSTALL_ROOT=${MYSCRATCH}/software/segalign
TEST_DIR=${MYSCRATCH}/SegAlign
SEGALIGN_SRC=${MYSCRATCH}/SegAlign

source ${MYSCRATCH}/spack/share/spack/setup-env.sh
spack env activate -d ${SEGALIGN_SRC}
module load gcc/12.2.0
module load rocm/5.7.3
module list
export PATH=${PATH}:${INSTALL_ROOT}/bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${INSTALL_ROOT}/lib

mkdir -p ${TEST_DIR}/test1
rm -rf ${TEST_DIR}/test1/output
mkdir -p ${TEST_DIR}/test1/output/data
cd ${TEST_DIR}/test1

if ! test -f ${TEST_DIR}/test1/ce11.2bit; then
  wget https://hgdownload.soe.ucsc.edu/goldenPath/ce11/bigZips/ce11.2bit
  twoBitToFa ce11.2bit ce11.fa
fi

if ! test -f ${TEST_DIR}/test1/cb4.2bit; then
  wget https://hgdownload-test.gi.ucsc.edu/goldenPath/cb4/bigZips/cb4.2bit
  twoBitToFa cb4.2bit cb4.fa
fi

srun -n1 -c2 --gres=gpu:1 --gpus-per-task=1 --gpu-bind=closest segalign ${TEST_DIR}/test1/ce11.fa ${TEST_DIR}/test1/cb4.fa ${TEST_DIR}/test1/output/data/ --output=ce11.cb4.maf --debug
