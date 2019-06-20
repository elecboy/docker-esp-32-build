#!/bin/bash

BRANCH="-b release/v3.3 "

WDIR=${HOME}/esp
mkdir -p ${WDIR} && cd ${WDIR}
IDF_PATH=${WDIR}/esp-idf

echo "Creating IDF_PATH=${IDF_PATH}"
if [ ! -d ${IDF_PATH} ]; then
  cd ${WDIR}
  git clone --recursive https://github.com/espressif/esp-idf.git ${BRANCH}
fi

RCFILE=$HOME/.bashrc
echo "Updating rc file ${RCFILE} with IDF_PATH"

set_idf_path () {
  echo "Setting IDF_PATH in ${RCFILE},"
  echo "source ${RCFILE} or "
  echo "export IDF_PATH=${IDF_PATH}"
  echo "IDF_PATH=${IDF_PATH}" >> ${RCFILE}
}

if [ -f ${RCFILE} ]; then
  grep -s IDF_PATH ${RCFILE} > /dev/null && \
    echo "Found IDF_PATH in rc file" || \
    set_idf_path
else
  echo "${RCFILE} not found. IDF_PATH not set."
fi
