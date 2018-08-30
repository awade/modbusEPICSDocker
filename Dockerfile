FROM debian:latest

MAINTAINER Andrew Wade <awade@ligo.caltech.edu>


# This docker is a ready made modbus server built on an EPICS base.
# Versions used are:
# - base-3.15.5, asyn4-32 and modbusR2-10-1
#
# This should work as a standalone instance that is OS agnostic.  See README
# for instructions on how to run.



# Set the working directory to /app
WORKDIR /builddir


# Copy the relevant directory contents into the container build dir

ADD ./config /builddir/config/
ADD ./modbus /home/modbus/

# All these ports are needed for modbus to talk to devices over modbus over TCP/IP
EXPOSE 5064
EXPOSE 5064/udp
EXPOSE 5065
EXPOSE 5065/udp

# set environment variables so epics base and modules know how to build
ENV EPICS_HOST_ARCH="linux-x86_64" \
    EPICS_ROOT="/opt/epics" \
    EPICS_BASE="/opt/epics/base" \
    EPICS_BASE_BIN="/opt/epics/base/bin/linux-x86_64" \
    EPICS_BASE_LIB="/opt/epics/base/lib/linux-x86_64" \
    PATH="/opt/epics/base/bin/linux-x86_64/:${PATH}"

# This is the main part that builds the epics base and modbus module from source
RUN apt-get update -q \
    && apt-get --yes install \
       curl g++ make libperl-dev libreadline-dev wget \
    && mkdir -p /opt/epics/modules \
    && wget https://epics.anl.gov/download/base/base-3.15.5.tar.gz \
    && wget https://www.aps.anl.gov/epics/download/modules/asyn4-32.tar.gz \
    && wget https://github.com/epics-modules/modbus/archive/R2-10-1.tar.gz -O modbus-R2-10-1.tar.gz \
    && tar xvzf base-3.15.5.tar.gz -C /opt/epics/ \
    && tar xvzf asyn4-32.tar.gz -C /opt/epics/modules/ \
    && tar xvzf modbus-R2-10-1.tar.gz -C /opt/epics/modules/ \
    && rm base-3.15.5.tar.gz asyn4-32.tar.gz modbus-R2-10-1.tar.gz \
    && ln -s /opt/epics/base-3.15.5 /opt/epics/base \
    && ln -s /opt/epics/modules/asyn4-32 /opt/epics/modules/asyn \
    && ln -s /opt/epics/modules/modbus-R2-10-1 /opt/epics/modules/modbus \
    && mv /builddir/config/RELEASE_asyn /opt/epics/modules/asyn/configure/RELEASE \
    && mv /builddir/config/RELEASE_modbus /opt/epics/modules/modbus/configure/RELEASE \
    && cd /opt/epics/base \
    && make \
    && cd /opt/epics/modules/asyn \
    && make \
    && cd /opt/epics/modules/modbus \
    && make \
    && apt-get clean

# Editing tools for interactive mode (disable for thinner build)
RUN apt-get --yes install \
     vim

ENTRYPOINT ["/opt/epics/modules/modbus/bin/linux-x86_64/modbusApp", "/home/modbus/IOCStart.cmd"]
