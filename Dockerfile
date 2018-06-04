FROM debian:latest

MAINTAINER Andrew Wade <awade@ligo.caltech.edu>

# Set the working directory to /app
WORKDIR /builddir

# Copy the current directory contents into the container at /app
#ADD ./epics-3.14.12_long /ligo/apps/ubuntu-x86_64

ADD ./ /builddir/

#EXPOSE 8080

ENV EPICS_HOST_ARCH="linux-x86_64" \
    EPICS_ROOT="/opt/epics" \
    EPICS_BASE="/opt/epics/base" \
    EPICS_BASE_BIN="/opt/epics/base/bin/linux-x86_64" \
    EPICS_BASE_LIB="/opt/epics/base/lib/linux-x86_64"

RUN apt-get update -q \
    && apt-get --yes install \
       curl g++ make libperl-dev libreadline-dev \
       vim \
#    && wget https://www.aps.anl.gov/epics/download/modules/asyn4-32.tar.gz \
#    && wget https://epics.anl.gov/download/base/base-3.15.5.tar.gz \
#    && wget https://github.com/epics-modules/modbus/archive/R2-10-1.tar.gz \
    && mkdir /opt/epics \
    && mkdir /opt/epics/modules \
    && tar xvzf ./support/base-3.15.5.tar.gz -C /opt/epics/ \
    && tar xvzf ./support/asyn4-32.tar.gz -C /opt/epics/modules/ \
    && tar xvzf ./support/modbus-R2-10-1.tar.gz -C /opt/epics/modules/ \
    && ln -s /opt/epics/base-3.15.5 /opt/epics/base \
    && ln -s /opt/epics/modules/asyn4-32 /opt/epics/modules/asyn \
    && ln -s /opt/epics/modules/modbus-R2-10-1 /opt/epics/modules/modbus \
    && mv /builddir/config/asynRELEASE /opt/epics/modules/asyn/configure/RELEASE \
    && mv /builddir/config/modbusRELEASE /opt/epics/modules/modbus/configure/RELEASE \
    && cd /opt/epics/base \
    && make \
    && cd /opt/epics/modules/asyn \
    && make
#    && apt-get clean

RUN cd /opt/epics/modules/modbus \
    && make
  


# Editing tools for interactive mode (disable for thinner build)
#RUN apt-get --yes install \
#     vim 

# For manual build of elog
#RUN apt-get --yes install \
#    git clone https://bitbucket.org/ritt/elog --recursive && \
#    cd /builddir/elog 
#    make && \
#    make install

#CMD ["elogd", "-p", "8080", "-c", "/home/elogd.cfg"]
