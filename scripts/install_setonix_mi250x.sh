#!/bin/bash

INSTALL_ROOT=${MYSCRATCH}/software/segalign
SEGALIGN_SRC=${MYSCRATCH}/SegAlign
BUILD_TYPE=Release

source ${MYSCRATCH}/spack/share/spack/setup-env.sh
spack env activate -d ${SEGALIGN_SRC}
module load gcc/11.2.0
module load cmake/3.27.7
module load rocm/5.7.3

export PATH=${PATH}:${INSTALL_ROOT}/bin

mkdir -p ${INSTALL_ROOT}/bin

# kentUtils - faToTwoBit
cd $SEGALIGN_SRC
if [ -z "$(command -v faToTwoBit)" ]; then
  wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64.v385/faToTwoBit
  chmod +x faToTwoBit
  mv faToTwoBit ${INSTALL_ROOT}/bin/
fi

# kentUtils - twoBitToFa
if [ -z "$(command -v twoBitToFa)" ]; then
  wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64.v385/twoBitToFa
  chmod +x twoBitToFa
  mv twoBitToFa ${INSTALL_ROOT}/bin/
fi

##THRUST_DEVICE_SYSTEM == THRUST_DEVICE_SYSTEM_HIP
# SegAlign 
rm -rf ${SEGALIGN_SRC}/build
mkdir -p ${SEGALIGN_SRC}/build
cd ${SEGALIGN_SRC}/build
CXX=hipcc cmake -DTBB_ROOT=${INTEL_TBB_ROOT} \
      -DBOOST_ROOT=${BOOST_ROOT} \
      -DCMAKE_HIP_ARCHITECTURES=gfx90a \
      -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
      -DCMAKE_INSTALL_PREFIX=${INSTALL_ROOT} \
      ..
make VERBOSE=1
make install
cp ${SEGALIGN_SRC}/scripts/run_segalign* ${INSTALL_ROOT}/bin/

