FROM ubuntu:16.04

# Install build dependencies (and vim for editing)
RUN apt-get -qq update \
    && apt-get install -y git build-essential wget cmake make ninja libncurses-dev flex bison gperf python python-serial python-dev python-pip libssl-dev libffi-dev vim unzip \
    && apt-get clean \
	&& pip install --upgrade setuptools\
	&& pip install --upgrade future \
	&& pip install --upgrade cryptography \
	&& pip install --upgrade esptool \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create some directories
RUN mkdir -p /esp
#RUN mkdir /esp/esp-idf
RUN mkdir /esp/project

# Get the ESP32 toolchain and extract it to /esp/xtensa-esp32-elf
RUN wget -O /esp/esp-32-toolchain.tar.gz https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz \
    && tar -xzf /esp/esp-32-toolchain.tar.gz -C /esp \
    && rm /esp/esp-32-toolchain.tar.gz
   
# Install ESP-IDF
WORKDIR /esp
#RUN git clone --branch release/v3.3 --recurse-submodules https://github.com/espressif/esp-idf.git
RUN wget -O /esp/esp-idf.zip https://dl.espressif.com/dl/esp-idf/releases/esp-idf-v3.3-beta3.zip \
    && unzip /esp/esp-idf.zip -d /esp \
    && mv /esp/esp-idf-v3.3-beta3 /esp/esp-idf
WORKDIR /esp/esp-idf
RUN git checkout release/v3.3 \
    && git submodule update --recursive \
    && git pull --recurse-submodules

# Setup IDF_PATH	
ENV IDF_PATH /esp/esp-idf
    
# Add the toolchain binaries to PATH
ENV PATH /esp/xtensa-esp32-elf/bin:$PATH

# This is the directory where our project will show up
WORKDIR /esp/project
