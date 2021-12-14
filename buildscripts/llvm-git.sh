#!/bin/bash -xe

if [ `uname -s` == Darwin ] ; then
    MAKE_JNUM="-j`sysctl -n hw.ncpu`"
else
    MAKE_JNUM="-j`nproc`"
fi

if [ `uname -m` == arm64 ] || [ `uname -m` == aarch64 ] ; then
    MYARCH=AArch64
else
    MYARCH=X86
fi

CC=gcc-11
CXX=g++-11

LLVM_HOME=/opt/llvm
mkdir -p $LLVM_HOME

LLVM_TEMP=/tmp/llvm-build

# Download/update the source
cd $LLVM_HOME
if [ -d $LLVM_HOME/git ] ; then
  cd $LLVM_HOME/git
  git pull
  git submodule update --init --recursive
else
  git clone --recursive https://github.com/llvm/llvm-project.git git
fi

if [ `which ninja` ] ; then
    BUILDTOOL="Ninja"
else
    BUILDTOOL="Unix Makefiles"
fi

rm -rf $LLVM_TEMP
mkdir -p $LLVM_TEMP
cd $LLVM_TEMP

# lldb busted on MacOS
# libcxx requires libcxxabi
cmake \
      -G $BUILDTOOL \
      -DCMAKE_BUILD_TYPE=Release \
      -DLLVM_PARALLEL_LINK_JOBS=1 \
      -DLLVM_TARGETS_TO_BUILD=$MYARCH \
      -DLLVM_ENABLE_RUNTIMES="libcxxabi;libcxx" \
      -DLLVM_ENABLE_PROJECTS="lld;mlir;clang;flang;openmp;pstl;polly" \
      -DPYTHON_EXECUTABLE=`which python` \
      -DCMAKE_C_COMPILER=$CC \
      -DCMAKE_CXX_COMPILER=$CXX \
      -DLLVM_USE_LINKER=gold \
      $LLVM_HOME/git/llvm

#make $MAKE_JNUM
cmake --build . 

