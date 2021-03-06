# Automated Installation

Some people need special versions of autotools (autoconf, automake, libtool) because they work on a code that is obtained from a source repository or for whatever reason does not have configure already.

The default versions of autoconf and automake may not work for all codes, e.g. MPICH and ARMCI-MPI.  The following script solves this problem.  Please modify ``TOP`` as appropriate.

**Important:** You will need to prepend ``$HOME/TOOLS/bin`` to ``PATH`` prior to running this script for it to succeed.

```
#!/bin/bash -v

TOP=$HOME/TOOLS

MAKE_JNUM=1
M4_VERSION=1.4.17
LIBTOOL_VERSION=2.4.4
AUTOCONF_VERSION=2.69
AUTOMAKE_VERSION=1.15

cd ${TOP}
TOOL=m4
TDIR=${TOOL}-${M4_VERSION}
FILE=${TDIR}.tar.gz
BIN=${TOP}/bin/${TOOL}
if [ -f ${FILE} ] ; then
  echo ${FILE} already exists! Using existing copy.
else
  wget http://ftp.gnu.org/gnu/${TOOL}/${FILE}
fi
if [ -d ${TDIR} ] ; then
  echo ${TDIR} already exists! Using existing copy.
else
  echo Unpacking ${FILE}
  tar -xzf ${FILE}
fi
if [ -f ${BIN} ] ; then
  echo ${BIN} already exists! Skipping build.
else
  cd ${TOP}/${TDIR}                                                                                                                                                   
  ./configure --prefix=${TOP} && make -j ${MAKE_JNUM} && make install
  if [ "x$?" != "x0" ] ; then
    echo FAILURE 1
    exit
  fi
fi

cd ${TOP}
TOOL=libtool
TDIR=${TOOL}-${LIBTOOL_VERSION}
FILE=${TDIR}.tar.gz
BIN=${TOP}/bin/${TOOL}
if [ ! -f ${FILE} ] ; then
  wget http://ftp.gnu.org/gnu/${TOOL}/${FILE}
else
  echo ${FILE} already exists! Using existing copy.
fi
if [ ! -d ${TDIR} ] ; then
  echo Unpacking ${FILE}
  tar -xzf ${FILE}
else
  echo ${TDIR} already exists! Using existing copy.
fi
if [ -f ${BIN} ] ; then
  echo ${BIN} already exists! Skipping build.
else
  cd ${TOP}/${TDIR}
  ./configure --prefix=${TOP} M4=${TOP}/bin/m4 && make -j ${MAKE_JNUM} && make install
  if [ "x$?" != "x0" ] ; then
    echo FAILURE 2
    exit
  fi
fi

cd ${TOP}
TOOL=autoconf
TDIR=${TOOL}-${AUTOCONF_VERSION}
FILE=${TDIR}.tar.gz
BIN=${TOP}/bin/${TOOL}
if [ ! -f ${FILE} ] ; then
  wget http://ftp.gnu.org/gnu/${TOOL}/${FILE}
else
  echo ${FILE} already exists! Using existing copy.
fi
if [ ! -d ${TDIR} ] ; then
  echo Unpacking ${FILE}
  tar -xzf ${FILE}
else
  echo ${TDIR} already exists! Using existing copy.
fi
if [ -f ${BIN} ] ; then
  echo ${BIN} already exists! Skipping build.
else
  cd ${TOP}/${TDIR}
  ./configure --prefix=${TOP} M4=${TOP}/bin/m4 && make -j ${MAKE_JNUM} && make install
  if [ "x$?" != "x0" ] ; then
    echo FAILURE 3
    exit
  fi
fi

cd ${TOP}
TOOL=automake
TDIR=${TOOL}-${AUTOMAKE_VERSION}
FILE=${TDIR}.tar.gz
BIN=${TOP}/bin/${TOOL}
if [ ! -f ${FILE} ] ; then
  wget http://ftp.gnu.org/gnu/${TOOL}/${FILE}
else
  echo ${FILE} already exists! Using existing copy.
fi
if [ ! -d ${TDIR} ] ; then
  echo Unpacking ${FILE}
  tar -xzf ${FILE}
else
  echo ${TDIR} already exists! Using existing copy.
fi
if [ -f ${BIN} ] ; then
  echo ${BIN} already exists! Skipping build.
else
  cd ${TOP}/${TDIR}
  ./configure --prefix=${TOP} M4=${TOP}/bin/m4 && make -j ${MAKE_JNUM} && make install
  if [ "x$?" != "x0" ] ; then
    echo FAILURE 4
    exit
  fi
fi

cd ${TOP}
#rm -f autoconf-${AUTOCONF_VERSION}.tar.gz
#rm -f automake-${AUTOMAKE_VERSION}.tar.gz
#rm -f libtool-${LIBTOOL_VERSION}.tar.gz
#rm -f m4-${M4_VERSION}.tar.gz
#rm -rf autoconf-${AUTOCONF_VERSION}
#rm -rf automake-${AUTOMAKE_VERSION}
#rm -rf libtool-${LIBTOOL_VERSION}
#rm -rf m4-${M4_VERSION}
```

# Generating an Autotools Build System

* http://mij.oltrelinux.com/devel/autoconf-automake/
