CON
_clkmode = xtal1 + pll16x                                                      
_xinfreq = 5_000_000

SCL = 28
SDA = 29

OBJ
  PST : "Parallax Serial Terminal"
  LSM303 : "LSM303C"

PUB go | x,y,z,xm,ym,zm,t, reg
  PST.Start(115200)
  LSM303.start(SDA, SCL)
  PAUSE_MS(5000)
  PST.Str(String("PST Started:"))     
  PST.Str(String(13))
  
  t := LSM303.getDevIdAccelerometer
  PST.Str(String("Accelerometer ID: "))
  PST.bin(t, 8)
  PST.Str(String(13))

  t := LSM303.getDevIdMagnetometer
  PST.Str(String("Magnetometer ID: "))
  PST.bin(t, 8)
  PST.Str(String(13))

  LSM303.setAccResolution(1)
  LSM303.setAccDataRate(100)
  LSM303.setAccBlockDataUpdate(0)
  LSM303.setAccResolution(1)
  LSM303.setAccAxisEnable(1, 1, 1)
  LSM303.setAccScale(2)

  LSM303.setMagTemperatureEnable(1)
  LSM303.setMagMode(3)
  LSM303.setMagDataRate(10)
  LSM303.setMagRange
  LSM303.setMagSensorMode(0)
  LSM303.setMagZAxisMode(3)
  LSM303.setMagBlockDataUpdate(0)

  reg := LSM303.readReg($1D, $20)
  PST.str(string("Acc Ctrl Reg 1: "))
  PST.bin(reg, 8)
  PST.Str(String(13))
  reg := LSM303.readReg($1D, $21)
  PST.str(string("Acc Ctrl Reg 2: "))
  PST.bin(reg, 8)
  PST.Str(String(13))
  reg := LSM303.readReg($1D, $22)
  PST.str(string("Acc Ctrl Reg 3: "))
  PST.bin(reg, 8)
  PST.Str(String(13))
  reg := LSM303.readReg($1D, $23)
  PST.str(string("Acc Ctrl Reg 4: "))
  PST.bin(reg, 8)
  PST.Str(String(13))
  reg := LSM303.readReg($1D, $24)
  PST.str(string("Acc Ctrl Reg 5: "))
  PST.bin(reg, 8)
  PST.Str(String(13))
  reg := LSM303.readReg($1D, $25)
  PST.str(string("Acc Ctrl Reg 6: "))
  PST.bin(reg, 8)
  PST.Str(String(13))
  reg := LSM303.readReg($1D, $26)
  PST.str(string("Acc Ctrl Reg 7: "))
  PST.bin(reg, 8)
  PST.Str(String(13))

  reg := LSM303.readReg($1E, $20)
  PST.str(string("Mag Ctrl Reg 1: "))
  PST.bin(reg, 8)
  PST.Str(String(13))
  reg := LSM303.readReg($1E, $21)
  PST.str(string("Mag Ctrl Reg 2: "))
  PST.bin(reg, 8)
  PST.Str(String(13))
  reg := LSM303.readReg($1E, $22)
  PST.str(string("Mag Ctrl Reg 3: "))
  PST.bin(reg, 8)
  PST.Str(String(13))
  reg := LSM303.readReg($1E, $23)
  PST.str(string("Mag Ctrl Reg 4: "))
  PST.bin(reg, 8)
  PST.Str(String(13))
  reg := LSM303.readReg($1E, $24)
  PST.str(string("Mag Ctrl Reg 5: "))
  PST.bin(reg, 8)
  PST.Str(String(13))

  PST.Str(String("X Acc"))
  PST.char(9)
  PST.Str(String("Y Acc"))
  PST.char(9)
  PST.Str(String("Z Acc"))
  PST.char(9)
  PST.Str(String("X Mag"))
  PST.char(9)
  PST.Str(String("Y Mag"))
  PST.char(9)
  PST.Str(String("Z Mag"))
  PST.char(9)
  PST.Str(String("Temp"))
  PST.char(9)
  PST.char(13)
  
  repeat 
    x := LSM303.getXAcc
    y := LSM303.getYAcc
    z := LSM303.getZAcc
    xm := LSM303.getXMag
    ym := LSM303.getYMag
    zm := LSM303.getZMag
    t := LSM303.getTemperature
    PST.dec(x)
    PST.char(9)
    PST.dec(y)
    PST.char(9)
    PST.dec(z)
    PST.char(9)
    PST.dec(xm)
    PST.char(9)
    PST.dec(ym)
    PST.char(9)
    PST.dec(zm)
    PST.char(9)
    PST.dec(t)
    PST.char(13)
    PAUSE_MS(200)

PUB PAUSE_MS(mS)
  waitcnt(clkfreq/1000 * mS + cnt)