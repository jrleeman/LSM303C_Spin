CON
_clkmode = xtal1 + pll16x                                                      
_xinfreq = 5_000_000

SCL = 29
SDA = 28

OBJ
  PST : "Parallax Serial Terminal"
  LSM303 : "LSM303C"

PUB go | x,y,z,xm,ym,zm,t
  PST.Start(115200)
  LSM303.start(SCL, SDA)
  PAUSE_MS(5000)
  PST.Str(String("PST Started:"))     
  PST.Str(String(13))
   
  t := LSM303.getDevIdAccelerometer
  PST.bin(t, 8)
  PST.Str(String(13))

  t := LSM303.getDevIdMagnetometer
  PST.bin(t, 8)
  PST.Str(String(13))

  LSM303.setAccDataRate(100)
  LSM303.setAccResolution(1)
  LSM303.setAccAxisEnable(1, 1, 1)
  LSM303.setAccScale(2)

  LSM303.writeReg($20, %1001_0000)
  t := LSM303.readReg($20)
  PST.bin(t, 8)
  PST.Str(String(13))

  LSM303.writeReg($21, %0110_0000)
  t := LSM303.readReg($21)
  PST.bin(t, 8)
  PST.Str(String(13))

  LSM303.writeReg($22, %0000_0000)
  t := LSM303.readReg($22)
  PST.bin(t, 8)
  PST.Str(String(13))
  

 

  'LSM303.setMagTemperatureEnable(1)
  'LSM303.setMagMode(3)
  'LSM303.setMagDataRate(10)
  'LSM303.setMagRange
  'LSM303.setMagSensorMode(1)
 ' LSM303.setMagZAxisMode(3)
  'LSM303.setMagBlockDataUpdate(0)

  
  
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
DAT {{
  LSM303.setAccDataRate(100)
  LSM303.setAccResolution(1)
  LSM303.setAccAxisEnable(1, 1, 1)
  LSM303.setAccScale(2)
  
  LSM303.setMagTemperatureEnable(1)
  LSM303.setMagMode(3)
  LSM303.setMagDataRate(10)
  LSM303.setMagRange
  LSM303.setMagSensorMode(1)
  LSM303.setMagZAxisMode(3)
  
  
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
    PAUSE_MS(200)  }}

PUB PAUSE_MS(mS)
  waitcnt(clkfreq/1000 * mS + cnt)
