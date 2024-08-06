#!/bin/bash

INSTALL_ROOT=${HOME}/software/segalign
SEGALIGN_SRC=${HOME}/SegAlign
BUILD_TYPE=Release

module purge
module load gcc/10.5.0 cmake/3.29.6 rocm/6.1.2
module load zlib/1.3.1 lastz/1.04.22 boost/1.85.0 intel-tbb/2020.3
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
CXX=hipcc cmake -DCMAKE_BUILD_TYPE=Release \
      -DTBB_ROOT=${INTEL_TBB_ROOT} \
      -DBOOST_ROOT=${BOOST_ROOT} \
      -DCMAKE_HIP_ARCHITECTURES=gfx90a \
      -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
      -DCMAKE_INSTALL_PREFIX=${INSTALL_ROOT} \
      ..
make VERBOSE=1
make install
cp ${SEGALIGN_SRC}/scripts/run_segalign* ${INSTALL_ROOT}/bin/

