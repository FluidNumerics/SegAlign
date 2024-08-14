
#pragma once

#include <cassert>
#include <climits>
#include <cstdio>


#ifdef HIP_ENABLED

#define SHFL_UP(val, offset) __shfl_up(val, offset)

#include <hip/hip_runtime.h>

__attribute__((unused))
static void check(const hipError_t err, const char *const file, const int line)
{
  if (err == hipSuccess) return;
  fprintf(stderr,"HIP ERROR AT LINE %d OF FILE '%s': %s %s\n",line,file,hipGetErrorName(err),hipGetErrorString(err));
  fflush(stderr);
  exit(err);
}

#define WARP_SIZE 64
#define MAX_THREADS 1024 
#define BLOCK_SIZE 128
#define NUM_WARPS 2

#define cudaMalloc hipMalloc
#define cudaFree hipFree
#define cudaMemcpy hipMemcpy
#define cudaMemcpyKind hipMemcpyKind
#define cudaMemcpyHostToDevice hipMemcpyHostToDevice
#define cudaMemcpyDeviceToHost hipMemcpyDeviceToHost
#define cudaSetDevice hipSetDevice
#define cudaGetDeviceCount hipGetDeviceCount
#define cudaDeviceProp hipDeviceProp_t
#define cudaGetDeviceProperties hipGetDeviceProperties
#define cudaDeviceReset hipDeviceReset
#define cudaError_t hipError_t
#define cudaSuccess hipSuccess
#define cudaGetErrorName hipGetErrorName
#define cudaGetErrorString hipGetErrorString

#define __syncwarp __syncthreads

#else

#define SHFL_UP(val, offset) __shfl_up_sync(0xFFFFFFFF, val, offset)
#include <cuda_runtime.h>

#define hipLaunchKernelGGL(F,G,B,M,S,...) F<<<G,B,M,S>>>(__VA_ARGS__)

__attribute__((unused))
static void check(const cudaError_t err, const char *const file, const int line)
{
  if (err == cudaSuccess) return;
  fprintf(stderr,"CUDA ERROR AT LINE %d OF FILE '%s': %s %s\n",line,file,cudaGetErrorName(err),cudaGetErrorString(err));
  fflush(stderr);
  exit(err);
}
#define WARP_SIZE 32
#define MAX_THREADS 1024 
#define BLOCK_SIZE 128 
#define NUM_WARPS 4

#endif

#define CHECK(X) check(X,__FILE__,__LINE__)
