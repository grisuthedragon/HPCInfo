#!/bin/bash -x

JNUM=8

FTP_HOST=ftp://gcc.gnu.org/pub/gcc

GMP_VERSION=4.3.2
MPFR_VERSION=2.4.2
MPC_VERSION=0.8.1
#ISL_VERSION=0.14
ISL_VERSION=0.15
CLOOG_VERSION=0.18.0
#GCC_VERSION=5.4.0
GCC_VERSION=6.3.0

CPU=native

#GCC_DIR=$HOME/Work/GCC/gcc-$GCC_VERSION
GCC_DIR=/opt/gcc/$GCC_VERSION
GCC_BUILD=/tmp/gcc-$GCC_VERSION

mkdir -p ${GCC_BUILD}


# process_lib: download, configure, build, install one of the gcc prerequisite
# libraries
# usage: process_lib <library> <version> <suffix> <path> <doodad> <configure_args>
#

process_lib() {
    cd ${GCC_BUILD}
    TOOL=$1
    TDIR=${TOOL}-${2}
    FILE=${TDIR}.tar.${3}
    INSTALLED=${GCC_DIR}/$5
    if [ -d ${TDIR} ] ; then
        echo ${TDIR} already exists! Using existing copy.
    else
        if [ -f ${FILE} ] ; then
            echo ${FILE} already exists! Using existing copy.
        else
            #wget ${FTP_HOST}/$4/${FILE}
            curl ${FTP_HOST}/$4/${FILE} -o  ${FILE}
        fi
        echo Unpacking ${FILE}
        tar -xaf ${FILE}
    fi
    if [ -f ${INSTALLED} ] ; then
        echo ${INSTALLED} already exists! Skipping build.
    else
        cd ${GCC_BUILD}/${TDIR}
        if [ -f ./contrib/download_prerequisites ] ; then
            ./contrib/download_prerequisites
        fi
        mkdir build ; cd build
        ../configure --prefix=${GCC_DIR} $6 && make -j ${MAKE_JNUM} && make install
        if [ "x$?" != "x0" ] ; then
            echo FAILURE 1
            exit
        fi
    fi
}

#process_lib gmp $GMP_VERSION bz2 infrastructure lib/libgmp.a
#process_lib mpfr $MPFR_VERSION bz2 infrastructure lib/libmpfr.a "--with-gmp=$GCC_DIR --enable-shared --enable-static"
#process_lib mpc $MPC_VERSION gz infrastructure lib/libmpc.a "--with-gmp=$GCC_DIR --enable-shared --enable-static"
#process_lib isl $ISL_VERSION bz2 infrastructure lib/libisl.a "--with-gmp-prefix=$GCC_DIR \
#--with-gcc-arch=$CPU --enable-shared --enable-static"
#process_lib cloog $CLOOG_VERSION gz infrastructure lib/libcloog-isl.a "--with-gmp-prefix=$GCC_DIR \
#--with-isl-prefix=$GCC_DIR --with-gcc-arch=$CPU --enable-shared --enable-static"

#process_lib gcc $GCC_VERSION bz2 releases/gcc-$GCC_VERSION /bin/gcc "
#  --enable-shared --enable-static \
#  --enable-threads=posix \
#  --enable-checking=release \
#  --with-system-zlib \
#  --enable-__cxa_atexit \
#  --enable-languages=c,c++,fortran \
#  --with-tune=$CPU \
#  --enable-bootstrap \
#  --enable-lto \
#  --with-gmp=$GCC_DIR \
#  --with-mpfr=$GCC_DIR \
#  --with-mpc=$GCC_DIR \
#  --with-cloog=$GCC_DIR \
#  --with-isl=$GCC_DIR --disable-isl-version-check \
#  --disable-multilib
#"

process_lib gcc $GCC_VERSION bz2 releases/gcc-$GCC_VERSION /bin/gcc "
  --enable-shared --enable-static \
  --enable-threads=posix \
  --enable-checking=release \
  --with-system-zlib \
  --enable-__cxa_atexit \
  --enable-languages=c,c++,fortran \
  --with-tune=$CPU \
  --enable-bootstrap \
  --enable-lto \
  --disable-multilib
"

