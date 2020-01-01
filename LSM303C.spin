{
LSM303C Accelerometer/Magnetometer Driver
J.R. Leeman
Leeman Geophysical LLC
john@leemangeophysical.com
}

CON

  ' Addresses
  ACCELEROMETER_ADDR = $1D       
  MAGNETOMETER_ADDR = $1E
  
  ' Accelerometer Registers
  WHO_AM_I_A = $0F
  ACT_THS_A = $1E
  ACT_DUR_A = $1F
  CTRL_REG1_A = $20
  CTRL_REG2_A = $21
  CTRL_REG3_A = $22
  CTRL_REG4_A = $23
  CTRL_REG5_A = $24
  CTRL_REG6_A = $25
  CTRL_REG7_A = $26
  STATUS_REG_A = $27
  OUT_X_L_A = $28
  OUT_X_H_A = $29
  OUT_Y_L_A = $2A
  OUT_Y_H_A = $2B
  OUT_Z_L_A = $2C
  OUT_Z_H_A = $2D
  FIFO_CTRL = $2E
  FIFO_SRC = $2F
  IG_CFG1_A = $30
  IG_SRC1_A = $31
  IG_THS_X1_A = $32
  IG_THS_Y1_A = $33
  IG_THS_Z1_A = $34
  IG_DUR1_A = $35
  IG_CFG2_A = $36
  IG_SRC2_A = $37
  IG_THS2_A = $38
  IG_DUR2_A = $39
  XL_REFERENCE = $3A
  XH_REFERENCE = $3B
  YL_REFERENCE = $3C
  YH_REFERENCE = $3D
  ZL_REFERENCE = $3E
  ZH_REFERENCE = $3F
  
  ' Magnetometer Registers
  WHO_AM_I_M = $0F
  CTRL_REG1_M = $20
  CTRL_REG2_M = $21
  CTRL_REG3_M = $22
  CTRL_REG4_M = $23
  CTRL_REG5_M = $24
  STATUS_REG_M = $27
  OUT_X_L_M = $28
  OUT_X_H_M = $29
  OUT_Y_L_M = $2A
  OUT_Y_H_M = $2B
  OUT_Z_L_M = $2B
  OUT_Z_H_M = $2D
  TEMP_L_M = $2E
  TEMP_H_M = $2F
  INT_CFG_M = $30
  INT_SRC_M = $31
  INT_THS_L_M = $32
  INT_THS_H_M = $33

VAR
    word started
    byte DevAdr

OBJ
  I2C  : "I2C SPIN driver v1.4od"

PUB start(data_pin, clk_pin)
  ' Start the sensor I2C bus
  I2C.init(clk_pin, data_pin)
  started ~~ 'Flag that sensor startup has been completed

CON
{Accelerometer Functionality}

PUB getDevIdAccelerometer : id
  ' Gets the device ID from the accelerometer
  ' Should be 0x41
  id := \I2C.readByte(ACCELEROMETER_ADDR, WHO_AM_I_A)


PUB setAccResolution(resolution)
  ' Sets the magnetometer resolution (1) = high, (0) = normal
  if resolution == 0
    resolution := $0
  else
    resolution := $1
  changeRegister(ACCELEROMETER_ADDR, CTRL_REG1_A, %1000_0000, resolution << 7) 
  

PUB setAccDataRate(rate)| sampleRateEnum, rate_config
  ' 0 is a power down state
  sampleRateEnum := lookdown(rate:   0, 10, 50, 100, 200, 400, 800)
  rate_config   := lookup(sampleRateEnum: $0, $1, $2, $3, $4, $5, $6)
  changeRegister(ACCELEROMETER_ADDR, CTRL_REG1_A, %0111_0000, rate_config << 4)
  
 
PUB setAccBlockDataUpdate(bdu)
  ' (0) = continuous, (1) = high resolution
  if bdu == 1
    bdu := $1
  else
    bdu := $0
  changeRegister(ACCELEROMETER_ADDR, CTRL_REG1_A, %0000_1000, bdu << 3)
  

PUB setAccAxisEnable(x_en, y_en, z_en) | config
  ' Set axes enabled in x, y, z order. (1) = enable, (0) = disable
  config := (z_en << 2) | (y_en << 1) | (x_en)
  changeRegister(ACCELEROMETER_ADDR, CTRL_REG1_A, %0000_0111, config)
  

PUB setAccAntiAliasBandwidth(bandwidth)| antiAliasEnum, antiAliasconfig
  ' 0 is a power down state
  antiAliasEnum := lookdown(bandwidth: 400, 200, 100, 50)
  antiAliasconfig   := lookup(antiAliasEnum: $0, $1, $2, $3)
  changeRegister(ACCELEROMETER_ADDR, CTRL_REG4_A, %1100_0000, antiAliasconfig << 6)
  
  
PUB setAccScale(scale) | scaleEnum, scale_config 
  ' Set accelerometer scale as +/- 2g, 4g, 8g
  scaleEnum := lookdown(scale:   2, 4, 8)
  scale_config   := lookup(scaleEnum: $0, $2, $3)
  changeRegister(ACCELEROMETER_ADDR, CTRL_REG4_A, %0011_0000, scale_config << 4)
  
  
PUB softResetAcc
  ' Soft reset accelerometer (power on reset)
  changeRegister(ACCELEROMETER_ADDR, CTRL_REG5_A, %0100_0000, $1 << 6)
  
  
PUB setAccDecimation(decimation) | decimationEnum, decimationConfig
  ' Set decimation of acceleration out OUT REG and FIFO
  decimationEnum := lookdown(decimation: 0, 2, 4, 8)
  decimationConfig := lookup(decimationEnum: $0, $1, $2, $3)
  changeRegister(ACCELEROMETER_ADDR, CTRL_REG5_A, %0011_1000, decimationConfig << 4)

PUB rebootAcc
  ' Force reboot accelerometer
  changeRegister(ACCELEROMETER_ADDR, CTRL_REG6_A, %1000_0000, $1<<7)
  
  
PUB getXAcc : xAcc
  ' Reads the x-axis acceleration. It's a 16-bit two's complement value
  ' that is then modified to return actual acceleration values
  xAcc := \I2C.readByte(ACCELEROMETER_ADDR, OUT_X_H_A) << 24
  xAcc |= \I2C.readByte(ACCELEROMETER_ADDR, OUT_X_L_A) << 16
  xAcc ~>= (16)
  ' TODO: Do calibration here
  return

PUB getYAcc : yAcc
  ' Reads the y-axis acceleration. It's a 16-bit two's complement value
  ' that is then modified to return actual acceleration values
  yAcc := \I2C.readByte(ACCELEROMETER_ADDR, OUT_Y_H_A) << 24
  yAcc |= \I2C.readByte(ACCELEROMETER_ADDR, OUT_Y_L_A) << 16
  yAcc ~>= (16)
  ' TODO: Do calibration here
  return

PUB getZAcc : zAcc
  ' Reads the z-axis acceleration. It's a 16-bit two's complement value
  ' that is then modified to return actual acceleration values
  zAcc := \I2C.readByte(ACCELEROMETER_ADDR, OUT_Z_H_A) << 24
  zAcc |= \I2C.readByte(ACCELEROMETER_ADDR, OUT_Z_L_A) << 16
  zAcc ~>= (16)
  ' TODO: Do calibration here
  return

CON
{Magnetometer Functionality}

PUB getDevIdMagnetometer : id
  ' Gets the device ID from the magnetometer
  ' Should be 0x3D
  id := \I2C.readByte(MAGNETOMETER_ADDR, WHO_AM_I_M)


PUB setMagTemperatureEnable(enable)
  ' (0) = disabled, (1) = enabled
  if enable == 1
    enable := $1
  else
    enable := $0
  changeRegister(MAGNETOMETER_ADDR, CTRL_REG1_M, %1000_0000, enable << 7)
  
  
PUB setMagMode(mode)
  ' Set magnetometer mode
  ' (0) = low power
  ' (1) = medium-performance
  ' (2) = high-performance
  ' (3) = ultra-high-performance
  ' Anything over 3 is clamped to 3
  if mode > 3
    mode := 3
  changeRegister(MAGNETOMETER_ADDR, CTRL_REG1_M, %0110_0000, mode << 5)
  
  
PUB setMagDataRate(rate) | sampleRateEnum, rateConfig
  ' Set magnetometer data rate options are 0.625, 1.25, 2.5, 5, 10, 20, 40, 80
  ' Note that the fractional rates are represented as 0, 1, 2
  sampleRateEnum := lookdown(rate:   0, 1, 2, 5, 10, 20, 40, 80)
  rateConfig   := lookup(sampleRateEnum: $0, $1, $2, $3, $4, $5, $6, $7)
  changeRegister(MAGNETOMETER_ADDR, CTRL_REG1_M, %0001_1100, rateConfig << 2 )


PUB setMagRange
  ' This magnetometer only has a +/-16 Gauss range, so set it
  changeRegister(MAGNETOMETER_ADDR, CTRL_REG2_M, %0110_0000, $3 << 5)
  
  
PUB softResetMag
  ' Soft reset magnetometer (power on reset)
  changeRegister(MAGNETOMETER_ADDR, CTRL_REG2_M, %0000_0100, $1 << 2)
  
 
PUB rebootMag
  ' Force reboot magnetometer
  changeRegister(MAGNETOMETER_ADDR, CTRL_REG2_M, %0000_1000, $1 << 3)  
  
  
PUB setMagSensorMode(mode)
  ' 0 = Continuous-conversion mode
  ' 1 = Single-conversion mode (must be used for 0.625 - 80 Hz conversion)
  ' 2 = Power-down mode
  ' 3 = Power-down mode
  ' Default is 3 (power-down)
  changeRegister(MAGNETOMETER_ADDR, CTRL_REG3_M, %0000_0011, mode)
  
  
PUB setMagZAxisMode(mode)
  ' Set magnetometer mode for the z-axis
  ' (0) = low power (default)
  ' (1) = medium-performance
  ' (2) = high-performance
  ' (3) = ultra-high-performance
  ' Anything over 3 is clamped to 3
  if mode > 3
    mode := 3
  changeRegister(MAGNETOMETER_ADDR, CTRL_REG4_M, %0000_1100, mode << 2)
  
  
PUB setMagBlockDataUpdate(bdu)
  ' (0) = continuous, (1) = wait on MSB and LSB read
  if bdu == 1
    bdu := $1
  else
    bdu := $0
  changeRegister(MAGNETOMETER_ADDR, CTRL_REG5_M, %0100_0000, bdu << 6)


PUB getTemperature : temp
  temp := \I2C.readByte(MAGNETOMETER_ADDR, TEMP_H_M) << 24
  temp |= \I2C.readByte(MAGNETOMETER_ADDR, TEMP_L_M) << 16
  temp ~>= (20)
  temp := temp * 125
  temp := temp + 25000
  ' Do calibration here          
  return

PUB getXMag : xMag
  xMag := \I2C.readByte(MAGNETOMETER_ADDR, OUT_X_H_M) << 24
  xMag |= \I2C.readByte(MAGNETOMETER_ADDR, OUT_X_L_M) << 16
  xMag ~>= (16)
  return

PUB getYMag : yMag
  yMag := \I2C.readByte(MAGNETOMETER_ADDR, OUT_Y_H_M) << 24
  yMag |= \I2C.readByte(MAGNETOMETER_ADDR, OUT_Y_L_M) << 16
  yMag ~>= (16)
  return

PUB getZMag : zMag
  zMag := \I2C.readByte(MAGNETOMETER_ADDR, OUT_Z_H_M) << 24
  zMag |= \I2C.readByte(MAGNETOMETER_ADDR, OUT_Z_L_M) << 16
  zMag ~>= (16)
  return
  
  
CON
{Common Use}
  
PUB changeRegister(addr, register, mask, value) | data
  ' Changes part of a given register with the given
  ' mask and value. Data should be same size as
  ' register.
  'data := \I2C.readWordB(ACCELEROMETER_ADDR, register)
  data := \I2C.readByte(addr, register)
  data := data & !mask
  data := data | value
 ' \I2C.writeWordB(ACCELEROMETER_ADDR, register, data)
  \I2C.writeByte(addr, register, data)
  
PUB readReg(dev_ad, adr) : t
  t := I2C.readByte(dev_ad, adr)

PUB writeReg(dev_adr, adr, data) : t
  t := I2C.writeByte(dev_adr, adr, data)
  