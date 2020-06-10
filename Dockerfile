FROM python:3

# Install build dependencies (and vim for editing)
RUN apt-get -qq update \
    && apt-get install -y build-essential wget cmake make ninja-build libncurses-dev flex bison gperf libssl-dev libffi-dev vim unzip \
    && apt-get clean \
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
RUN wget -O /esp/esp-idf.zip https://dl.espressif.com/dl/esp-idf/releases/esp-idf-v3.3.2.zip \
    && unzip /esp/esp-idf.zip -d /esp \
    && rm /esp/esp-idf.zip \  
    && mv /esp/esp-idf-v3.3.2 /esp/esp-idf
WORKDIR /esp/esp-idf
#RUN git checkout release/v3.3 \
#    && git submodule update --init --recursive \
#    && git pull --recurse-submodules

#install python module
RUN pip install -r requirements.txt

# Setup IDF_PATH	
ENV IDF_PATH /esp/esp-idf
    
# Add the toolchain binaries to PATH
ENV PATH /esp/xtensa-esp32-elf/bin:$PATH

# Add the idf tools to PATH
ENV PATH /esp/esp-idf/tools:$PATH

# This is the directory where our project will show up
WORKDIR /esp/project
