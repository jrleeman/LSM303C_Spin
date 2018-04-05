CON
_clkmode = xtal1 + pll16x                                                      
_xinfreq = 5_000_000

SCL = 24
SDA = 25

OBJ
  PST : "Parallax Serial Terminal"
  LSM303 : "LSM303C"

PUB go | x,y,z,xm,ym,zm,t
  PST.Start(115200)
  PAUSE_MS(3000)
  PST.Str(String("PST Started:"))     
  PST.Str(String(13))

  t := LSM303.getDevIdAccelerometer
  PST.bin(t, 8)
  PST.Str(String(13))
  t := LSM303.getDevIdMagnetometer
  PST.bin(t, 8)
  PST.Str(String(13))

  LSM303.start(SCL, SDA)
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
    'PST.char(9)
    't := LSM303.readReg($32)
    'PST.hex(t, 2)
     'PST.char(9)
    PST.char(13)
    PAUSE_MS(200)

PUB PAUSE_MS(mS)
  waitcnt(clkfreq/1000 * mS + cnt)

DAT                     
{{
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                   TERMS OF USE: MIT License                                                  │                                                            
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation    │ 
│files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,    │
│modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software│
│is furnished to do so, subject to the following conditions:                                                                   │
│                                                                                                                              │
│The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.│
│                                                                                                                              │
│THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE          │
│WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR         │
│COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,   │
│ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                         │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
}} 