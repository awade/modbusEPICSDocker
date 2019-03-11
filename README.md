# modbusEPICSDocker
Docker image for hosting a modbus over TCP/IP EPICS server.

To run, first build:
```bash
sudo docker build -t ioctest .
```

Then initiate and instants with the docker run command:
```bash
sudo docker run  --name=testiocContainer -dt -p 5064:5064 -p 5065:5065 -p 5064:5064/udp -p 5065:5065/udp ioctest
```

Here four ports are exposed, these are needed to receive queries from clients looking for channels.  

A test channel, C3:EXP-modbusDocker, will be broadcast.  You can check its reaching your network by running the following on another computer with EPICS tools installed:
```bash
caget C3:EXP-modbusDocker
```

For now the docker looks for an iocBoot file at the location /home/modbus/iocBoot/acromag.cmd . Database files (.db files) can be mounted anywhere that doesn't overwrite system or EPICS base/modbus files.  It is recommended to mount all .db files in /home/modbus/db.  A typical docker run command would look like:

```bash
sudo docker run -dt -v /path/to/acromag.cmd:/opt/epics/modules/modbus/iocBoot/iocTest/acromag.cmd -v path/to/databasefiles/db:/home/modbus/db  -p 5064:5064 -p 5065:5065 -p 5064:5064/udp -p 5065:5065/udp ioctest /bin/bash
```

For launching into an interactive shell for debugging run

```bash
sudo docker run -it -v /path/to/acromag.cmd:/opt/epics/modules/modbus/iocBoot/iocTest/acromag.cmd -v path/to/databasefiles/db:/home/modbus/db  -p 5064:5064 -p 5065:5065 -p 5064:5064/udp -p 5065:5065/udp ioctest /bin/bash
```

---

Note: that the system architecture is hard coded to linux-x86_64 in at least two places in this Dockerfile.  If you are seeking to run this docker on an ARM (raspberry pi, etc) then you will need to probably change these to the relevant value for your system.
