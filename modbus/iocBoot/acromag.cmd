# This is a minimum working example of a .cmd file for modbus over TCP/IP
# server. This is configured for a single soft channel.  To enable an acromag
# XT1211, XT1541, 966en-4006 or XT1112, then uncomment those lines below 
# and enter correct IP addresses for those units. You will need to add entries
# into the .db files in the ../db folder yourself.


dbLoadDatabase("$(EPICS_ROOT)/modules/modbus/dbd/modbus.dbd")
modbus_registerRecordDeviceDriver(pdbbase)


#### TEST XT1211 ####
#drvAsynIPPortConfigure("xt1221test1","10.0.1.10:502",0,0,1)
#modbusInterposeConfig("xt1221test1",0,5000,0)
#drvModbusAsynConfigure("ADC_Reg_1","xt1221test1",0,4,0,8,4,32,"Acromag")

#### TEST XT1541 ####
#drvAsynIPPortConfigure("xt1541test1","10.0.1.41:502",0,0,1)
#modbusInterposeConfig("xt1541test1",0,5000,0)
#drvModbusAsynConfigure("DAC_Reg_1","xt1541test1",0,6,1,8,4,0,"Acromag")
#drvModbusAsynConfigure("BIO_Reg_1","xt1541test1",0,5,0,4,0,0,"Acromag")


#### TEST XT1112 ####
#drvAsynIPPortConfigure("xt1112test1","10.0.1.46:502",0,0,1)
#modbusInterposeConfig("xt1112test1",0,5000,0)
#drvModbusAsynConfigure("BIO_Reg_2","xt1112test1",0,6,0,4,0,0,"Acromag") 


dbLoadDatabase("/home/modbus/db/testDefault.db")

iocInit
