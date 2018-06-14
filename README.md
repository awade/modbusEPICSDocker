# modbusEPICSDocker
Docker image for hosting a modbus over TCP/IP EPICS server.

To run, first build:
> docker build -t ioctest .

Then initiate and instants with the docker run command:
> docker run  --name=testiocContainer -dt -p 5064:5064 -p 5065:5065 -p 5064:5064/udp -p 5065:5065/udp ioctest

Here four ports are exposed, these are needed to receive queries from clients looking for channels.  

A test channel, C3:PSL-modbusDocker, will be broadcast.  You can check its reaching your network by running the following on another computer with EPICS tools installed:
> caget C3:PSL-modbusDocker



Note that the system architecture is hard coded to linux-x86_64 in at least two places in this Dockerfile.  If you are seeking to run this docker on an ARM (raspberry pi, etc) then you will need to probably change these to the relevant value for your system.
