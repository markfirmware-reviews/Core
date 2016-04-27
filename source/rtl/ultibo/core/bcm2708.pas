{
Ultibo BCM2708 interface unit.

Copyright (C) 2015 - SoftOz Pty Ltd.

Arch
====

 <All>

Boards
======

 Raspberry Pi - Model A/B/A+/B+
 Raspberry Pi - Model Zero

Licence
=======

 LGPLv2.1 with static linking exception (See COPYING.modifiedLGPL.txt)
 
Credits
=======

 Information for this unit was obtained from:

   Linux - MMC/SDHCI drivers
   U-Boot - MMC/SDHCI drivers
 
   Linux - \drivers\video\bcm2708_fb.c
   U-Boot - \drivers\video\bcm2835.c 
   
   Linux - \drivers\dma\bcm2708-dmaengine.c - Copyright 2013-2014 Florian Meier and Gellert Weisz
   Linux - \drivers\dma\bcm2835-dma.c - Copyright 2013 Florian Meier
   
References
==========

 BCM2835 ARM Peripherals
 
 Raspberry Pi Mailboxes
 
  https://github.com/raspberrypi/firmware/wiki/Mailboxes
 
 RPi Low-level peripherals
  
  http://elinux.org/RPi_Low-level_peripherals
  
 RPi SPI
 
  http://elinux.org/RPi_SPI
 
BCM2708 Devices
===============

 This unit provides the BCM2708 specific implementations of the following devices:

  SPI
  I2C
  DMA
  PWM
  PCM
  GPIO
  UART
  SDHCI (eMMC)
 
  Clock
  Timer
  Random
  Mailbox
  Watchdog
  Framebuffer
  
  And MIPI CSI-2 (Camera Serial Interface) ?
  And DSI (Display Serial Interface) ?
 
 
BCM2708 SPI Device
==================


BCM2708 I2C Device
==================

 
BCM2708 DMA Device
==================

 The DMA controller has 16 channels in total although not all are available for software to use as some are already used by the GPU.
 
 The firmware will pass the value dma.dmachans on the command line which will indicate which channels are available for our use.
 
 Channels 0 to 6 are normal channels which support 2D stride and transfers up to 1GB per control block
 
 Channels 7 to 14 are Lite channels which do not support stride and only allow transfers up to 64KB per control block

 Channel 15 is not mentioned in most documentation and is shown as not available in the mask passed in dma.dmachans
 
 Channel 0 and 15 are Bulk channels which have an additional FIFO for faster transfers (8 beat burst per read)

 
BCM2708 PWM Device
==================


BCM2708 PCM Device
==================

 
BCM2708 GPIO Device
===================

BCM2708 UART Device
===================

BCM2708 SDHCI Device
====================

 The SDHCI controller on the BCM2708 is an Arasan SD Host controller.

 The Card Detect pin is connected to GPIO pin 47 (on the RPi Model A/B)(Not connected on the RPi Model A+/B+)

 The Write Protect pin is not connected on any RPi model.


BCM2708 Clock Device
====================


BCM2708 Timer Device
====================


BCM2708 Random Device
=====================


BCM2708 Mailbox Device
======================


BCM2708 Watchdog Device
=======================


BCM2708 Framebuffer Device
==========================
 
 
}

{$mode delphi} {Default to Delphi compatible syntax}
{$H+}          {Default to AnsiString}
{$inline on}   {Allow use of Inline procedures}

unit BCM2708;
                   
//To Do

 //See Also: \u-boot-HEAD-5745f8c\board\raspberrypi\rpi\rpi.c
 //board_mmc_init 
 //   Power on SDHCI
 //   Get EMMC Clock Rate
 
 //For SDHCI Host Linux driver see: \linux-rpi-3.12.y\drivers\mmc\host\bcm2835-mmc.c
 //                                 \linux-rpi-3.12.y\drivers\mmc\host\sdhci-bcm2708.c
 //                                 \linux-rpi-3.18.y\drivers\mmc\host\bcm2835-mmc.c   <- This one appears to be the latest 
 //                                 \linux-rpi-3.18.y\drivers\mmc\host\sdhci-bcm2835.c
 //                                 \linux-rpi-3.18.y\drivers\mmc\host\sdhci.c         <- This one for the more universal stuff
  
 //For SPI Host Linux driver see: \linux-rpi-3.12.y\drivers\spi\spi-bcm2835.c
 //                               \linux-rpi-3.12.y\drivers\spi\spi-bcm2708.c
 
 //For PCM Host Linux driver see: 
 
 //For PWM Host Linux driver see: \linux-rpi-3.12.y\drivers\pwm
 
 //For I2C Host Linux driver see: \linux-rpi-3.12.y\drivers\i2c\busses\i2c-bcm2708.c
 //                               \linux-rpi-3.12.y\drivers\i2c\busses\i2c-bcm2835.c
                                  
 //For GPIO Host U-Boot driver see: \u-boot-HEAD-5745f8c\drivers\gpio\bcm2835_gpio.c
 //For GPIO Host Linux driver see:  \linux-rpi-3.12.y\drivers\pinctrl\pinctrl-bcm2835.c
                        //See Also: \u-boot-master\drivers\gpio\bcm2835_gpio.c
          
 //For Framebuffer Host Linux driver see: \linux-rpi-3.12.y\drivers\video\bcm2708_fb.c
 //For Framebuffer Host U-Boot driver see: \u-boot-HEAD-5745f8c\drivers\video\bcm2835.c
 
 //For Watchdog Host Linux driver see: \linux-rpi-3.12.y\drivers\watchdog\bcm2708_wdog.c
 //                                    \linux-rpi-3.12.y\drivers\watchdog\bcm2835_wdt.c
 
 //Watchdog See Also:                  \linux-rpi-3.12.y\arch\arm\mach-bcm2835\bcm2835.c
 //                                    \u-boot-master\arch\arm\include\asm\arch-bcm2835\wdog.h
 //                                    \u-boot-master\arch\arm\cpu\arm1176\bcm2835\reset.c
 
               //bcm2835_restart  see: \linux-rpi-3.12.y\arch\arm\mach-bcm2835\bcm2835.c
               //bcm2835_power_off
 
 //Other useful references:
 
 //Clock:    \linux-rpi-3.12.y\drivers\clk\clk-bcm2835.c
 //
 //Random:   \linux-rpi-3.12.y\drivers\char\hw_random\bcm2835-rng.c
 //          \linux-rpi-3.12.y\drivers\char\hw_random\bcm2835-rng.c
 //
 //Hardware Monitor:  \linux-rpi-3.12.y\drivers\hwmon\bcm2835-hwmon.c (Temp/Max Temp)
 //
 //IRQ:      \linux-rpi-3.12.y\drivers\irqchip\irq-bcm2835.c
 //
 //DVB:      \linux-rpi-3.12.y\drivers\media\dvb-core
 //          \linux-rpi-3.12.y\drivers\media\dvb-frontends
 //
 //DAB:      \linux-rpi-3.12.y\drivers\media\tuners
 //
 //VC4:      \linux-rpi-3.12.y\drivers\misc\vc04_services
 //
 //Camera:   \linux-rpi-3.12.y\drivers\media\platform\bcm2835
 //
 //Thermal:   \linux-rpi-3.12.y\drivers\thermal\bcm2835-thermal.c (Temp/Max Temp)
 //
 //Timer:     \linux-rpi-3.18.y\drivers\clocksource\bcm2835_timer.c
 
 //           \linux-rpi-3.18.y\arch\arm\mach-bcm2708
 //           \linux-rpi-3.18.y\arch\arm\mach-bcm2709
 
 
interface

uses GlobalConfig,GlobalConst,GlobalTypes,BCM2835,Platform{$IFNDEF CONSOLE_EARLY_INIT},PlatformRPi{$ENDIF},Threads,HeapManager,Devices,SPI,I2C,DMA,PWM,GPIO,UART,MMC,Framebuffer,SysUtils; 

{==============================================================================}
{Global definitions}
{$INCLUDE GlobalDefines.inc}

{==============================================================================}
const
 {BCM2708 specific constants}
 
 {BCM2708 SPI constants}
 
 {BCM2708 I2C constants}
 
 {BCM2708 DMA constants}
 BCM2708_DMA_CHANNEL_COUNT = 16;                 {Total number of DMA channels (Not all are usable)}
 
 BCM2708_DMA_LITE_CHANNELS   = $7F80;            {Mask of DMA Lite channels (7 to 14)}
 BCM2708_DMA_NORMAL_CHANNELS = $007E; {807F}     {Mask of normal channels (1 to 6)}
 BCM2708_DMA_BULK_CHANNELS   = $8001;            {Mask of DMA Bulk channels (0 and 15)}
 
 BCM2708_DMA_SHARED_CHANNELS = $7800;            {Mask of channels with shared interrupt (11 to 14)}
 
 BCM2708_DMA_MAX_LITE_TRANSFER   = 65536;        {Maximum transfer length for a DMA Lite channel}
 BCM2708_DMA_MAX_NORMAL_TRANSFER = 1073741824;   {Maximum transfer length for a normal channel}
 
 BCM2708_DMA_MAX_STRIDE   = $FFFF;               {Maximum stride value (Increment between rows) (Note this is a signed value (Min -32768 / Max 32767)}
 BCM2708_DMA_MAX_Y_COUNT  = $3FFF;               {Maximum number of X length transfers in 2D stride}
 BCM2708_DMA_MAX_X_LENGTH = $FFFF;               {Maximum X transfer length in 2D stride}
 
 BCM2708_DMA_CB_ALIGNMENT = 32;                  {Alignement required for DMA control blocks}
 
 BCM2708_DMA_LITE_BURST_LENGTH = 1;              {Burst length for DMA Lite channels}
 BCM2708_DMA_NORMAL_BURST_LENGTH = 2;            {Burst length for normal channels}
 BCM2708_DMA_BULK_BURST_LENGTH = 8;              {Burst length for DMA Bulk channels}
 
 {BCM2708 PWM constants}
 
 {BCM2708 PCM constants}
 
 {BCM2708 GPIO constants}
 
 {BCM2708 UART constants}
 
 {BCM2708 SDHCI constants}
 BCM2708_EMMC_MIN_FREQ = 400000;    {Default minimum of 400KHz}
 BCM2708_EMMC_MAX_FREQ = 250000000; //To Do //Get the current frequency from the command line or mailbox instead ? //Peripheral init could get from Mailbox like SMSC95XX ?
 
 {BCM2708 Clock constants}
 
 {BCM2708 Timer constants}
 
 {BCM2708 Random constants}
 BCM2708_RANDOM_WARMUP_COUNT  = $00040000; {The initial numbers generated are "less random" so will be discarded}

 {BCM2708 Mailbox constants}
 
 {BCM2708 Watchdog constants}
 
 {BCM2708 Framebuffer constants}
 
{==============================================================================}
type
 {BCM2708 specific types}
 
 {BCM2708 SPI types}
 
 {BCM2708 I2C types}
 
 {BCM2708 DMA types}
 PBCM2708DMAHost = ^TBCM2708DMAHost;
 
 PBCM2708DMAChannel = ^TBCM2708DMAChannel;
 TBCM2708DMAChannel = record
  Host:PBCM2708DMAHost;            {DMA host this channel belongs to}
  Request:PDMARequest;             {Current DMA request pending on this channel (or nil of no request is pending)} 
  Number:LongWord;                 {The channel number of this channel}
  Interrupt:LongWord;              {The interrupt number of this channel}
  Registers:PBCM2835DMARegisters;  {The channel registers for configuration}
 end;
 
 TBCM2708DMAHost = record
  {DMA Properties}
  DMA:TDMAHost;
  {BCM2708 Properties}
  ChannelMask:LongWord;                                                   {Mask of available channels (Passed from GPU firmware)}
  ChannelFree:LongWord;                                                   {Bitmap of current free channels}
  ChannelLock:TMutexHandle;                                               {Lock for access to ChannelFree}
  ChannelWait:TSemaphoreHandle;                                           {Number of free normal channels in ChannelFree}
  ChannelLite:TSemaphoreHandle;                                           {Number of free DMA Lite channels in ChannelFree}
  ChannelBulk:TSemaphoreHandle;                                           {Number of free DMA Bulk channels in ChannelFree}
  Channels:array[0..BCM2708_DMA_CHANNEL_COUNT - 1] of TBCM2708DMAChannel; {Channel information for each DMA channel on the host}
  EnableRegister:PLongWord;
  InterruptRegister:PLongWord;
  {Statistics Properties}                                        
  InterruptCount:LongWord;                                                {Number of interrupt requests received by the host controller}
 end;
 
 {BCM2708 PWM types}
 
 {BCM2708 PCM types}
 
 {BCM2708 GPIO types}
 
 {BCM2708 UART types}
 
 {BCM2708 SDHCI types}
 PBCM2708SDHCIHost = ^TBCM2708SDHCIHost;
 TBCM2708SDHCIHost = record
  {SDHCI Properties}
  SDHCI:TSDHCIHost;
  {BCM2708 Properties}
  //Lock:TSpinHandle; //To Do //Not Needed ? //See: DWCOTG etc
  WriteDelay:LongWord;
  LastWrite:LongWord;
  ShadowRegister:LongWord;
 end;
 
 {BCM2708 Clock types}
 PBCM2708Clock = ^TBCM2708Clock;
 TBCM2708Clock = record
  {Clock Properties}
  Clock:TClockDevice;
  {BCM2708 Properties}
   {Nothing}
 end; 

 {BCM2708 Timer types}
 PBCM2708Timer = ^TBCM2708Timer;
 TBCM2708Timer = record
  {Timer Properties}
  Timer:TTimerDevice;
  {BCM2708 Properties}
   {Nothing}
 end; 
 
 {BCM2708 Random types}
 PBCM2708Random = ^TBCM2708Random;
 TBCM2708Random = record
  {Random Properties}
  Random:TRandomDevice;
  {BCM2708 Properties}
   {Nothing}
 end; 

 {BCM2708 Mailbox types}
 PBCM2708Mailbox = ^TBCM2708Mailbox;
 TBCM2708Mailbox = record
  {Mailbox Properties}
  Mailbox:TMailboxDevice;
  {BCM2708 Properties}
   {Nothing}
 end; 
 
 {BCM2708 Watchdog types}
 PBCM2708Watchdog = ^TBCM2708Watchdog;
 TBCM2708Watchdog = record
  {Watchdog Properties}
  Watchdog:TWatchdogDevice;
  {BCM2708 Properties}
   {Nothing}
 end; 

 {BCM2708 Framebuffer types}
 PBCM2708Framebuffer = ^TBCM2708Framebuffer;
 TBCM2708Framebuffer = record
  {Framebuffer Properties}
  Framebuffer:TFramebufferDevice;
  {BCM2708 Properties}
   {Nothing}
 end; 
 
{==============================================================================}
{var}
 {BCM2708 specific variables}
 
{==============================================================================}
{Initialization Functions}
procedure BCM2708Init;
 
{==============================================================================}
{BCM2708 Functions}

{==============================================================================}
{BCM2708 SPI Functions}
 
{==============================================================================}
{BCM2708 I2C Functions}

{==============================================================================}
{BCM2708 DMA Functions}
function BCM2708DMAHostStart(DMA:PDMAHost):LongWord;
function BCM2708DMAHostStop(DMA:PDMAHost):LongWord;

function BCM2708DMAHostSubmit(DMA:PDMAHost;Request:PDMARequest):LongWord;
function BCM2708DMAHostCancel(DMA:PDMAHost;Request:PDMARequest):LongWord;

procedure BCM2708DMAInterruptHandler(Channel:PBCM2708DMAChannel);
procedure BCM2708DMASharedInterruptHandler(DMA:PBCM2708DMAHost);

procedure BCM2708DMARequestComplete(Channel:PBCM2708DMAChannel);

function BCM2708DMAPeripheralToDREQ(Peripheral:LongWord):LongWord;
procedure BCM2708DMADataToControlBlock(Request:PDMARequest;Data:PDMAData;Block:PBCM2835DMAControlBlock;Bulk,Lite:Boolean);

{==============================================================================}
{BCM2708 PWM Functions}

{==============================================================================}
{BCM2708 PCM Functions}

{==============================================================================}
{BCM2708 GPIO Functions}

{==============================================================================}
{BCM2708 UART Functions}

{==============================================================================}
{BCM2708 SDHCI Functions}
function BCM2708SDHCIHostStart(SDHCI:PSDHCIHost):LongWord;
function BCM2708SDHCIHostStop(SDHCI:PSDHCIHost):LongWord;

function BCM2708SDHCIHostReadByte(SDHCI:PSDHCIHost;Reg:LongWord):Byte; 
function BCM2708SDHCIHostReadWord(SDHCI:PSDHCIHost;Reg:LongWord):Word; 
function BCM2708SDHCIHostReadLong(SDHCI:PSDHCIHost;Reg:LongWord):LongWord; 
procedure BCM2708SDHCIHostWriteByte(SDHCI:PSDHCIHost;Reg:LongWord;Value:Byte); 
procedure BCM2708SDHCIHostWriteWord(SDHCI:PSDHCIHost;Reg:LongWord;Value:Word); 
procedure BCM2708SDHCIHostWriteLong(SDHCI:PSDHCIHost;Reg:LongWord;Value:LongWord); 
 
procedure BCM2708SDHCIInterruptHandler(SDHCI:PSDHCIHost);
function BCM2708SDHCISetupInterrupts(SDHCI:PSDHCIHost):LongWord;

function BCM2708MMCDeviceGetCardDetect(MMC:PMMCDevice):LongWord;
 
{==============================================================================}
{BCM2708 Clock Functions}
function BCM2708ClockRead(Clock:PClockDevice):LongWord;
function BCM2708ClockRead64(Clock:PClockDevice):Int64;

{==============================================================================}
{BCM2708 Timer Functions}
//To Do

{==============================================================================}
{BCM2708 Random Functions}
function BCM2708RandomStart(Random:PRandomDevice):LongWord;
function BCM2708RandomStop(Random:PRandomDevice):LongWord;

function BCM2708RandomReadLongWord(Random:PRandomDevice):LongWord;

{==============================================================================}
{BCM2708 Mailbox Functions}
//To Do

{==============================================================================}
{BCM2708 Watchdog Functions}
function BCM2708WatchdogStart(Watchdog:PWatchdogDevice):LongWord;
function BCM2708WatchdogStop(Watchdog:PWatchdogDevice):LongWord;
function BCM2708WatchdogRefresh(Watchdog:PWatchdogDevice):LongWord;

function BCM2708WatchdogGetRemain(Watchdog:PWatchdogDevice):LongWord;

{==============================================================================}
{BCM2708 Framebuffer Functions}
function BCM2708FramebufferAllocate(Framebuffer:PFramebufferDevice;Properties:PFramebufferProperties):LongWord;
function BCM2708FramebufferRelease(Framebuffer:PFramebufferDevice):LongWord;

function BCM2708FramebufferSetProperties(Framebuffer:PFramebufferDevice;Properties:PFramebufferProperties):LongWord;

{==============================================================================}
{BCM2708 Helper Functions}
 
{==============================================================================}
{==============================================================================}

implementation

{==============================================================================}
{==============================================================================}
var
 {BCM2708 specific variables}
 BCM2708Initialized:Boolean;

{==============================================================================}
{==============================================================================}
{Initialization Functions}
procedure BCM2708Init;
var
 Status:LongWord;
 
 BCM2708DMAHost:PBCM2708DMAHost;
 BCM2708SDHCIHost:PBCM2708SDHCIHost; 

 BCM2708Clock:PBCM2708Clock;
 BCM2708Timer:PBCM2708Timer;
 BCM2708Random:PBCM2708Random;
 BCM2708Mailbox:PBCM2708Mailbox;
 BCM2708Watchdog:PBCM2708Watchdog;
 BCM2708Framebuffer:PBCM2708Framebuffer;
begin
 {}
 {Check Initialized}
 if BCM2708Initialized then Exit;
 
 {Initialize BCM2708SDHCI_FIQ_ENABLED}
 if not(FIQ_ENABLED) then BCM2708SDHCI_FIQ_ENABLED:=False;
 
 {$IFNDEF CONSOLE_EARLY_INIT}
 {Register Platform GPU Memory Handlers}
 GPUMemoryAllocateHandler:=RPiGPUMemoryAllocate;
 GPUMemoryReleaseHandler:=RPiGPUMemoryRelease;
 GPUMemoryLockHandler:=RPiGPUMemoryLock;
 GPUMemoryUnlockHandler:=RPiGPUMemoryUnlock;
 
 {Register Platform GPU Misc Handlers}
 GPUExecuteCodeHandler:=RPiGPUExecuteCode;
 DispmanxHandleGetHandler:=RPiDispmanxHandleGet;
 EDIDBlockGetHandler:=RPiEDIDBlockGet;

 {Register Platform Framebuffer Handlers}
 FramebufferAllocateHandler:=RPiFramebufferAllocate;
 FramebufferReleaseHandler:=RPiFramebufferRelease;
 FramebufferSetStateHandler:=RPiFramebufferSetState;

 FramebufferGetDimensionsHandler:=RPiFramebufferGetDimensions;
 
 FramebufferGetPhysicalHandler:=RPiFramebufferGetPhysical;
 FramebufferSetPhysicalHandler:=RPiFramebufferSetPhysical;
 FramebufferTestPhysicalHandler:=RPiFramebufferTestPhysical;
 
 FramebufferGetVirtualHandler:=RPiFramebufferGetVirtual;
 FramebufferSetVirtualHandler:=RPiFramebufferSetVirtual;
 FramebufferTestVirtualHandler:=RPiFramebufferTestVirtual;
 
 FramebufferGetDepthHandler:=RPiFramebufferGetDepth;
 FramebufferSetDepthHandler:=RPiFramebufferSetDepth;
 FramebufferTestDepthHandler:=RPiFramebufferTestDepth;
 
 FramebufferGetPixelOrderHandler:=RPiFramebufferGetPixelOrder;
 FramebufferSetPixelOrderHandler:=RPiFramebufferSetPixelOrder;
 FramebufferTestPixelOrderHandler:=RPiFramebufferTestPixelOrder;
 
 FramebufferGetAlphaModeHandler:=RPiFramebufferGetAlphaMode;
 FramebufferSetAlphaModeHandler:=RPiFramebufferSetAlphaMode;
 FramebufferTestAlphaModeHandler:=RPiFramebufferTestAlphaMode;
 
 FramebufferGetPitchHandler:=RPiFramebufferGetPitch;
 
 FramebufferGetOffsetHandler:=RPiFramebufferGetOffset;
 FramebufferSetOffsetHandler:=RPiFramebufferSetOffset;
 FramebufferTestOffsetHandler:=RPiFramebufferTestOffset;
 
 FramebufferGetOverscanHandler:=RPiFramebufferGetOverscan;
 FramebufferSetOverscanHandler:=RPiFramebufferSetOverscan;
 FramebufferTestOverscanHandler:=RPiFramebufferTestOverscan;
 
 FramebufferGetPaletteHandler:=RPiFramebufferGetPalette;
 FramebufferSetPaletteHandler:=RPiFramebufferSetPalette;
 FramebufferTestPaletteHandler:=RPiFramebufferTestPalette;

 {Register Platform Cursor Handlers}
 CursorSetInfoHandler:=RPiCursorSetInfo;
 CursorSetStateHandler:=RPiCursorSetState;
 {$ENDIF}
 
 {Create SPI}
 if BCM2708_REGISTER_SPI then
  begin
   //To Do
  end; 
 
 {Create I2C}
 if BCM2708_REGISTER_I2C then
  begin
   //To Do
  end;
 
 {Create DMA}
 if BCM2708_REGISTER_DMA then
  begin
   BCM2708DMAHost:=PBCM2708DMAHost(DMAHostCreateEx(SizeOf(TBCM2708DMAHost)));
   if BCM2708DMAHost <> nil then
    begin
     {Update DMA}
     {Device}
     BCM2708DMAHost.DMA.Device.DeviceBus:=DEVICE_BUS_MMIO; 
     BCM2708DMAHost.DMA.Device.DeviceType:=DMA_TYPE_NONE;
     BCM2708DMAHost.DMA.Device.DeviceFlags:=DMA_FLAG_STRIDE or DMA_FLAG_DREQ or DMA_FLAG_NOINCREMENT or DMA_FLAG_NOREAD or DMA_FLAG_NOWRITE or DMA_FLAG_WIDE;
     BCM2708DMAHost.DMA.Device.DeviceData:=nil;
     if BCM2708DMA_SHARED_MEMORY then BCM2708DMAHost.DMA.Device.DeviceFlags:=BCM2708DMAHost.DMA.Device.DeviceFlags or DMA_FLAG_SHARED;
     if BCM2708DMA_NOCACHE_MEMORY then BCM2708DMAHost.DMA.Device.DeviceFlags:=BCM2708DMAHost.DMA.Device.DeviceFlags or DMA_FLAG_NOCACHE;
     if BCM2708DMA_CACHE_COHERENT then BCM2708DMAHost.DMA.Device.DeviceFlags:=BCM2708DMAHost.DMA.Device.DeviceFlags or DMA_FLAG_COHERENT;
     {DMA}
     BCM2708DMAHost.DMA.DMAState:=DMA_STATE_DISABLED;
     BCM2708DMAHost.DMA.HostStart:=BCM2708DMAHostStart;
     BCM2708DMAHost.DMA.HostStop:=BCM2708DMAHostStop;
     BCM2708DMAHost.DMA.HostReset:=nil;
     BCM2708DMAHost.DMA.HostSubmit:=BCM2708DMAHostSubmit;
     BCM2708DMAHost.DMA.HostCancel:=BCM2708DMAHostCancel;
     BCM2708DMAHost.DMA.HostProperties:=nil;
     BCM2708DMAHost.DMA.Alignment:=BCM2708DMA_ALIGNMENT;
     BCM2708DMAHost.DMA.Multiplier:=BCM2708DMA_MULTIPLIER;
     BCM2708DMAHost.DMA.Properties.Flags:=BCM2708DMAHost.DMA.Device.DeviceFlags;
     BCM2708DMAHost.DMA.Properties.Alignment:=BCM2708DMAHost.DMA.Alignment;
     BCM2708DMAHost.DMA.Properties.Multiplier:=BCM2708DMAHost.DMA.Multiplier;
     BCM2708DMAHost.DMA.Properties.Channels:=BCM2708_DMA_CHANNEL_COUNT;
     BCM2708DMAHost.DMA.Properties.MaxSize:=BCM2708_DMA_MAX_NORMAL_TRANSFER;
     BCM2708DMAHost.DMA.Properties.MaxCount:=BCM2708_DMA_MAX_Y_COUNT;
     BCM2708DMAHost.DMA.Properties.MaxLength:=BCM2708_DMA_MAX_X_LENGTH;
     BCM2708DMAHost.DMA.Properties.MinStride:=-32768;
     BCM2708DMAHost.DMA.Properties.MaxStride:=32767;
     {BCM2708}
     BCM2708DMAHost.ChannelLock:=INVALID_HANDLE_VALUE;
     BCM2708DMAHost.ChannelWait:=INVALID_HANDLE_VALUE;
     BCM2708DMAHost.ChannelLite:=INVALID_HANDLE_VALUE;
     BCM2708DMAHost.ChannelBulk:=INVALID_HANDLE_VALUE;
     
     {Register DMA}
     Status:=DMAHostRegister(@BCM2708DMAHost.DMA);
     if Status = ERROR_SUCCESS then
      begin
       {Start DMA}
       Status:=DMAHostStart(@BCM2708DMAHost.DMA);
       if Status <> ERROR_SUCCESS then
        begin
         if DMA_LOG_ENABLED then DMALogError(nil,'BCM2708: Failed to start new DMA host: ' + ErrorToString(Status));
        end;
      end
     else
      begin
       if DMA_LOG_ENABLED then DMALogError(nil,'BCM2708: Failed to register new DMA host: ' + ErrorToString(Status));
      end;
    end
   else 
    begin
     if DMA_LOG_ENABLED then DMALogError(nil,'BCM2708: Failed to create new DMA host');
    end;
  end;
  
 {Create PWM}
 if BCM2708_REGISTER_PWM then
  begin
   //To Do
  end;
  
 {Create PCM}
 if BCM2708_REGISTER_PCM then
  begin
   //To Do
  end;
  
 {Create GPIO}
 if BCM2708_REGISTER_GPIO then
  begin
   //To Do
  end;
 
 {Create UART}
 if BCM2708_REGISTER_UART then
  begin
   //To Do
  end;
 
 {Create SDHCI}
 if BCM2708_REGISTER_SDHCI then
  begin
   BCM2708SDHCIHost:=PBCM2708SDHCIHost(SDHCIHostCreateEx(SizeOf(TBCM2708SDHCIHost)));
   if BCM2708SDHCIHost <> nil then
    begin
     {Update SDHCI}
     {Device}
     BCM2708SDHCIHost.SDHCI.Device.DeviceBus:=DEVICE_BUS_MMIO; 
     BCM2708SDHCIHost.SDHCI.Device.DeviceType:=SDHCI_TYPE_NONE;
     BCM2708SDHCIHost.SDHCI.Device.DeviceFlags:=SDHCI_FLAG_NONE;
     BCM2708SDHCIHost.SDHCI.Device.DeviceData:=nil;
     {SDHCI}
     BCM2708SDHCIHost.SDHCI.SDHCIState:=SDHCI_STATE_DISABLED;
     BCM2708SDHCIHost.SDHCI.HostStart:=BCM2708SDHCIHostStart;
     BCM2708SDHCIHost.SDHCI.HostStop:=BCM2708SDHCIHostStop;
     BCM2708SDHCIHost.SDHCI.HostReadByte:=BCM2708SDHCIHostReadByte;
     BCM2708SDHCIHost.SDHCI.HostReadWord:=BCM2708SDHCIHostReadWord;
     BCM2708SDHCIHost.SDHCI.HostReadLong:=BCM2708SDHCIHostReadLong;
     BCM2708SDHCIHost.SDHCI.HostWriteByte:=BCM2708SDHCIHostWriteByte;
     BCM2708SDHCIHost.SDHCI.HostWriteWord:=BCM2708SDHCIHostWriteWord;
     BCM2708SDHCIHost.SDHCI.HostWriteLong:=BCM2708SDHCIHostWriteLong;
     BCM2708SDHCIHost.SDHCI.HostSetClockDivider:=nil;
     BCM2708SDHCIHost.SDHCI.HostSetControlRegister:=nil;
     BCM2708SDHCIHost.SDHCI.DeviceInitialize:=nil;
     BCM2708SDHCIHost.SDHCI.DeviceDeinitialize:=nil;
     BCM2708SDHCIHost.SDHCI.DeviceGetCardDetect:=BCM2708MMCDeviceGetCardDetect;
     BCM2708SDHCIHost.SDHCI.DeviceGetWriteProtect:=nil;
     BCM2708SDHCIHost.SDHCI.DeviceSendCommand:=nil;
     BCM2708SDHCIHost.SDHCI.DeviceSetIOS:=nil;
     {Driver}
     BCM2708SDHCIHost.SDHCI.Address:=Pointer(BCM2835_SDHCI_REGS_BASE);
   
     {Register SDHCI}
     Status:=SDHCIHostRegister(@BCM2708SDHCIHost.SDHCI);
     if Status <> ERROR_SUCCESS then
      begin
       if MMC_LOG_ENABLED then MMCLogError(nil,'BCM2708: Failed to register new SDHCI host: ' + ErrorToString(Status));
      end;
    end
   else 
    begin
     if MMC_LOG_ENABLED then MMCLogError(nil,'BCM2708: Failed to create new SDHCI host');
    end;
  end;

 {Create Clock}
 if BCM2708_REGISTER_CLOCK then
  begin
   BCM2708Clock:=PBCM2708Clock(ClockDeviceCreateEx(SizeOf(TBCM2708Clock)));
   if BCM2708Clock <> nil then
    begin
     {Update Clock}
     {Device}
     BCM2708Clock.Clock.Device.DeviceBus:=DEVICE_BUS_MMIO; 
     BCM2708Clock.Clock.Device.DeviceType:=CLOCK_TYPE_HARDWARE;
     BCM2708Clock.Clock.Device.DeviceFlags:=CLOCK_FLAG_NONE;
     BCM2708Clock.Clock.Device.DeviceData:=nil;
     {Clock}
     BCM2708Clock.Clock.ClockState:=CLOCK_STATE_DISABLED;
     BCM2708Clock.Clock.DeviceRead:=BCM2708ClockRead;
     BCM2708Clock.Clock.DeviceRead64:=BCM2708ClockRead64;
     {Driver}
     BCM2708Clock.Clock.Address:=Pointer(BCM2835_SYSTEM_TIMER_REGS_BASE);
     BCM2708Clock.Clock.Rate:=BCM2835_SYSTEM_TIMER_FREQUENCY;
    
     {Register Clock}
     Status:=ClockDeviceRegister(@BCM2708Clock.Clock);
     if Status = ERROR_SUCCESS then
      begin
       {Start Clock}
       Status:=ClockDeviceStart(@BCM2708Clock.Clock);
       if Status <> ERROR_SUCCESS then
        begin
         if DEVICE_LOG_ENABLED then DeviceLogError(nil,'BCM2708: Failed to start new clock device: ' + ErrorToString(Status));
        end;
      end
     else 
      begin
       if DEVICE_LOG_ENABLED then DeviceLogError(nil,'BCM2708: Failed to register new clock device: ' + ErrorToString(Status));
      end;
    end
   else 
    begin
     if DEVICE_LOG_ENABLED then DeviceLogError(nil,'BCM2708: Failed to create new clock device');
    end;
  end;
  
 {Create Timer}
 if BCM2708_REGISTER_TIMER then
  begin
   //To Do
  end; 
 
 {Create Random}
 if BCM2708_REGISTER_RANDOM then
  begin
   BCM2708Random:=PBCM2708Random(RandomDeviceCreateEx(SizeOf(TBCM2708Random)));
   if BCM2708Random <> nil then
    begin
     {Update Random}
     {Device}
     BCM2708Random.Random.Device.DeviceBus:=DEVICE_BUS_MMIO; 
     BCM2708Random.Random.Device.DeviceType:=RANDOM_TYPE_HARDWARE;
     BCM2708Random.Random.Device.DeviceFlags:=RANDOM_FLAG_NONE;
     BCM2708Random.Random.Device.DeviceData:=nil;
     {Random}
     BCM2708Random.Random.RandomState:=RANDOM_STATE_DISABLED;
     BCM2708Random.Random.DeviceStart:=BCM2708RandomStart;
     BCM2708Random.Random.DeviceStop:=BCM2708RandomStop;
     BCM2708Random.Random.DeviceReadLongWord:=BCM2708RandomReadLongWord;
     {Driver}
     BCM2708Random.Random.Address:=Pointer(BCM2835_RNG_REGS_BASE);
     
     {Register Random}
     Status:=RandomDeviceRegister(@BCM2708Random.Random);
     if Status = ERROR_SUCCESS then
      begin
       {Start Random}
       Status:=RandomDeviceStart(@BCM2708Random.Random);
       if Status <> ERROR_SUCCESS then
        begin
         if DEVICE_LOG_ENABLED then DeviceLogError(nil,'BCM2708: Failed to start new random device: ' + ErrorToString(Status));
        end;
      end
     else 
      begin
       if DEVICE_LOG_ENABLED then DeviceLogError(nil,'BCM2708: Failed to register new random device: ' + ErrorToString(Status));
      end;
    end
   else 
    begin
     if DEVICE_LOG_ENABLED then DeviceLogError(nil,'BCM2708: Failed to create new random device');
    end;
  end;
  
 {Create Mailbox}
 if BCM2708_REGISTER_MAILBOX then
  begin
   //To Do
  end; 
  
 {Create Watchdog}
 if BCM2708_REGISTER_WATCHDOG then
  begin
   BCM2708Watchdog:=PBCM2708Watchdog(WatchdogDeviceCreateEx(SizeOf(TBCM2708Watchdog)));
   if BCM2708Watchdog <> nil then
    begin
     {Device}
     BCM2708Watchdog.Watchdog.Device.DeviceBus:=DEVICE_BUS_MMIO; 
     BCM2708Watchdog.Watchdog.Device.DeviceType:=WATCHDOG_TYPE_HARDWARE;
     BCM2708Watchdog.Watchdog.Device.DeviceFlags:=WATCHDOG_FLAG_NONE;
     BCM2708Watchdog.Watchdog.Device.DeviceData:=nil;
     {Watchdog}
     BCM2708Watchdog.Watchdog.WatchdogState:=WATCHDOG_STATE_DISABLED;
     BCM2708Watchdog.Watchdog.DeviceStart:=BCM2708WatchdogStart;
     BCM2708Watchdog.Watchdog.DeviceStop:=BCM2708WatchdogStop;
     BCM2708Watchdog.Watchdog.DeviceRefresh:=BCM2708WatchdogRefresh;
     BCM2708Watchdog.Watchdog.DeviceGetRemain:=BCM2708WatchdogGetRemain;
     {Driver}
     BCM2708Watchdog.Watchdog.Address:=Pointer(BCM2835_PM_REGS_BASE);
     
     {Register Watchdog}
     Status:=WatchdogDeviceRegister(@BCM2708Watchdog.Watchdog);
     if Status <> ERROR_SUCCESS then
      begin
       if DEVICE_LOG_ENABLED then DeviceLogError(nil,'BCM2708: Failed to register new watchdog device: ' + ErrorToString(Status));
      end;
    end
   else 
    begin
     if DEVICE_LOG_ENABLED then DeviceLogError(nil,'BCM2708: Failed to create new watchdog device');
    end;
  end;
 
 {$IFNDEF CONSOLE_EARLY_INIT}
 {Create Framebuffer}
 if BCM2708_REGISTER_FRAMEBUFFER then
  begin
   BCM2708Framebuffer:=PBCM2708Framebuffer(FramebufferDeviceCreateEx(SizeOf(TBCM2708Framebuffer)));
   if BCM2708Framebuffer <> nil then
    begin
     {Device}
     BCM2708Framebuffer.Framebuffer.Device.DeviceBus:=DEVICE_BUS_MMIO; 
     BCM2708Framebuffer.Framebuffer.Device.DeviceType:=FRAMEBUFFER_TYPE_HARDWARE;
     BCM2708Framebuffer.Framebuffer.Device.DeviceFlags:=FRAMEBUFFER_FLAG_NONE;
     BCM2708Framebuffer.Framebuffer.Device.DeviceData:=nil;
     {Framebuffer}
     BCM2708Framebuffer.Framebuffer.FramebufferState:=FRAMEBUFFER_STATE_DISABLED;
     BCM2708Framebuffer.Framebuffer.DeviceAllocate:=BCM2708FramebufferAllocate;
     BCM2708Framebuffer.Framebuffer.DeviceRelease:=BCM2708FramebufferRelease;
     BCM2708Framebuffer.Framebuffer.DeviceSetProperties:=BCM2708FramebufferSetProperties;
     {Driver}
     
     {Setup Flags}
     if BCM2708FRAMEBUFFER_CACHED then BCM2708Framebuffer.Framebuffer.Device.DeviceFlags:=BCM2708Framebuffer.Framebuffer.Device.DeviceFlags or FRAMEBUFFER_FLAG_CACHED;
     if SysUtils.GetEnvironmentVariable('bcm2708_fb.fbswap') <> '1' then BCM2708Framebuffer.Framebuffer.Device.DeviceFlags:=BCM2708Framebuffer.Framebuffer.Device.DeviceFlags or FRAMEBUFFER_FLAG_SWAP; 
     
     {Register Framebuffer}
     Status:=FramebufferDeviceRegister(@BCM2708Framebuffer.Framebuffer);
     if Status = ERROR_SUCCESS then
      begin
       {Allocate Framebuffer}
       Status:=FramebufferDeviceAllocate(@BCM2708Framebuffer.Framebuffer,nil);
       if Status <> ERROR_SUCCESS then
        begin
         if DEVICE_LOG_ENABLED then DeviceLogError(nil,'BCM2708: Failed to allocate new framebuffer device: ' + ErrorToString(Status));
        end;
      end
     else
      begin     
       if DEVICE_LOG_ENABLED then DeviceLogError(nil,'BCM2708: Failed to register new framebuffer device: ' + ErrorToString(Status));
      end;
    end
   else 
    begin
     if DEVICE_LOG_ENABLED then DeviceLogError(nil,'BCM2708: Failed to create new framebuffer device');
    end;
  end;
 {$ENDIF}
 
 BCM2708Initialized:=True;
end;
 
{==============================================================================}
{==============================================================================}
{BCM2708 Functions}

{==============================================================================}
{==============================================================================}
{BCM2708 SPI Functions}
 
{==============================================================================}
{==============================================================================}
{BCM2708 I2C Functions}

{==============================================================================}
{==============================================================================}
{BCM2708 DMA Functions}
function BCM2708DMAHostStart(DMA:PDMAHost):LongWord;
var
 Mask:LongWord;
 Count:LongWord;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check DMA}
 if DMA = nil then Exit;
 
 {Get Channel Mask}
 PBCM2708DMAHost(DMA).ChannelMask:=DMAGetChannels;

 {$IF DEFINED(BCM2708_DEBUG) or DEFINED(DMA_DEBUG)}
 if DMA_LOG_ENABLED then DMALogDebug(nil,'BCM2708: Channel mask = ' + IntToHex(PBCM2708DMAHost(DMA).ChannelMask,8));
 {$ENDIF}
 
 {Get Channel Free}
 PBCM2708DMAHost(DMA).ChannelFree:=PBCM2708DMAHost(DMA).ChannelMask;
 
 {$IF DEFINED(BCM2708_DEBUG) or DEFINED(DMA_DEBUG)}
 if DMA_LOG_ENABLED then DMALogDebug(nil,'BCM2708: Channel free = ' + IntToHex(PBCM2708DMAHost(DMA).ChannelFree,8));
 {$ENDIF}
 
 {Create Channel Lock}
 PBCM2708DMAHost(DMA).ChannelLock:=MutexCreateEx(False,MUTEX_DEFAULT_SPINCOUNT,MUTEX_FLAG_RECURSIVE);
 if PBCM2708DMAHost(DMA).ChannelLock = INVALID_HANDLE_VALUE then
  begin
   Result:=ERROR_OPERATION_FAILED;
   Exit;
  end;
  
 {Count Free Normal Channels}
 Mask:=(PBCM2708DMAHost(DMA).ChannelMask and BCM2708_DMA_NORMAL_CHANNELS);
 Count:=0;
 while Mask <> 0 do
  begin
   if (Mask and 1) <> 0 then
    begin
     Inc(Count);
    end;
   
   Mask:=(Mask shr 1);
  end;
  
 {$IF DEFINED(BCM2708_DEBUG) or DEFINED(DMA_DEBUG)}
 if DMA_LOG_ENABLED then DMALogDebug(nil,'BCM2708: Normal channel free count = ' + IntToStr(Count));
 {$ENDIF}
  
 {Create Normal Channel Semaphore}
 PBCM2708DMAHost(DMA).ChannelWait:=SemaphoreCreate(Count);
 if PBCM2708DMAHost(DMA).ChannelWait = INVALID_HANDLE_VALUE then
  begin
   {Destroy Channel Lock}
   MutexDestroy(PBCM2708DMAHost(DMA).ChannelLock);
   
   Result:=ERROR_OPERATION_FAILED;
   Exit;
  end;

 {Count Free DMA Lite Channels}
 Mask:=(PBCM2708DMAHost(DMA).ChannelMask and BCM2708_DMA_LITE_CHANNELS);
 Count:=0;
 while Mask <> 0 do
  begin
   if (Mask and 1) <> 0 then
    begin
     Inc(Count);
    end;
   
   Mask:=(Mask shr 1);
  end;
  
 {$IF DEFINED(BCM2708_DEBUG) or DEFINED(DMA_DEBUG)}
 if DMA_LOG_ENABLED then DMALogDebug(nil,'BCM2708: DMA Lite channel free count = ' + IntToStr(Count));
 {$ENDIF}
  
 {Create DMA Lite Channel Semaphore}
 PBCM2708DMAHost(DMA).ChannelLite:=SemaphoreCreate(Count);
 if PBCM2708DMAHost(DMA).ChannelLite = INVALID_HANDLE_VALUE then
  begin
   {Destroy Normal Channel Semaphore}
   SemaphoreDestroy(PBCM2708DMAHost(DMA).ChannelWait);
   
   {Destroy Channel Lock}
   MutexDestroy(PBCM2708DMAHost(DMA).ChannelLock);
   
   Result:=ERROR_OPERATION_FAILED;
   Exit;
  end;

 {Count Free DMA Bulk Channels}
 Mask:=(PBCM2708DMAHost(DMA).ChannelMask and BCM2708_DMA_BULK_CHANNELS);
 Count:=0;
 while Mask <> 0 do
  begin
   if (Mask and 1) <> 0 then
    begin
     Inc(Count);
    end;
   
   Mask:=(Mask shr 1);
  end;
  
 {$IF DEFINED(BCM2708_DEBUG) or DEFINED(DMA_DEBUG)}
 if DMA_LOG_ENABLED then DMALogDebug(nil,'BCM2708: DMA Bulk channel free count = ' + IntToStr(Count));
 {$ENDIF}
  
 {Create DMA Bulk Channel Semaphore}
 PBCM2708DMAHost(DMA).ChannelBulk:=SemaphoreCreate(Count);
 if PBCM2708DMAHost(DMA).ChannelBulk = INVALID_HANDLE_VALUE then
  begin
   {Destroy DMA Lite Channel Semaphore}
   SemaphoreDestroy(PBCM2708DMAHost(DMA).ChannelLite);
  
   {Destroy Normal Channel Semaphore}
   SemaphoreDestroy(PBCM2708DMAHost(DMA).ChannelWait);
   
   {Destroy Channel Lock}
   MutexDestroy(PBCM2708DMAHost(DMA).ChannelLock);
   
   Result:=ERROR_OPERATION_FAILED;
   Exit;
  end;
 
 {Setup Enable Register}
 PBCM2708DMAHost(DMA).EnableRegister:=PLongWord(BCM2835_DMA_ENABLE_BASE);
 
 {Setup Interrupt Register}
 PBCM2708DMAHost(DMA).InterruptRegister:=PLongWord(BCM2835_DMA_INT_STATUS_BASE);
 
 {Start Channels}
 for Count:=0 to BCM2708_DMA_CHANNEL_COUNT - 1 do
  begin
   {Host}
   PBCM2708DMAHost(DMA).Channels[Count].Host:=PBCM2708DMAHost(DMA);
   
   {Channel No}
   PBCM2708DMAHost(DMA).Channels[Count].Number:=Count;
   
   {Check Available}
   if (PBCM2708DMAHost(DMA).ChannelMask and (1 shl Count)) <> 0 then
    begin
     {Check Channel}
     case Count of
      {Channels 0 to 10}
      0..10:begin
        {Interrupt No}
        PBCM2708DMAHost(DMA).Channels[Count].Interrupt:=BCM2835_IRQ_DMA0 + Count;
      
        {Registers}
        PBCM2708DMAHost(DMA).Channels[Count].Registers:=PBCM2835DMARegisters(BCM2835_DMA0_REGS_BASE + ($100 * Count));
      
        {Request IRQ}
        RequestIRQ(IRQ_ROUTING,PBCM2708DMAHost(DMA).Channels[Count].Interrupt,TInterruptHandler(BCM2708DMAInterruptHandler),@PBCM2708DMAHost(DMA).Channels[Count]);
       end;
      {Channels 11 to 14}
      11..14:begin
        {Interrupt No}
        PBCM2708DMAHost(DMA).Channels[Count].Interrupt:=BCM2835_IRQ_DMA11_14;
      
        {Registers}
        PBCM2708DMAHost(DMA).Channels[Count].Registers:=PBCM2835DMARegisters(BCM2835_DMA0_REGS_BASE + ($100 * Count));
      
        {Request IRQ}
        RequestIRQ(IRQ_ROUTING,PBCM2708DMAHost(DMA).Channels[Count].Interrupt,TInterruptHandler(BCM2708DMASharedInterruptHandler),DMA);
       end; 
      {Channel 15}
      15:begin
        {Interrupt No (Only available on the all channels interrupt)} 
        PBCM2708DMAHost(DMA).Channels[Count].Interrupt:=BCM2835_IRQ_DMA_ALL;

        {Registers}
        PBCM2708DMAHost(DMA).Channels[Count].Registers:=PBCM2835DMARegisters(BCM2835_DMA15_REGS_BASE);
        
        {No Request IRQ}
       end;      
     end;
     
     {Memory Barrier}
     DataMemoryBarrier; {Before the First Write}
     
     {Check the Channel}
     if (PBCM2708DMAHost(DMA).EnableRegister^ and (1 shl Count)) = 0 then
      begin
       {Enable the Channel}
       PBCM2708DMAHost(DMA).EnableRegister^:=PBCM2708DMAHost(DMA).EnableRegister^ or (1 shl Count);
       MicrosecondDelay(1000);
     
       {Reset the Channel}
       PBCM2708DMAHost(DMA).Channels[Count].Registers.CS:=BCM2835_DMA_CS_RESET;
      end; 
     
     {Memory Barrier}
     DataMemoryBarrier; {After the Last Read} 
    end
   else
    begin
     {Interrupt No}
     PBCM2708DMAHost(DMA).Channels[Count].Interrupt:=LongWord(INVALID_HANDLE_VALUE);
     
     {Registers}
     PBCM2708DMAHost(DMA).Channels[Count].Registers:=nil;
    end;
  end;

 Result:=ERROR_SUCCESS;  
end; 

{==============================================================================}

function BCM2708DMAHostStop(DMA:PDMAHost):LongWord;
var
 Count:LongWord;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check DMA}
 if DMA = nil then Exit;
 
 {Stop Channels}
 for Count:=0 to BCM2708_DMA_CHANNEL_COUNT - 1 do
  begin
   {Check Available}
   if (PBCM2708DMAHost(DMA).ChannelMask and (1 shl Count)) <> 0 then
    begin
     {Check Channel}
     case Count of
      {Channels 0 to 10}
      0..10:begin
        {Release IRQ}
        ReleaseIRQ(IRQ_ROUTING,PBCM2708DMAHost(DMA).Channels[Count].Interrupt,TInterruptHandler(BCM2708DMAInterruptHandler),@PBCM2708DMAHost(DMA).Channels[Count]);
       end;
      {Channels 11 to 14}
      11..14:begin
        {Release IRQ}
        ReleaseIRQ(IRQ_ROUTING,PBCM2708DMAHost(DMA).Channels[Count].Interrupt,TInterruptHandler(BCM2708DMASharedInterruptHandler),DMA);
       end;
      {Channel 15}
      15:begin
        {No Release IRQ}
       end;
     end;
    end;
  end; 

 {Destroy DMA Bulk Channel Semaphore}
 SemaphoreDestroy(PBCM2708DMAHost(DMA).ChannelBulk);
 PBCM2708DMAHost(DMA).ChannelBulk:=INVALID_HANDLE_VALUE;
  
 {Destroy DMA Lite Channel Semaphore}
 SemaphoreDestroy(PBCM2708DMAHost(DMA).ChannelLite);
 PBCM2708DMAHost(DMA).ChannelLite:=INVALID_HANDLE_VALUE;
  
 {Destroy Normal Channel Semaphore}
 SemaphoreDestroy(PBCM2708DMAHost(DMA).ChannelWait);
 PBCM2708DMAHost(DMA).ChannelWait:=INVALID_HANDLE_VALUE;
 
 {Destroy Channel Lock}
 MutexDestroy(PBCM2708DMAHost(DMA).ChannelLock);
 PBCM2708DMAHost(DMA).ChannelLock:=INVALID_HANDLE_VALUE;
 
 Result:=ERROR_SUCCESS;  
end; 

{==============================================================================}

function BCM2708DMAHostSubmit(DMA:PDMAHost;Request:PDMARequest):LongWord;
var
 Bulk:Boolean;
 Lite:Boolean;
 Flags:LongWord;
 Count:LongWord;
 Channel:LongWord;
 Maximum:LongWord;
 Data:PDMAData;
 Block:PBCM2835DMAControlBlock;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check DMA}
 if DMA = nil then Exit;
 
 {Check Request}
 if Request = nil then Exit;
 if Request.Host <> DMA then Exit;
 
 {$IF DEFINED(BCM2708_DEBUG) or DEFINED(DMA_DEBUG)}
 if DMA_LOG_ENABLED then DMALogDebug(DMA,'BCM2708: Submitting request (Request=' + IntToHex(LongWord(Request),8) + ')');
 {$ENDIF}
 
 {Get Data Count}
 Count:=DMADataCount(Request.Data);
 if Count = 0 then Exit;

 {Get Data Flags}
 Flags:=DMADataFlags(Request.Data);
 
 {Get Data Maximum}
 Maximum:=DMADataMaximum(Request.Data);
 
 Bulk:=False;
 Lite:=False;
 
 {Check for "Bulk" channel request}
 if (Flags and DMA_DATA_FLAG_BULK) <> 0 then
  begin
   Bulk:=True;
  end
 else
  begin 
   {Check for "Lite" suitable request (No Stride, No Ignore, Size less then 64K)}
   if (Flags and (DMA_DATA_FLAG_STRIDE or DMA_DATA_FLAG_NOREAD or DMA_DATA_FLAG_NOWRITE) = 0) and (Maximum <= BCM2708_DMA_MAX_LITE_TRANSFER) then
    begin
     Lite:=True;
    end;
  end;  
 
 {Get Maximum Size}
 Maximum:=BCM2708_DMA_MAX_NORMAL_TRANSFER;
 if Lite then Maximum:=BCM2708_DMA_MAX_LITE_TRANSFER;
 
 Result:=ERROR_OPERATION_FAILED;
 
 {Create Control Blocks}
 if BCM2708DMA_SHARED_MEMORY then
  begin
   Request.ControlBlocks:=GetSharedAlignedMem(Count * SizeOf(TBCM2835DMAControlBlock),BCM2708_DMA_CB_ALIGNMENT);
  end
 else if BCM2708DMA_NOCACHE_MEMORY then
  begin
   Request.ControlBlocks:=GetNoCacheAlignedMem(Count * SizeOf(TBCM2835DMAControlBlock),BCM2708_DMA_CB_ALIGNMENT);
  end
 else 
  begin
   Request.ControlBlocks:=GetAlignedMem(Count * SizeOf(TBCM2835DMAControlBlock),BCM2708_DMA_CB_ALIGNMENT);
  end;  
 if Request.ControlBlocks = nil then Exit;
 try
  {Update Control Blocks}
  Data:=Request.Data;
  Block:=PBCM2835DMAControlBlock(Request.ControlBlocks);
  while Data <> nil do
   begin
    {Check Size}
    if Data.Size = 0 then Exit;
    if Data.Size > Maximum then Exit;
    if ((Data.Flags and DMA_DATA_FLAG_STRIDE) <> 0) and (Data.StrideLength = 0) then Exit;
    
    {Setup Control Block}
    BCM2708DMADataToControlBlock(Request,Data,Block,Bulk,Lite);
    
    {$IF DEFINED(BCM2708_DEBUG) or DEFINED(DMA_DEBUG)}
    if DMA_LOG_ENABLED then DMALogDebug(DMA,'BCM2708: Data block (Source=' + IntToHex(LongWord(Data.Source),8) + ' Dest=' + IntToHex(LongWord(Data.Dest),8) + ' Size=' + IntToStr(Data.Size) + ')');
    if DMA_LOG_ENABLED then DMALogDebug(DMA,'BCM2708: Control block (SourceAddress=' + IntToHex(Block.SourceAddress,8) + ' DestinationAddress=' + IntToHex(Block.DestinationAddress,8) + ' TransferLength=' + IntToHex(Block.TransferLength,8) + ')');
    {$ENDIF}
    
    {Get Next}
    Data:=Data.Next;
    if Data <> nil then
     begin
      {Get Next Block}
      Block:=PBCM2835DMAControlBlock(LongWord(Block) + SizeOf(TBCM2835DMAControlBlock));
     end;
   end; 
 
  {Flush Control Blocks}
  if not(BCM2708DMA_CACHE_COHERENT) then
   begin
    CleanDataCacheRange(LongWord(Request.ControlBlocks),Count * SizeOf(TBCM2835DMAControlBlock));
   end;
  
  {Wait for Channel}
  if Bulk then
   begin
    if SemaphoreWait(PBCM2708DMAHost(DMA).ChannelBulk) <> ERROR_SUCCESS then Exit;
   end
  else if Lite then
   begin
    if SemaphoreWait(PBCM2708DMAHost(DMA).ChannelLite) <> ERROR_SUCCESS then Exit;
   end
  else
   begin  
    if SemaphoreWait(PBCM2708DMAHost(DMA).ChannelWait) <> ERROR_SUCCESS then Exit;
   end; 
  
  {Acquire the Lock}
  if MutexLock(PBCM2708DMAHost(DMA).ChannelLock) = ERROR_SUCCESS then
   begin
    try
     {Get Free Channel}
     if Bulk then
      begin
       Channel:=FirstBitSet(PBCM2708DMAHost(DMA).ChannelFree and BCM2708_DMA_BULK_CHANNELS);
      end
     else if Lite then
      begin
       Channel:=FirstBitSet(PBCM2708DMAHost(DMA).ChannelFree and BCM2708_DMA_LITE_CHANNELS);
      end
     else
      begin
       Channel:=FirstBitSet(PBCM2708DMAHost(DMA).ChannelFree and BCM2708_DMA_NORMAL_CHANNELS);
      end;
      
     {$IF DEFINED(BCM2708_DEBUG) or DEFINED(DMA_DEBUG)}
     if DMA_LOG_ENABLED then DMALogDebug(DMA,'BCM2708: Allocated channel (Channel=' + IntToStr(Channel) + ')');
     {$ENDIF}
      
     {Check Free Channel} 
     if Channel <> LongWord(INVALID_HANDLE_VALUE) then 
      begin
       {Update Channel Free}
       PBCM2708DMAHost(DMA).ChannelFree:=PBCM2708DMAHost(DMA).ChannelFree xor (1 shl Channel);
      
       {Update Channel}
       PBCM2708DMAHost(DMA).Channels[Channel].Request:=Request;
       
       {Memory Barrier}
       DataMemoryBarrier; {Before the First Write}
       
       {Set Control Block}
       if BCM2708DMA_BUS_ADDRESSES then
        begin
         PBCM2708DMAHost(DMA).Channels[Channel].Registers.CONBLK_AD:=PhysicalToBusAddress(Request.ControlBlocks);
        end
       else
        begin
         PBCM2708DMAHost(DMA).Channels[Channel].Registers.CONBLK_AD:=LongWord(Request.ControlBlocks);
        end; 
       
       {Note: Broadcom documentation states that BCM2835_DMA_CS_ERROR bit should be cleared by writing
              to the error bits in the debug register, this doesn't seem to be neccessary in practice}
              
       {Enable Channel}
       PBCM2708DMAHost(DMA).Channels[Channel].Registers.CS:=BCM2835_DMA_CS_ACTIVE;
       
       {Note: Broadcom documentation states that the BCM2835_DMA_CS_END bit will be set when a transfer
              is completed and should be cleared by writing 1 to it, this doesn't seem to be the case}
                            
       {Update Status}
       Request.Status:=ERROR_NOT_COMPLETED;
      
       {Return Result}
       Result:=ERROR_SUCCESS;
      end
     else
      begin
       {Signal Semaphore}
       if Bulk then
        begin
         SemaphoreSignal(PBCM2708DMAHost(DMA).ChannelBulk);
        end
       else if Lite then
        begin
         SemaphoreSignal(PBCM2708DMAHost(DMA).ChannelLite);
        end
       else
        begin
         SemaphoreSignal(PBCM2708DMAHost(DMA).ChannelWait);
        end;
      end;     
    finally
     {Release the Lock}
     MutexUnlock(PBCM2708DMAHost(DMA).ChannelLock);
    end;   
   end;
 finally
  if Result <> ERROR_SUCCESS then
   begin
    FreeMem(Request.ControlBlocks);
   end;
 end; 
end; 

{==============================================================================}

function BCM2708DMAHostCancel(DMA:PDMAHost;Request:PDMARequest):LongWord;
var
 CS:LongWord;
 Count:LongWord;
 Channel:LongWord;
 Timeout:LongWord;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check DMA}
 if DMA = nil then Exit;
 
 {Check Request}
 if Request = nil then Exit;
 if Request.Host <> DMA then Exit;
 
 {$IF DEFINED(BCM2708_DEBUG) or DEFINED(DMA_DEBUG)}
 if DMA_LOG_ENABLED then DMALogDebug(DMA,'BCM2708: Cancelling request (Request=' + IntToHex(LongWord(Request),8) + ')');
 {$ENDIF}
 
 {Acquire the Lock}
 if MutexLock(PBCM2708DMAHost(DMA).ChannelLock) = ERROR_SUCCESS then
  begin
   try
    {Check Request}
    if Request.Status = ERROR_NOT_PROCESSED then
     begin
      {Update Request}
      Request.Status:=ERROR_CANCELLED;
     
      {Return Result}
      Result:=ERROR_SUCCESS;
     end
    else if Request.Status = ERROR_NOT_COMPLETED then
     begin
      {Update Request}
      Request.Status:=ERROR_CANCELLED;
     
      {Find Channel}
      Channel:=LongWord(INVALID_HANDLE_VALUE);
      for Count:=0 to BCM2708_DMA_CHANNEL_COUNT - 1 do
       begin
        if PBCM2708DMAHost(DMA).Channels[Channel].Request = Request then
         begin
          Channel:=Count;
          Break;
         end;
       end;
       
      {Check Channel}
      if Channel <> LongWord(INVALID_HANDLE_VALUE) then
       begin
        {$IF DEFINED(BCM2708_DEBUG) or DEFINED(DMA_DEBUG)}
        if DMA_LOG_ENABLED then DMALogDebug(DMA,'BCM2708: Located channel (Channel=' + IntToStr(Channel) + ')');
        {$ENDIF}
      
        {Memory Barrier}
        DataMemoryBarrier; {Before the First Write}
      
        {Get Status}
        CS:=PBCM2708DMAHost(DMA).Channels[Channel].Registers.CS;
      
        {Check Active}
        if (CS and BCM2835_DMA_CS_ACTIVE) <> 0 then
         begin
          {Pause the Channel}
          PBCM2708DMAHost(DMA).Channels[Channel].Registers.CS:=CS and not(BCM2835_DMA_CS_ACTIVE);
          
          {Wait for Paused}
          Timeout:=10000;
          while ((CS and BCM2835_DMA_CS_PAUSED) = 0) and (Timeout > 0) do
           begin
            CS:=PBCM2708DMAHost(DMA).Channels[Channel].Registers.CS;
            
            Dec(Timeout);
           end;
          
          {Check Paused}
          if (CS and BCM2835_DMA_CS_PAUSED) = 0 then
           begin
            Result:=ERROR_TIMEOUT;
            Exit;
           end;
           
          {Clear the Next Control Block}
          PBCM2708DMAHost(DMA).Channels[Channel].Registers.NEXTCONBK:=0;
          
          {Set the Interrupt Enable}
          PBCM2708DMAHost(DMA).Channels[Channel].Registers.TI:=PBCM2708DMAHost(DMA).Channels[Channel].Registers.TI or BCM2835_DMA_TI_INTEN;
          
          {Enable and Abort the Channel}
          PBCM2708DMAHost(DMA).Channels[Channel].Registers.CS:=PBCM2708DMAHost(DMA).Channels[Channel].Registers.CS or BCM2835_DMA_CS_ACTIVE or BCM2835_DMA_CS_ABORT;
         end;
         
        {Memory Barrier}
        DataMemoryBarrier; {After the Last Read} 
           
        {Interrupt handler will complete cancel}
       end
      else
       begin
        {$IF DEFINED(BCM2708_DEBUG) or DEFINED(DMA_DEBUG)}
        if DMA_LOG_ENABLED then DMALogDebug(DMA,'BCM2708: No channel');
        {$ENDIF}
       
        {Interrupt handler will complete cancel}
       end;
              
      {Return Result}
      Result:=ERROR_SUCCESS;
     end
    else
     begin
      {Return Result}
      Result:=ERROR_OPERATION_FAILED;
     end;     
   finally
    {Release the Lock}
    MutexUnlock(PBCM2708DMAHost(DMA).ChannelLock);
   end;   
  end
 else
  begin
   Result:=ERROR_OPERATION_FAILED;
  end;
end; 

{==============================================================================}

procedure BCM2708DMAInterruptHandler(Channel:PBCM2708DMAChannel);
{DMA Channels 0 to 10 each have a dedicated interrupt, this handler simply
 clears the interrupt and sends a completion on the associated channel}
begin
 {}
 {Check Channel}
 if Channel = nil then Exit;
 if Channel.Registers = nil then Exit;
 
 {Memory Barrier}
 DataMemoryBarrier; {Before the First Write}
 
 {Acknowledge Interrupt}
 Channel.Registers.CS:=BCM2835_DMA_CS_INT;
 
 {Send Completion}
 WorkerScheduleIRQ(CPU_AFFINITY_NONE,TWorkerTask(BCM2708DMARequestComplete),Channel,nil);
end; 

{==============================================================================}

procedure BCM2708DMASharedInterruptHandler(DMA:PBCM2708DMAHost);
{DMA Channels 11 to 14 share a common interrupt, this alternate handler determines
 which ones triggered the current interrupt and sends a completion on that channel}
var
 Channel:LongWord;
 Interrupts:LongWord; 
begin
 {}
 {Check DMA}
 if DMA = nil then Exit;

 {Memory Barrier}
 DataMemoryBarrier; {Before the First Write}
 
 {Get Interrupt Status}
 Interrupts:=(DMA.InterruptRegister^ and BCM2708_DMA_SHARED_CHANNELS);
 while Interrupts <> 0 do
  begin
   {Get Channel}
   Channel:=FirstBitSet(Interrupts);
   
   {Check Channel}
   if DMA.Channels[Channel].Registers <> nil then
    begin
     {Acknowledge Interrupt}
     DMA.Channels[Channel].Registers.CS:=BCM2835_DMA_CS_INT;
     
     {Send Completion}
     WorkerScheduleIRQ(CPU_AFFINITY_NONE,TWorkerTask(BCM2708DMARequestComplete),@DMA.Channels[Channel],nil);
    end;
   
   {Clear the Interrupt}
   Interrupts:=Interrupts xor (1 shl Channel);
  end; 
 
 {Memory Barrier}
 DataMemoryBarrier; {After the Last Read} 
end;

{==============================================================================}

procedure BCM2708DMARequestComplete(Channel:PBCM2708DMAChannel);
var
 CS:LongWord;
 Data:PDMAData;
 Offset:LongInt; {Allow for negative stride}
 DMA:PBCM2708DMAHost;
 Request:PDMARequest;
begin
 {}
 {Check Channel}
 if Channel = nil then Exit;
 if Channel.Registers = nil then Exit;
 
 {Get Host}
 DMA:=Channel.Host;
 if DMA = nil then Exit;
 
 {$IF DEFINED(BCM2708_DEBUG) or DEFINED(DMA_DEBUG)}
 if DMA_LOG_ENABLED then DMALogDebug(@DMA.DMA,'BCM2708: Request completed (Request=' + IntToHex(LongWord(Channel.Request),8) + ')');
 {$ENDIF}

 {Get Status}
 CS:=Channel.Registers.CS;

 {$IF DEFINED(BCM2708_DEBUG) or DEFINED(DMA_DEBUG)}
 if DMA_LOG_ENABLED then DMALogDebug(@DMA.DMA,'BCM2708:  (Registers.CS=' + IntToHex(Channel.Registers.CS,8) + ')');
 if DMA_LOG_ENABLED then DMALogDebug(@DMA.DMA,'BCM2708:  (Registers.CONBLK_AD=' + IntToHex(Channel.Registers.CONBLK_AD,8) + ')');
 if DMA_LOG_ENABLED then DMALogDebug(@DMA.DMA,'BCM2708:  (Registers.TI=' + IntToHex(Channel.Registers.TI,8) + ')');
 if DMA_LOG_ENABLED then DMALogDebug(@DMA.DMA,'BCM2708:  (Registers.SOURCE_AD=' + IntToHex(Channel.Registers.SOURCE_AD,8) + ')');
 if DMA_LOG_ENABLED then DMALogDebug(@DMA.DMA,'BCM2708:  (Registers.DEST_AD=' + IntToHex(Channel.Registers.DEST_AD,8) + ')');
 if DMA_LOG_ENABLED then DMALogDebug(@DMA.DMA,'BCM2708:  (Registers.TXFR_LEN=' + IntToHex(Channel.Registers.TXFR_LEN,8) + ')');
 if DMA_LOG_ENABLED then DMALogDebug(@DMA.DMA,'BCM2708:  (Registers.STRIDE=' + IntToHex(Channel.Registers.STRIDE,8) + ')');
 if DMA_LOG_ENABLED then DMALogDebug(@DMA.DMA,'BCM2708:  (Registers.NEXTCONBK=' + IntToHex(Channel.Registers.NEXTCONBK,8) + ')');
 if DMA_LOG_ENABLED then DMALogDebug(@DMA.DMA,'BCM2708:  (Registers.DEBUG=' + IntToHex(Channel.Registers.DEBUG,8) + ')');
 {$ENDIF}
 
 {Memory Barrier}
 DataMemoryBarrier; {After the Last Read} 
 
 {Get Request}
 Request:=Channel.Request;
 
 {Acquire the Lock}
 if MutexLock(DMA.ChannelLock) = ERROR_SUCCESS then
  begin
   try
    {Update Statistics}
    Inc(DMA.InterruptCount);
    
    {Check Channel}
    if Channel.Number < BCM2708_DMA_CHANNEL_COUNT then
     begin
      {$IF DEFINED(BCM2708_DEBUG) or DEFINED(DMA_DEBUG)}
      if DMA_LOG_ENABLED then DMALogDebug(@DMA.DMA,'BCM2708: Released channel (Channel=' + IntToStr(Channel.Number) + ')');
      {$ENDIF}
      
      {Update Channel}
      DMA.Channels[Channel.Number].Request:=nil;
      
      {Update Channel Free}
      DMA.ChannelFree:=DMA.ChannelFree or (1 shl Channel.Number);
      
      {Check Bulk}
      if ((1 shl Channel.Number) and BCM2708_DMA_BULK_CHANNELS) <> 0 then
       begin
        {Signal Semaphore}
        SemaphoreSignal(DMA.ChannelBulk);
       end
      {Check Lite}
      else if ((1 shl Channel.Number) and BCM2708_DMA_LITE_CHANNELS) <> 0 then
       begin
        {Signal Semaphore}
        SemaphoreSignal(DMA.ChannelLite);
       end
      else
       begin
        {Signal Semaphore}
        SemaphoreSignal(DMA.ChannelWait);
       end;
     end; 
    
   finally
    {Release the Lock}
    MutexUnlock(DMA.ChannelLock);
   end;   
  end;
  
 {Check Request}
 if Request <> nil then
  begin
   {Check Status}
   if (CS and BCM2835_DMA_CS_ERROR) <> 0 then
    begin
     Request.Status:=ERROR_OPERATION_FAILED;
    end
   else
    begin
     Request.Status:=ERROR_SUCCESS;
    end;       
   
   {Release Control Blocks}
   if Request.ControlBlocks <> nil then
    begin
     FreeMem(Request.ControlBlocks);
     Request.ControlBlocks:=nil;
    end; 
   
   {Flush Dest} 
   case Request.Direction of
    DMA_DIR_MEM_TO_MEM,DMA_DIR_DEV_TO_MEM:begin
      if not(BCM2708DMA_CACHE_COHERENT) then
       begin
        Data:=Request.Data;
        while Data <> nil do
         begin
          if (Data.Flags and DMA_DATA_FLAG_NOINVALIDATE) = 0 then
           begin
            if ((Data.Flags and DMA_DATA_FLAG_STRIDE) = 0) or (Data.DestStride = 0) then
             begin
              InvalidateDataCacheRange(LongWord(Data.Dest),Data.Size);
             end
            else
             begin
              Offset:=0;
              while Offset < Data.Size do
               begin
                InvalidateDataCacheRange(LongWord(Data.Dest + Offset),Data.StrideLength);
                
                Inc(Offset,Data.DestStride);
               end;
             end;
           end; 
          
          Data:=Data.Next;
         end; 
       end;
     end;
   end;
           
   {Complete the request}
   DMARequestComplete(Request);
  end;
end; 

{==============================================================================}

function BCM2708DMAPeripheralToDREQ(Peripheral:LongWord):LongWord;
begin
 {}
 Result:=BCM2835_DMA_DREQ_NONE;
 
 case Peripheral of
  DMA_DREQ_ID_UART_TX:Result:=BCM2835_DMA_DREQ_UARTTX;
  DMA_DREQ_ID_UART_RX:Result:=BCM2835_DMA_DREQ_UARTRX;
  DMA_DREQ_ID_SPI_TX:Result:=BCM2835_DMA_DREQ_SPITX;
  DMA_DREQ_ID_SPI_RX:Result:=BCM2835_DMA_DREQ_SPIRX;
  DMA_DREQ_ID_SPI_SLAVE_TX:Result:=BCM2835_DMA_DREQ_BSCSPITX;
  DMA_DREQ_ID_SPI_SLAVE_RX:Result:=BCM2835_DMA_DREQ_BSCSPIRX;
  DMA_DREQ_ID_PCM_TX:Result:=BCM2835_DMA_DREQ_PCMTX;
  DMA_DREQ_ID_PCM_RX:Result:=BCM2835_DMA_DREQ_PCMRX;
  DMA_DREQ_ID_PWM:Result:=BCM2835_DMA_DREQ_PWM;
  DMA_DREQ_ID_MMC:Result:=BCM2835_DMA_DREQ_EMMC;
  DMA_DREQ_ID_SDHOST:Result:=BCM2835_DMA_DREQ_SDHOST;
 end;
end;

{==============================================================================}

procedure BCM2708DMADataToControlBlock(Request:PDMARequest;Data:PDMAData;Block:PBCM2835DMAControlBlock;Bulk,Lite:Boolean);
var
 Count:LongWord;
 Offset:LongInt; {Allow for negative stride}
begin
 {}
 if Request = nil then Exit;
 if Data = nil then Exit;
 if Block = nil then Exit;
 
 {Clear Transfer Information}
 Block.TransferInformation:=0;
 
 {Setup Source and Destination}
 if BCM2708DMA_BUS_ADDRESSES then
  begin
   case Request.Direction of
    DMA_DIR_NONE:begin
      Block.SourceAddress:=LongWord(Data.Source);
      Block.DestinationAddress:=LongWord(Data.Dest);
     end;
    DMA_DIR_MEM_TO_MEM:begin
      Block.SourceAddress:=PhysicalToBusAddress(Data.Source);
      Block.DestinationAddress:=PhysicalToBusAddress(Data.Dest);
     end;
    DMA_DIR_MEM_TO_DEV:begin
      Block.SourceAddress:=PhysicalToBusAddress(Data.Source);
      Block.DestinationAddress:=PhysicalToIOAddress(Data.Dest);
     end;
    DMA_DIR_DEV_TO_MEM:begin
      Block.SourceAddress:=PhysicalToIOAddress(Data.Source);
      Block.DestinationAddress:=PhysicalToBusAddress(Data.Dest);
     end;
    DMA_DIR_DEV_TO_DEV:begin
      Block.SourceAddress:=PhysicalToIOAddress(Data.Source);
      Block.DestinationAddress:=PhysicalToIOAddress(Data.Dest);
     end;     
   end;
  end
 else
  begin
   Block.SourceAddress:=LongWord(Data.Source);
   Block.DestinationAddress:=LongWord(Data.Dest);
  end;  
   
 {Setup Transfer Length and Stride}
 if (Data.Flags and DMA_DATA_FLAG_STRIDE) = 0 then
  begin
   {Linear Mode}
   Block.TransferLength:=Data.Size;
   Block.ModeStide:=0;
  end
 else
  begin
   {Stride Mode}
   Block.TransferInformation:=Block.TransferInformation or BCM2835_DMA_TI_2DMODE;
   
   {Get Count (minus 1)}
   Count:=(Data.Size div (Data.StrideLength and BCM2708_DMA_MAX_X_LENGTH)) - 1;
   
   {Set Length and Count}
   Block.TransferLength:=((Count and BCM2708_DMA_MAX_Y_COUNT) shl 16) or (Data.StrideLength and BCM2708_DMA_MAX_X_LENGTH);
   
   {Set Source and Dest Stride}
   Block.ModeStide:=((Data.DestStride and BCM2708_DMA_MAX_STRIDE) shl 16) or (Data.SourceStride and BCM2708_DMA_MAX_STRIDE);
  end;  
 
 {Setup Transfer Information}
 {Source Data Request}
 if (Data.Flags and DMA_DATA_FLAG_SOURCE_DREQ) <> 0 then
  begin
   Block.TransferInformation:=Block.TransferInformation or BCM2835_DMA_TI_WAIT_RESP or BCM2835_DMA_TI_SRC_DREQ;
  end;
 {Dest Data Request} 
 if (Data.Flags and DMA_DATA_FLAG_DEST_DREQ) <> 0 then
  begin
   Block.TransferInformation:=Block.TransferInformation or BCM2835_DMA_TI_WAIT_RESP or BCM2835_DMA_TI_DEST_DREQ;
  end;
 {Source Increment} 
 if (Data.Flags and DMA_DATA_FLAG_SOURCE_NOINCREMENT) = 0 then
  begin
   Block.TransferInformation:=Block.TransferInformation or BCM2835_DMA_TI_SRC_INC;
  end;
 {Dest Increment} 
 if (Data.Flags and DMA_DATA_FLAG_DEST_NOINCREMENT) = 0 then
  begin
   Block.TransferInformation:=Block.TransferInformation or BCM2835_DMA_TI_DEST_INC;
  end;
 {Source Width}
 if (Data.Flags and DMA_DATA_FLAG_SOURCE_WIDE) <> 0 then
  begin
   Block.TransferInformation:=Block.TransferInformation or BCM2835_DMA_TI_SRC_WIDTH;
  end;
 {Dest Width}
 if (Data.Flags and DMA_DATA_FLAG_DEST_WIDE) <> 0 then
  begin
   Block.TransferInformation:=Block.TransferInformation or BCM2835_DMA_TI_DEST_WIDTH;
  end;
 {Source Ignore}
 if (Data.Flags and DMA_DATA_FLAG_NOREAD) <> 0 then
  begin
   Block.TransferInformation:=Block.TransferInformation or BCM2835_DMA_TI_SRC_IGNORE;
  end;
 {Dest Ignore}
 if (Data.Flags and DMA_DATA_FLAG_NOWRITE) <> 0 then
  begin
   Block.TransferInformation:=Block.TransferInformation or BCM2835_DMA_TI_DEST_IGNORE;
  end;
 {Peripheral Map}
 if Request.Peripheral <> DMA_DREQ_ID_NONE then
  begin
   Block.TransferInformation:=Block.TransferInformation or (BCM2708DMAPeripheralToDREQ(Request.Peripheral) shl BCM2835_DMA_TI_PERMAP_SHIFT);
  end; 
 {Burst Length}
 if Bulk then
  begin
   Block.TransferInformation:=Block.TransferInformation or (BCM2708_DMA_BULK_BURST_LENGTH shl BCM2835_DMA_TI_BURST_LENGTH_SHIFT);
  end
 else if Lite then
  begin
   Block.TransferInformation:=Block.TransferInformation or (BCM2708_DMA_LITE_BURST_LENGTH shl BCM2835_DMA_TI_BURST_LENGTH_SHIFT);
  end
 else
  begin
   Block.TransferInformation:=Block.TransferInformation or (BCM2708_DMA_NORMAL_BURST_LENGTH shl BCM2835_DMA_TI_BURST_LENGTH_SHIFT);
  end;  
 {Interrupt Enable}
 if Data.Next = nil then
  begin
   Block.TransferInformation:=Block.TransferInformation or BCM2835_DMA_TI_INTEN;
  end;
 
 {Setup Next Control Block}
 if Data.Next <> nil then
  begin
   {Set Next Block}
   if BCM2708DMA_BUS_ADDRESSES then
    begin
     Block.NextControlBlockAddress:=PhysicalToBusAddress(Pointer(LongWord(Block) + SizeOf(TBCM2835DMAControlBlock)));
    end
   else
    begin
     Block.NextControlBlockAddress:=LongWord(Block) + SizeOf(TBCM2835DMAControlBlock);
    end;
  end
 else
  begin
   Block.NextControlBlockAddress:=0;
  end;  
  
 {Setup Reserved} 
 Block.Reserved1:=0;
 Block.Reserved2:=0;
 
 {Flush Source} 
 case Request.Direction of
  DMA_DIR_MEM_TO_MEM,DMA_DIR_MEM_TO_DEV:begin
    if not(BCM2708DMA_CACHE_COHERENT) and ((Data.Flags and DMA_DATA_FLAG_NOCLEAN) = 0) then
     begin
      if ((Data.Flags and DMA_DATA_FLAG_STRIDE) = 0) or (Data.SourceStride = 0) then
       begin
        CleanDataCacheRange(LongWord(Data.Source),Data.Size);
       end
      else
       begin
        Offset:=0;
        while Offset < Data.Size do
         begin
          CleanDataCacheRange(LongWord(Data.Source + Offset),Data.StrideLength);
          
          Inc(Offset,Data.SourceStride);
         end; 
       end;
     end;
   end;
 end;  
end;

{==============================================================================}
{==============================================================================}
{BCM2708 PWM Functions}

{==============================================================================}
{==============================================================================}
{BCM2708 PCM Functions}

{==============================================================================}
{==============================================================================}
{BCM2708 GPIO Functions}

{==============================================================================}
{==============================================================================}
{BCM2708 UART Functions}

{==============================================================================}
{==============================================================================}
{BCM2708 SDHCI Functions}
function BCM2708SDHCIHostStart(SDHCI:PSDHCIHost):LongWord;
var
 Status:LongWord;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check SDHCI}
 if SDHCI = nil then Exit;
 
 if MMC_LOG_ENABLED then MMCLogInfo(nil,'SDHCI BCM2708 Powering on Arasan SD Host Controller');

 {Power On SD}
 Status:=PowerOn(POWER_ID_MMC0);
 if Status <> ERROR_SUCCESS then
  begin
   if MMC_LOG_ENABLED then MMCLogError(nil,'SDHCI BCM2708 Failed to power on Arasan SD Host Controller');
   
   Result:=Status;
   Exit;
  end;
 
 {Update SDHCI}
 {Driver Properties}
 if BCM2708SDHCI_FIQ_ENABLED then
  begin
   SDHCI.Wait:=SemaphoreCreateEx(0,SEMAPHORE_DEFAULT_MAXIMUM,SEMAPHORE_FLAG_IRQFIQ);
  end
 else
  begin
   SDHCI.Wait:=SemaphoreCreateEx(0,SEMAPHORE_DEFAULT_MAXIMUM,SEMAPHORE_FLAG_IRQ);
  end;  
 SDHCI.Version:=SDHCIHostReadWord(SDHCI,SDHCI_HOST_VERSION);
 SDHCI.Quirks:=SDHCI_QUIRK_NO_HISPD_BIT or SDHCI_QUIRK_MISSING_CAPS;  //To Do //More ?
 SDHCI.Quirks2:=SDHCI_QUIRK2_BROKEN_R1B or SDHCI_QUIRK2_WAIT_SEND_CMD;
 {Configuration Properties}
 SDHCI.PresetVoltages:=MMC_VDD_32_33 or MMC_VDD_33_34 or MMC_VDD_165_195;
 SDHCI.PresetCapabilities:=0;   //To Do //See: Linux ?
 SDHCI.ClockMinimum:=BCM2708_EMMC_MIN_FREQ;
 SDHCI.ClockMaximum:=BCM2708_EMMC_MAX_FREQ; //To Do //Get from somewhere //See above
 
 {$IF DEFINED(BCM2708_DEBUG) or DEFINED(MMC_DEBUG)}
 if MMC_LOG_ENABLED then MMCLogDebug(nil,'SDHCI BCM2708 host version = ' + IntToHex(SDHCIGetVersion(SDHCI),4));
 {$ENDIF}
 
 {Update BCM2708}
 PBCM2708SDHCIHost(SDHCI).WriteDelay:=((2 * 1000000) div BCM2708_EMMC_MIN_FREQ) + 1;  //To Do //Get sdhci-bcm2708.emmc_clock_freq from command line (or get from Mailbox Properties ?) //No, probably command line is best. Platform startup can get from Mailbox and place in command line //see above
 PBCM2708SDHCIHost(SDHCI).LastWrite:=0;
 
 {$IF DEFINED(BCM2708_DEBUG) or DEFINED(MMC_DEBUG)}
 if MMC_LOG_ENABLED then MMCLogDebug(nil,'SDHCI BCM2708 host write delay =  ' + IntToStr(PBCM2708SDHCIHost(SDHCI).WriteDelay));
 {$ENDIF}
 
 {Reset Host}
 SDHCIHostReset(SDHCI,SDHCI_RESET_ALL);
 
 {$IF DEFINED(BCM2708_DEBUG) or DEFINED(MMC_DEBUG)}
 if MMC_LOG_ENABLED then MMCLogDebug(nil,'SDHCI BCM2708 host reset completed');
 {$ENDIF}
 
 {Setup Interrupts}
 Result:=BCM2708SDHCISetupInterrupts(SDHCI);
 
 //See: bcm2835_sdhci_init in bcm2835_sdhci.c
end;

{==============================================================================}

function BCM2708SDHCIHostStop(SDHCI:PSDHCIHost):LongWord;
var
 Status:LongWord;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check SDHCI}
 if SDHCI = nil then Exit;

 {Release the IRQ/FIQ}
 if BCM2708SDHCI_FIQ_ENABLED then
  begin
   ReleaseFIQ(FIQ_ROUTING,BCM2835_IRQ_SDHCI,TInterruptHandler(BCM2708SDHCIInterruptHandler),SDHCI);
  end
 else
  begin
   ReleaseIRQ(IRQ_ROUTING,BCM2835_IRQ_SDHCI,TInterruptHandler(BCM2708SDHCIInterruptHandler),SDHCI);
  end;  
 
 {Clear Interrupts}
 SDHCI.Interrupts:=0;
 
 {Reset Host}
 SDHCIHostReset(SDHCI,SDHCI_RESET_ALL);
 
 {$IF DEFINED(BCM2708_DEBUG) or DEFINED(MMC_DEBUG)}
 if MMC_LOG_ENABLED then MMCLogDebug(nil,'SDHCI BCM2708 host reset completed');
 {$ENDIF}
 
 {Update SDHCI}
 {Driver Properties}
 SemaphoreDestroy(SDHCI.Wait);
 SDHCI.Wait:=INVALID_HANDLE_VALUE;
 
 if MMC_LOG_ENABLED then MMCLogInfo(nil,'SDHCI BCM2708 Powering off Arasan SD Host Controller');

 {Power Off SD}
 Status:=PowerOff(POWER_ID_MMC0);
 if Status <> ERROR_SUCCESS then
  begin
   if MMC_LOG_ENABLED then MMCLogError(nil,'SDHCI BCM2708 Failed to power off Arasan SD Host Controller');
   
   Result:=Status;
   Exit;
  end;
  
 Result:=ERROR_SUCCESS;
end;

{==============================================================================}

function BCM2708SDHCIHostReadByte(SDHCI:PSDHCIHost;Reg:LongWord):Byte; 
{Note: The Broadcom document BCM2835-ARM-Peripherals page 66 states the following:

 Contrary to Arasans documentation the EMMC module registers can only be accessed as
 32 bit registers, i.e. the two LSBs of the address are always zero.

 For this reason this code must simulate Byte and Word reads using LongWord reads.
}
var
 Value:LongWord;
 ByteNo:LongWord;
 ByteShift:LongWord;
begin
 {}
 {Read LongWord}
 Value:=PLongWord(PtrUInt(SDHCI.Address) + PtrUInt(Reg and not(3)))^;
 
 {Memory Barrier}
 DataMemoryBarrier; {After the Last Read} 
 
 {Get Byte and Shift}
 ByteNo:=(Reg and 3);
 ByteShift:=(ByteNo shl 3);
 
 {Get Result}
 Result:=(Value shr ByteShift) and $FF;

 //See: bcm2835_sdhci_readb in bcm2835_sdhci.c
end;

{==============================================================================}

function BCM2708SDHCIHostReadWord(SDHCI:PSDHCIHost;Reg:LongWord):Word; 
{Note: The Broadcom document BCM2835-ARM-Peripherals page 66 states the following:

 Contrary to Arasans documentation the EMMC module registers can only be accessed as
 32 bit registers, i.e. the two LSBs of the address are always zero.

 For this reason this code must simulate Byte and Word reads using LongWord reads.
}
var
 Value:LongWord;
 WordNo:LongWord;
 WordShift:LongWord;
begin
 {}
 {Read LongWord}
 Value:=PLongWord(PtrUInt(SDHCI.Address) + PtrUInt(Reg and not(3)))^;
 
 {Memory Barrier}
 DataMemoryBarrier; {After the Last Read} 
 
 {Get Word and Shift}
 WordNo:=((Reg shr 1) and 1);
 WordShift:=(WordNo shl 4);
 
 {Get Result}
 Result:=(Value shr WordShift) and $FFFF;

 //See: bcm2835_sdhci_readw in bcm2835_sdhci.c
end;

{==============================================================================}

function BCM2708SDHCIHostReadLong(SDHCI:PSDHCIHost;Reg:LongWord):LongWord; 
begin
 {}
 {Read LongWord}
 Result:=PLongWord(PtrUInt(SDHCI.Address) + PtrUInt(Reg))^;
 
 {Memory Barrier}
 DataMemoryBarrier; {After the Last Read} 
 
 //See: bcm2835_sdhci_raw_readl in bcm2835_sdhci.c
 //     bcm2835_sdhci_readl in bcm2835_sdhci.c
end;

{==============================================================================}

procedure BCM2708SDHCIHostWriteByte(SDHCI:PSDHCIHost;Reg:LongWord;Value:Byte); 
{Note: The Broadcom document BCM2835-ARM-Peripherals page 66 states the following:

 Contrary to Arasans documentation the EMMC module registers can only be accessed as
 32 bit registers, i.e. the two LSBs of the address are always zero.

 For this reason this code must simulate Byte and Word writes using LongWord writes.
}
var
 Mask:LongWord;
 ByteNo:LongWord;
 ByteShift:LongWord;
 OldValue:LongWord;
 NewValue:LongWord;
begin
 {}
 {Read LongWord}
 OldValue:=PLongWord(PtrUInt(SDHCI.Address) + PtrUInt(Reg and not(3)))^;
 
 {Memory Barrier}
 DataMemoryBarrier;{After the Last Read} 
 
 {Get Byte, Shift and Mask}
 ByteNo:=(Reg and 3);
 ByteShift:=(ByteNo shl 3);
 Mask:=($FF shl ByteShift);

 {Get Value}
 NewValue:=(OldValue and not(Mask)) or (Value shl ByteShift);
 
 {Write LongWord}
 BCM2708SDHCIHostWriteLong(SDHCI,Reg and not(3),NewValue);

 //See: bcm2835_sdhci_writeb in bcm2835_sdhci.c
end;

{==============================================================================}

procedure BCM2708SDHCIHostWriteWord(SDHCI:PSDHCIHost;Reg:LongWord;Value:Word); 
{Note: The Broadcom document BCM2835-ARM-Peripherals page 66 states the following:

 Contrary to Arasans documentation the EMMC module registers can only be accessed as
 32 bit registers, i.e. the two LSBs of the address are always zero.

 For this reason this code must simulate Byte and Word writes using LongWord writes.
}
var
 Mask:LongWord;
 WordNo:LongWord;
 WordShift:LongWord;
 OldValue:LongWord;
 NewValue:LongWord;
begin
 {}
 {Check Register}
 if Reg = SDHCI_COMMAND then
  begin
   {Get LongWord}
   OldValue:=PBCM2708SDHCIHost(SDHCI).ShadowRegister;
  end
 else
  begin
   {Read LongWord}
   OldValue:=PLongWord(PtrUInt(SDHCI.Address) + PtrUInt(Reg and not(3)))^;
   
   {Memory Barrier}
   DataMemoryBarrier; {After the Last Read} 
  end;

 {Get Word, Shift and Mask}
 WordNo:=((Reg shr 1) and 1);
 WordShift:=(WordNo shl 4); 
 Mask:=($FFFF shl WordShift);

 {Get Value}
 NewValue:=(OldValue and not(Mask)) or (Value shl WordShift);

 {Check Register}
 if Reg = SDHCI_TRANSFER_MODE then
  begin
   {Save LongWord}
   PBCM2708SDHCIHost(SDHCI).ShadowRegister:=NewValue;
  end
 else
  begin
   {Write LongWord}
   BCM2708SDHCIHostWriteLong(SDHCI,Reg and not(3),NewValue);
  end;  
  
 //See: bcm2835_sdhci_writew in bcm2835_sdhci.c
end;

{==============================================================================}

procedure BCM2708SDHCIHostWriteLong(SDHCI:PSDHCIHost;Reg:LongWord;Value:LongWord); 
{Note: The source code of U-Boot and Linux kernel drivers have this comment

 The Arasan has a bugette whereby it may lose the content of
 successive writes to registers that are within two SD-card clock
 cycles of each other (a clock domain crossing problem).
 It seems, however, that the data register does not have this problem.
 (Which is just as well - otherwise we'd have to nobble the DMA engine too)
 
 For this reason this code must delay after each write to the registers.
}
begin
 {}
 {Memory Barrier}
 DataMemoryBarrier; {Before the First Write}
 
 {Write LongWord}
 PLongWord(PtrUInt(SDHCI.Address) + PtrUInt(Reg))^:=Value;
 
 {Wait Delay}
 MicrosecondDelay(PBCM2708SDHCIHost(SDHCI).WriteDelay);
 
 //To Do //Need GetTimerMicroseconds() in Platform (with a Since value as a Parameter ?) //Then use the LastWrite value in SDHCI
         //Also add GetTimerMilliseconds() in Platform as well
               
 //See: bcm2835_sdhci_raw_writel in bcm2835_sdhci.c
 //     bcm2835_sdhci_writel in bcm2835_sdhci.c
end;

{==============================================================================}

procedure BCM2708SDHCIInterruptHandler(SDHCI:PSDHCIHost);
var
 Count:Integer;
 Present:Boolean;
 InterruptMask:LongWord;
 UnexpectedMask:LongWord;
 AcknowledgeMask:LongWord;
begin
 {}
 {Check SDHCI}
 if SDHCI = nil then Exit;
 
 {Update Statistics}
 Inc(SDHCI.InterruptCount); 
 
 {$IF (DEFINED(BCM2708_DEBUG) or DEFINED(MMC_DEBUG)) and DEFINED(INTERRUPT_DEBUG)}
 if MMC_LOG_ENABLED then MMCLogDebug(nil,'SDHCI BCM2708 Interrupt Handler');
 {$ENDIF}
 
 {Get Interrupt Mask}
 InterruptMask:=SDHCIHostReadLong(SDHCI,SDHCI_INT_STATUS);

 {$IF (DEFINED(BCM2708_DEBUG) or DEFINED(MMC_DEBUG)) and DEFINED(INTERRUPT_DEBUG)}
 if MMC_LOG_ENABLED then MMCLogDebug(nil,'SDHCI BCM2708 Interrupt Handler (InterruptMask=' + IntToHex(InterruptMask,8) + ')');
 {$ENDIF}
 
 {Check for No Interrupts}
 if (InterruptMask = 0) or (InterruptMask = $FFFFFFFF) then Exit;

 Count:=16;
 UnexpectedMask:=0;
 while InterruptMask <> 0 do
  begin
   {Clear selected interrupts}
   AcknowledgeMask:=(InterruptMask and (SDHCI_INT_CMD_MASK or SDHCI_INT_DATA_MASK or SDHCI_INT_BUS_POWER));
   SDHCIHostWriteLong(SDHCI,SDHCI_INT_STATUS,AcknowledgeMask);
   
   {$IF (DEFINED(BCM2708_DEBUG) or DEFINED(MMC_DEBUG)) and DEFINED(INTERRUPT_DEBUG)}
   if MMC_LOG_ENABLED then MMCLogDebug(nil,'SDHCI BCM2708 Interrupt Handler (AcknowledgeMask=' + IntToHex(AcknowledgeMask,8) + ')');
   {$ENDIF}
   
   {Check for insert / remove interrupts}
   if (InterruptMask and (SDHCI_INT_CARD_INSERT or SDHCI_INT_CARD_REMOVE)) <> 0 then
    begin
     {$IF (DEFINED(BCM2708_DEBUG) or DEFINED(MMC_DEBUG)) and DEFINED(INTERRUPT_DEBUG)}
     if MMC_LOG_ENABLED then MMCLogDebug(nil,'SDHCI BCM2708 Insert / Remove Interrupt (InterruptMask=' + IntToHex(InterruptMask,8) + ')');
     {$ENDIF}
     
     {There is a observation on i.mx esdhc. INSERT bit will be immediately set again when it gets cleared, if a card is inserted.
      We have to mask the irq to prevent interrupt storm which will freeze the system. And the REMOVE gets the same situation.
	
      More testing are needed here to ensure it works for other platforms though}
      
     {Get Card Present}
     Present:=(SDHCIHostReadLong(SDHCI,SDHCI_PRESENT_STATE) and SDHCI_CARD_PRESENT) <> 0;
     
     {Disable insert / remove interrupts}
     SDHCI.Interrupts:=SDHCI.Interrupts and not(SDHCI_INT_CARD_INSERT or SDHCI_INT_CARD_REMOVE);
     
     {Enable insert / remove depending on presence}
     if Present then SDHCI.Interrupts:=SDHCI.Interrupts or SDHCI_INT_CARD_REMOVE;
     if not(Present) then SDHCI.Interrupts:=SDHCI.Interrupts or SDHCI_INT_CARD_INSERT;
     
     {Update interrupts}
	 SDHCIHostWriteLong(SDHCI,SDHCI_INT_ENABLE,SDHCI.Interrupts);
	 SDHCIHostWriteLong(SDHCI,SDHCI_SIGNAL_ENABLE,SDHCI.Interrupts);
     
     {Acknowledge interrupts}
     SDHCIHostWriteLong(SDHCI,SDHCI_INT_STATUS,InterruptMask and (SDHCI_INT_CARD_INSERT or SDHCI_INT_CARD_REMOVE));
                     
     {Signal insert or remove}
     //To Do //Needs an MMC Thread for Insert/Remove Handling and Polling Card Detect (Timer/Worker possibly ?)
    end;
    
   {Check for command iterrupts}
   if (InterruptMask and SDHCI_INT_CMD_MASK) <> 0 then
    begin
     {$IF (DEFINED(BCM2708_DEBUG) or DEFINED(MMC_DEBUG)) and DEFINED(INTERRUPT_DEBUG)}
     if MMC_LOG_ENABLED then MMCLogDebug(nil,'SDHCI BCM2708 Command Interrupt (InterruptMask=' + IntToHex(InterruptMask,8) + ')');
     {$ENDIF}
     
     SDHCIHostCommandInterrupt(SDHCI,InterruptMask and SDHCI_INT_CMD_MASK,InterruptMask);
    end;
    
   {Check for data interrupts} 
   if (InterruptMask and SDHCI_INT_DATA_MASK) <> 0 then
    begin
     {$IF (DEFINED(BCM2708_DEBUG) or DEFINED(MMC_DEBUG)) and DEFINED(INTERRUPT_DEBUG)}
     if MMC_LOG_ENABLED then MMCLogDebug(nil,'SDHCI BCM2708 Data Interrupt (InterruptMask=' + IntToHex(InterruptMask,8) + ')');
     {$ENDIF}
     
     SDHCIHostDataInterrupt(SDHCI,InterruptMask and SDHCI_INT_DATA_MASK);
    end;
   
   {Check for bus power interrupt}
   if (InterruptMask and SDHCI_INT_BUS_POWER) <> 0 then
    begin
     {$IF (DEFINED(BCM2708_DEBUG) or DEFINED(MMC_DEBUG)) and DEFINED(INTERRUPT_DEBUG)}
     if MMC_LOG_ENABLED then MMCLogDebug(nil,'SDHCI BCM2708 Bus Power Interrupt (InterruptMask=' + IntToHex(InterruptMask,8) + ')');
     {$ENDIF}
     
     //To Do //Log Error
    end;
 
   {Check for card interrupt}
   if (InterruptMask and SDHCI_INT_CARD_INT) <> 0 then
    begin
     {$IF (DEFINED(BCM2708_DEBUG) or DEFINED(MMC_DEBUG)) and DEFINED(INTERRUPT_DEBUG)}
     if MMC_LOG_ENABLED then MMCLogDebug(nil,'SDHCI BCM2708 Card Interrupt (InterruptMask=' + IntToHex(InterruptMask,8) + ')');
     {$ENDIF}
     
     //To Do //Signal another thread ? //Is this only for SDIO ?
    end;
   
   {Check for unexpected interrupts}
   InterruptMask:=InterruptMask and not(SDHCI_INT_CARD_INSERT or SDHCI_INT_CARD_REMOVE or SDHCI_INT_CMD_MASK or SDHCI_INT_DATA_MASK or SDHCI_INT_ERROR or SDHCI_INT_BUS_POWER or SDHCI_INT_CARD_INT);
   if InterruptMask <> 0 then
    begin
     UnexpectedMask:=UnexpectedMask or InterruptMask;
     SDHCIHostWriteLong(SDHCI,SDHCI_INT_STATUS,InterruptMask);
    end;
    
   {Check Count}
   Dec(Count);
   if Count <= 0 then Break;
   
   {Get Interrupt Mask}
   InterruptMask:=SDHCIHostReadLong(SDHCI,SDHCI_INT_STATUS);
  end;

 if UnexpectedMask <> 0 then
  begin
   {$IF (DEFINED(BCM2708_DEBUG) or DEFINED(MMC_DEBUG)) and DEFINED(INTERRUPT_DEBUG)}
   if MMC_LOG_ENABLED then MMCLogDebug(nil,'SDHCI BCM2708 Unexpected Interrupt (UnexpectedMask=' + IntToHex(UnexpectedMask,8) + ')');
   {$ENDIF}
   
   //To Do //Log Error
  end;
  
 {$IF (DEFINED(BCM2708_DEBUG) or DEFINED(MMC_DEBUG)) and DEFINED(INTERRUPT_DEBUG)}
 if MMC_LOG_ENABLED then MMCLogDebug(nil,'SDHCI BCM2708 Interrupt Handler completed');
 {$ENDIF}
  
 //See: bcm2835_mmc_irq in \linux-rpi-3.18.y\drivers\mmc\host\bcm2835-mmc.c
end;

{==============================================================================}

function BCM2708SDHCISetupInterrupts(SDHCI:PSDHCIHost):LongWord;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check SDHCI}
 if SDHCI = nil then Exit;
 
 {Setup Interrupts}
 SDHCI.Interrupts:=SDHCI_INT_BUS_POWER or SDHCI_INT_DATA_END_BIT or SDHCI_INT_DATA_CRC or SDHCI_INT_DATA_TIMEOUT or SDHCI_INT_INDEX or SDHCI_INT_END_BIT or SDHCI_INT_CRC or SDHCI_INT_TIMEOUT or SDHCI_INT_DATA_END or SDHCI_INT_RESPONSE;
                   //SDHCI_INT_CARD_INSERT or SDHCI_INT_CARD_REMOVE or //See sdhci_set_card_detection in \linux-rpi-3.18.y\drivers\mmc\host\sdhci.c
                   //Note: SDHCI_INT_CARD_INSERT seems to hang everything, why? //Because the SDHCI_CARD_PRESENT bit is never updated !
                   
 {Enable Interrupts}
 SDHCIHostWriteLong(SDHCI,SDHCI_INT_ENABLE,SDHCI.Interrupts);
 SDHCIHostWriteLong(SDHCI,SDHCI_SIGNAL_ENABLE,SDHCI.Interrupts);

 {Request the IRQ/FIQ} 
 if BCM2708SDHCI_FIQ_ENABLED then
  begin
   RequestFIQ(FIQ_ROUTING,BCM2835_IRQ_SDHCI,TInterruptHandler(BCM2708SDHCIInterruptHandler),SDHCI);
  end
 else
  begin
   RequestIRQ(IRQ_ROUTING,BCM2835_IRQ_SDHCI,TInterruptHandler(BCM2708SDHCIInterruptHandler),SDHCI);
  end;  
 
 {Return Result}
 Result:=ERROR_SUCCESS;
 
 //See: \linux-rpi-3.18.y\drivers\mmc\host\bcm2835-mmc.c
end;
 
{==============================================================================}
 
function BCM2708MMCDeviceGetCardDetect(MMC:PMMCDevice):LongWord;
{Implementation of MMC GetCardDetect for the BCM2708 which does not update the
 bits in the SDHCI_PRESENT_STATE register to reflect card insertion or removal}
var
 SDHCI:PSDHCIHost;
begin
 {}
 Result:=MMC_STATUS_INVALID_PARAMETER;
 
 {Check MMC}
 if MMC = nil then Exit;
 
 {$IF DEFINED(BCM2708_DEBUG) or DEFINED(MMC_DEBUG)}
 if MMC_LOG_ENABLED then MMCLogDebug(nil,'MMC BCM2708 Get Card Detect');
 {$ENDIF}
 
 {Get SDHCI}
 SDHCI:=PSDHCIHost(MMC.Device.DeviceData);
 if SDHCI = nil then Exit;
 
 {$IF DEFINED(BCM2708_DEBUG) or DEFINED(MMC_DEBUG)}
 if MMC_LOG_ENABLED then MMCLogDebug(nil,'MMC BCM2708 Get Card Detect (SDHCI_PRESENT_STATE=' + IntToHex(SDHCIHostReadLong(SDHCI,SDHCI_PRESENT_STATE),8) + ')');
 {$ENDIF}
 
 {Check MMC State}
 if MMC.MMCState = MMC_STATE_INSERTED then
  begin
   {Get Card Status}
   if MMCDeviceSendCardStatus(MMC) <> MMC_STATUS_SUCCESS then
    begin
     {Update Flags}
     MMC.Device.DeviceFlags:=MMC.Device.DeviceFlags and not(MMC_FLAG_CARD_PRESENT);
     
     {Reset Host}
     SDHCIHostReset(SDHCI,SDHCI_RESET_ALL);

     {$IF DEFINED(BCM2708_DEBUG) or DEFINED(MMC_DEBUG)}
     if MMC_LOG_ENABLED then MMCLogDebug(nil,'MMC BCM2708 Get Card Detect (Flags=not MMC_FLAG_CARD_PRESENT)');
     {$ENDIF}
    end;
  end
 else
  begin
   {Get Card Present}
   if (SDHCIHostReadLong(SDHCI,SDHCI_PRESENT_STATE) and SDHCI_CARD_PRESENT) <> 0 then
    begin
     {Update Flags}
     MMC.Device.DeviceFlags:=(MMC.Device.DeviceFlags or MMC_FLAG_CARD_PRESENT);
     
     {$IF DEFINED(BCM2708_DEBUG) or DEFINED(MMC_DEBUG)}
     if MMC_LOG_ENABLED then MMCLogDebug(nil,'MMC BCM2708 Get Card Detect (Flags=MMC_FLAG_CARD_PRESENT)');
     {$ENDIF}
    end
   else
    begin
     {Update Flags}
     MMC.Device.DeviceFlags:=MMC.Device.DeviceFlags and not(MMC_FLAG_CARD_PRESENT);
     
     {$IF DEFINED(BCM2708_DEBUG) or DEFINED(MMC_DEBUG)}
     if MMC_LOG_ENABLED then MMCLogDebug(nil,'MMC BCM2708 Get Card Detect (Flags=not MMC_FLAG_CARD_PRESENT)');
     {$ENDIF}
    end;    
  end;

 Result:=MMC_STATUS_SUCCESS;  
end;
 
{==============================================================================}
{==============================================================================}
{BCM2708 Clock Functions}
function BCM2708ClockRead(Clock:PClockDevice):LongWord;
begin
 {}
 Result:=0;
 
 {Check Clock}
 if Clock = nil then Exit;
 if Clock.Address = nil then Exit;

 if MutexLock(Clock.Lock) <> ERROR_SUCCESS then Exit;
 
 {Read Clock}
 Result:=PBCM2835SystemTimerRegisters(Clock.Address).CLO;
 
 {Memory Barrier}
 DataMemoryBarrier; {After the Last Read}
 
 {Update Statistics}
 Inc(Clock.ReadCount);
 
 MutexUnlock(Clock.Lock);
end;
 
{==============================================================================}

function BCM2708ClockRead64(Clock:PClockDevice):Int64;
var
 Check:LongWord;
begin
 {}
 Result:=0;
 
 {Check Clock}
 if Clock = nil then Exit;
 if Clock.Address = nil then Exit;
 
 if MutexLock(Clock.Lock) <> ERROR_SUCCESS then Exit;
 
 {Get High Value}
 Int64Rec(Result).Hi:=PBCM2835SystemTimerRegisters(Clock.Address).CHI;
 
 {Get Low Value}
 Int64Rec(Result).Lo:=PBCM2835SystemTimerRegisters(Clock.Address).CLO;
 
 {Check High Value}
 Check:=PBCM2835SystemTimerRegisters(Clock.Address).CHI;
 if Check <> Int64Rec(Result).Hi then
  begin
   {Rollover Occurred, Get Low Value Again}
   Int64Rec(Result).Hi:=Check;
   Int64Rec(Result).Lo:=PBCM2835SystemTimerRegisters(Clock.Address).CLO;
  end;
 
 {Memory Barrier}
 DataMemoryBarrier; {After the Last Read}
 
 {Update Statistics}
 Inc(Clock.ReadCount);
 
 MutexUnlock(Clock.Lock);
end;

{==============================================================================}
{==============================================================================}
{BCM2708 Timer Functions}
 
{==============================================================================}
{==============================================================================}
{BCM2708 Random Functions}
function BCM2708RandomStart(Random:PRandomDevice):LongWord;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check Random}
 if Random = nil then Exit;
 if Random.Address = nil then Exit;
 
 if MutexLock(Random.Lock) = ERROR_SUCCESS then 
  begin
   try
    {Memory Barrier}
    DataMemoryBarrier; {Before the First Write}
  
    {Enable Random}
    PBCM2835RNGRegisters(Random.Address).Status:=BCM2708_RANDOM_WARMUP_COUNT;
    PBCM2835RNGRegisters(Random.Address).Control:=BCM2835_RANDOM_ENABLE;
   
    Result:=ERROR_SUCCESS;
   finally
    MutexUnlock(Random.Lock);
   end; 
  end
 else
  begin
   Result:=ERROR_CAN_NOT_COMPLETE;
  end;
end;

{==============================================================================}

function BCM2708RandomStop(Random:PRandomDevice):LongWord;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check Random}
 if Random = nil then Exit;
 if Random.Address = nil then Exit;

 if MutexLock(Random.Lock) = ERROR_SUCCESS then 
  begin
   try
    {Memory Barrier}
    DataMemoryBarrier; {Before the First Write}
   
    {Disable Random}
    PBCM2835RNGRegisters(Random.Address).Control:=BCM2835_RANDOM_DISABLE;
   
    Result:=ERROR_SUCCESS;
   finally
    MutexUnlock(Random.Lock);
   end; 
  end
 else
  begin
   Result:=ERROR_CAN_NOT_COMPLETE;
  end;
end;
 
{==============================================================================}

function BCM2708RandomReadLongWord(Random:PRandomDevice):LongWord;
begin
 {}
 Result:=0;
 
 {Check Random}
 if Random = nil then Exit;
 if Random.Address = nil then Exit;
 
 if MutexLock(Random.Lock) <> ERROR_SUCCESS then Exit;
 
 {Check Status}
 while (PBCM2835RNGRegisters(Random.Address).Status shr 24) = 0 do
  begin
   ThreadSleep(0);
  end;
  
 {Read Random}
 Result:=PBCM2835RNGRegisters(Random.Address).Data; 

 {Memory Barrier}
 DataMemoryBarrier; {After the Last Read} 
 
 {Update Statistics}
 Inc(Random.ReadCount);
 
 MutexUnlock(Random.Lock);
end;

{==============================================================================}
{==============================================================================}
{BCM2708 Mailbox Functions}

{==============================================================================}
{==============================================================================}
{BCM2708 Watchdog Functions}
function BCM2708WatchdogStart(Watchdog:PWatchdogDevice):LongWord;
var
 Current:LongWord;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check Watchdog}
 if Watchdog = nil then Exit;
 if Watchdog.Address = nil then Exit;
 
 if MutexLock(Watchdog.Lock) = ERROR_SUCCESS then 
  begin
   try
    {Check Timeout}
    Result:=ERROR_NOT_SUPPORTED;
    if Watchdog.Timeout = 0 then Exit;
 
    {Memory Barrier}
    DataMemoryBarrier; {Before the First Write}
 
    {Enable Watchdog}
    PBCM2835PMWatchdogRegisters(Watchdog.Address).WDOG:=BCM2835_PM_PASSWORD or ((Watchdog.Timeout * BCM2835_PM_WDOG_TICKS_PER_MILLISECOND) and BCM2835_PM_WDOG_TIME_MASK);
    
    Current:=PBCM2835PMWatchdogRegisters(Watchdog.Address).RSTC;
    
    PBCM2835PMWatchdogRegisters(Watchdog.Address).RSTC:=BCM2835_PM_PASSWORD or (Current and BCM2835_PM_RSTC_WRCFG_CLR) or BCM2835_PM_RSTC_WRCFG_FULL_RESET;

    {Memory Barrier}
    DataMemoryBarrier; {After the Last Read} 
    
    {Update Statistics}
    Inc(Watchdog.StartCount);
    
    Result:=ERROR_SUCCESS;
   finally
    MutexUnlock(Watchdog.Lock);
   end; 
  end
 else
  begin
   Result:=ERROR_CAN_NOT_COMPLETE;
  end;
end;

{==============================================================================}

function BCM2708WatchdogStop(Watchdog:PWatchdogDevice):LongWord;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check Watchdog}
 if Watchdog = nil then Exit;
 if Watchdog.Address = nil then Exit;
 
 if MutexLock(Watchdog.Lock) = ERROR_SUCCESS then 
  begin
   try
    {Memory Barrier}
    DataMemoryBarrier; {Before the First Write}
 
    {Disable Watchdog}
    PBCM2835PMWatchdogRegisters(Watchdog.Address).RSTC:=BCM2835_PM_PASSWORD or BCM2835_PM_RSTC_RESET;
    
    {Update Statistics}
    Inc(Watchdog.StopCount);
    
    Result:=ERROR_SUCCESS;
   finally
    MutexUnlock(Watchdog.Lock);
   end; 
  end
 else
  begin
   Result:=ERROR_CAN_NOT_COMPLETE;
  end;
end;

{==============================================================================}

function BCM2708WatchdogRefresh(Watchdog:PWatchdogDevice):LongWord;
var
 Current:LongWord;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check Watchdog}
 if Watchdog = nil then Exit;
 if Watchdog.Address = nil then Exit;

 if MutexLock(Watchdog.Lock) = ERROR_SUCCESS then 
  begin
   try
    {Check Timeout}
    Result:=ERROR_NOT_SUPPORTED;
    if Watchdog.Timeout = 0 then Exit;

    {Memory Barrier}
    DataMemoryBarrier; {Before the First Write}
   
    {Refresh Watchdog}
    PBCM2835PMWatchdogRegisters(Watchdog.Address).WDOG:=BCM2835_PM_PASSWORD or ((Watchdog.Timeout * BCM2835_PM_WDOG_TICKS_PER_MILLISECOND) and BCM2835_PM_WDOG_TIME_MASK);
    
    Current:=PBCM2835PMWatchdogRegisters(Watchdog.Address).RSTC;
    
    PBCM2835PMWatchdogRegisters(Watchdog.Address).RSTC:=BCM2835_PM_PASSWORD or (Current and BCM2835_PM_RSTC_WRCFG_CLR) or BCM2835_PM_RSTC_WRCFG_FULL_RESET;

    {Memory Barrier}
    DataMemoryBarrier; {After the Last Read} 
 
    {Update Statistics}
    Inc(Watchdog.RefreshCount);

    Result:=ERROR_SUCCESS;
   finally
    MutexUnlock(Watchdog.Lock);
   end; 
  end
 else
  begin
   Result:=ERROR_CAN_NOT_COMPLETE;
  end;
end;

{==============================================================================}

function BCM2708WatchdogGetRemain(Watchdog:PWatchdogDevice):LongWord;
begin
 {}
 Result:=0;
 
 {Check Watchdog}
 if Watchdog = nil then Exit;
 if Watchdog.Address = nil then Exit;

 if MutexLock(Watchdog.Lock) = ERROR_SUCCESS then 
  begin
   try
    {Get Remain}
    Result:=(PBCM2835PMWatchdogRegisters(Watchdog.Address).WDOG and BCM2835_PM_WDOG_TIME_MASK) div BCM2835_PM_WDOG_TICKS_PER_MILLISECOND;

    {Memory Barrier}
    DataMemoryBarrier; {After the Last Read} 
   finally
    MutexUnlock(Watchdog.Lock);
   end; 
  end;
end;

{==============================================================================}
{==============================================================================}
{BCM2708 Framebuffer Functions}
function BCM2708FramebufferAllocate(Framebuffer:PFramebufferDevice;Properties:PFramebufferProperties):LongWord;
var
 Size:LongWord;
 Response:LongWord;
 Header:PBCM2835MailboxHeader;
 Footer:PBCM2835MailboxFooter;
 Defaults:TFramebufferProperties;
 Tag:PBCM2835MailboxTagCreateBuffer;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check Framebuffer}
 if Framebuffer = nil then Exit;
 if Framebuffer.Device.Signature <> DEVICE_SIGNATURE then Exit; 
 
 if MutexLock(Framebuffer.Lock) = ERROR_SUCCESS then 
  begin
   try
    {Check Properties}
    if Properties = nil then
     begin
      {Use Defaults}
      Defaults.Depth:=FRAMEBUFFER_DEFAULT_DEPTH;
      Defaults.Order:=FRAMEBUFFER_DEFAULT_ORDER;
      Defaults.Mode:=FRAMEBUFFER_DEFAULT_MODE;
      Defaults.PhysicalWidth:=FRAMEBUFFER_DEFAULT_WIDTH;
      Defaults.PhysicalHeight:=FRAMEBUFFER_DEFAULT_HEIGHT;
      Defaults.VirtualWidth:=FRAMEBUFFER_DEFAULT_WIDTH;
      Defaults.VirtualHeight:=FRAMEBUFFER_DEFAULT_HEIGHT;
      Defaults.OffsetX:=FRAMEBUFFER_DEFAULT_OFFSET_X;
      Defaults.OffsetY:=FRAMEBUFFER_DEFAULT_OFFSET_Y;
      Defaults.OverscanTop:=FRAMEBUFFER_DEFAULT_OVERSCAN_TOP;
      Defaults.OverscanBottom:=FRAMEBUFFER_DEFAULT_OVERSCAN_BOTTOM;
      Defaults.OverscanLeft:=FRAMEBUFFER_DEFAULT_OVERSCAN_LEFT;
      Defaults.OverscanRight:=FRAMEBUFFER_DEFAULT_OVERSCAN_RIGHT;
     end
    else
     begin
      {Use Properties}
      Defaults.Depth:=Properties.Depth;
      Defaults.Order:=Properties.Order;
      Defaults.Mode:=Properties.Mode;
      Defaults.PhysicalWidth:=Properties.PhysicalWidth;
      Defaults.PhysicalHeight:=Properties.PhysicalHeight;
      Defaults.VirtualWidth:=Properties.VirtualWidth;
      Defaults.VirtualHeight:=Properties.VirtualHeight;
      Defaults.OffsetX:=Properties.OffsetX;
      Defaults.OffsetY:=Properties.OffsetY;
      Defaults.OverscanTop:=Properties.OverscanTop;
      Defaults.OverscanBottom:=Properties.OverscanBottom;
      Defaults.OverscanLeft:=Properties.OverscanLeft;
      Defaults.OverscanRight:=Properties.OverscanRight;
     end;   

    {Check Defaults}
    if (Defaults.PhysicalWidth = 0) or (Defaults.PhysicalHeight = 0) then
     begin
      {Get Dimensions Width and Height}
      Result:=FramebufferGetDimensions(Defaults.PhysicalWidth,Defaults.PhysicalHeight,Defaults.OverscanTop,Defaults.OverscanBottom,Defaults.OverscanLeft,Defaults.OverscanRight);
      if Result <> ERROR_SUCCESS then
       begin
        if DEVICE_LOG_ENABLED then DeviceLogError(nil,'BCM2708: FramebufferAllocate - FramebufferGetDimensions failed: ' + ErrorToString(Result));
        {Exit;} {Do not fail}
        
        {Set Defaults}
        Defaults.PhysicalWidth:=640;
        Defaults.PhysicalHeight:=480;
       end;
      
      {Set Defaults}
      Defaults.VirtualWidth:=Defaults.PhysicalWidth;
      Defaults.VirtualHeight:=Defaults.PhysicalHeight;
     end;
    
    {Calculate Size}
    Size:=SizeOf(TBCM2835MailboxHeader) + SizeOf(TBCM2835MailboxTagCreateBuffer) + SizeOf(TBCM2835MailboxFooter);
    
    {Allocate Mailbox Buffer}
    Result:=ERROR_NOT_ENOUGH_MEMORY;
    Header:=GetSharedAlignedMem(Size,SIZE_16); {Must be 16 byte aligned}
    if Header = nil then Header:=GetAlignedMem(Size,SIZE_16); {Must be 16 byte aligned}
    if Header = nil then Exit;
    try
     {Clear Buffer}
     FillChar(Header^,Size,0);
    
     {Setup Header}
     Header.Size:=Size;
     Header.Code:=BCM2835_MBOX_REQUEST_CODE;
    
     {Setup Tag}
     Tag:=PBCM2835MailboxTagCreateBuffer(PtrUInt(Header) + PtrUInt(SizeOf(TBCM2835MailboxHeader)));
     
     {Setup Tag (Physical)}
     Tag.Physical.Header.Tag:=BCM2835_MBOX_TAG_SET_PHYSICAL_W_H;
     Tag.Physical.Header.Size:=SizeOf(TBCM2835MailboxTagSetPhysical) - SizeOf(TBCM2835MailboxTagHeader);
     Tag.Physical.Header.Length:=SizeOf(Tag.Physical.Request);
     Tag.Physical.Request.Width:=Defaults.PhysicalWidth;
     Tag.Physical.Request.Height:=Defaults.PhysicalHeight;
     
     {Setup Tag (Virtual)}
     Tag.Vertual.Header.Tag:=BCM2835_MBOX_TAG_SET_VIRTUAL_W_H;
     Tag.Vertual.Header.Size:=SizeOf(TBCM2835MailboxTagSetVirtual) - SizeOf(TBCM2835MailboxTagHeader);
     Tag.Vertual.Header.Length:=SizeOf(Tag.Vertual.Request);
     Tag.Vertual.Request.Width:=Defaults.VirtualWidth;
     Tag.Vertual.Request.Height:=Defaults.VirtualHeight;

     {Setup Tag (Depth)}
     Tag.Depth.Header.Tag:=BCM2835_MBOX_TAG_SET_DEPTH;
     Tag.Depth.Header.Size:=SizeOf(TBCM2835MailboxTagSetDepth) - SizeOf(TBCM2835MailboxTagHeader);
     Tag.Depth.Header.Length:=SizeOf(Tag.Depth.Request);
     Tag.Depth.Request.Depth:=Defaults.Depth;
     
     {Setup Tag (Order)}
     Tag.Order.Header.Tag:=BCM2835_MBOX_TAG_SET_PIXEL_ORDER;
     Tag.Order.Header.Size:=SizeOf(TBCM2835MailboxTagSetPixelOrder) - SizeOf(TBCM2835MailboxTagHeader);
     Tag.Order.Header.Length:=SizeOf(Tag.Order.Request);
     Tag.Order.Request.Order:=Defaults.Order;
     
     {Setup Tag (Mode)}
     Tag.Mode.Header.Tag:=BCM2835_MBOX_TAG_SET_ALPHA_MODE;
     Tag.Mode.Header.Size:=SizeOf(TBCM2835MailboxTagSetAlphaMode) - SizeOf(TBCM2835MailboxTagHeader);
     Tag.Mode.Header.Length:=SizeOf(Tag.Mode.Request);
     Tag.Mode.Request.Mode:=Defaults.Mode;
     
     {Setup Tag (Offset)}
     Tag.Offset.Header.Tag:=BCM2835_MBOX_TAG_SET_VIRTUAL_OFFSET;
     Tag.Offset.Header.Size:=SizeOf(TBCM2835MailboxTagSetVirtualOffset) - SizeOf(TBCM2835MailboxTagHeader);
     Tag.Offset.Header.Length:=SizeOf(Tag.Offset.Request);
     Tag.Offset.Request.X:=Defaults.OffsetX;
     Tag.Offset.Request.Y:=Defaults.OffsetY;
     
     {Setup Tag (Overscan)}
     Tag.Overscan.Header.Tag:=BCM2835_MBOX_TAG_SET_OVERSCAN;
     Tag.Overscan.Header.Size:=SizeOf(TBCM2835MailboxTagSetOverscan) - SizeOf(TBCM2835MailboxTagHeader);
     Tag.Overscan.Header.Length:=SizeOf(Tag.Overscan.Request);
     Tag.Overscan.Request.Top:=Defaults.OverscanTop;
     Tag.Overscan.Request.Bottom:=Defaults.OverscanBottom;
     Tag.Overscan.Request.Left:=Defaults.OverscanLeft;
     Tag.Overscan.Request.Right:=Defaults.OverscanRight;
     
     {Setup Tag (Allocate)}
     Tag.Allocate.Header.Tag:=BCM2835_MBOX_TAG_ALLOCATE_BUFFER;
     Tag.Allocate.Header.Size:=SizeOf(TBCM2835MailboxTagAllocateBuffer) - SizeOf(TBCM2835MailboxTagHeader);
     Tag.Allocate.Header.Length:=SizeOf(Tag.Allocate.Request);
     Tag.Allocate.Request.Alignment:=BCM2708FRAMEBUFFER_ALIGNEMENT;
     
     {Setup Tag (Pitch)}
     Tag.Pitch.Header.Tag:=BCM2835_MBOX_TAG_GET_PITCH;
     Tag.Pitch.Header.Size:=SizeOf(TBCM2835MailboxTagGetPitch) - SizeOf(TBCM2835MailboxTagHeader);
     Tag.Pitch.Header.Length:=SizeOf(Tag.Pitch.Request);
     
     {Setup Footer}
     Footer:=PBCM2835MailboxFooter(PtrUInt(Tag) + PtrUInt(SizeOf(TBCM2835MailboxTagCreateBuffer)));
     Footer.Tag:=BCM2835_MBOX_TAG_END;
     
     {Call Mailbox}
     Result:=MailboxPropertyCall(BCM2835_MAILBOX_0,BCM2835_MAILBOX0_CHANNEL_PROPERTYTAGS_ARMVC,Header,Response);
     if Result <> ERROR_SUCCESS then
      begin
       if PLATFORM_LOG_ENABLED then PlatformLogError('BCM2708: FramebufferAllocate - MailboxPropertyCall failed: ' + ErrorToString(Result));
       Exit;
      end; 
     
     {Update Framebuffer}
     Framebuffer.Address:=BusAddressToPhysical(Pointer(Tag.Allocate.Response.Address)); {Firmware may return address as a Bus address, writes must be to the Physical address}
     Framebuffer.Size:=Tag.Allocate.Response.Size;
     Framebuffer.Pitch:=Tag.Pitch.Response.Pitch;
     Framebuffer.Depth:=Tag.Depth.Response.Depth;
     Framebuffer.Order:=Tag.Order.Response.Order;
     Framebuffer.Mode:=Tag.Mode.Response.Mode;
     Framebuffer.PhysicalWidth:=Tag.Physical.Response.Width;
     Framebuffer.PhysicalHeight:=Tag.Physical.Response.Height;
     Framebuffer.VirtualWidth:=Tag.Vertual.Response.Width;
     Framebuffer.VirtualHeight:=Tag.Vertual.Response.Height;
     Framebuffer.OffsetX:=Tag.Offset.Response.X;
     Framebuffer.OffsetY:=Tag.Offset.Response.Y;
     Framebuffer.OverscanTop:=Tag.Overscan.Response.Top;
     Framebuffer.OverscanBottom:=Tag.Overscan.Response.Bottom;
     Framebuffer.OverscanLeft:=Tag.Overscan.Response.Left;
     Framebuffer.OverscanRight:=Tag.Overscan.Response.Right;
    
     {Update Statistics}
     Inc(Framebuffer.AllocateCount);
    
     {Get Result}
     Result:=ERROR_SUCCESS;
    finally
     FreeMem(Header);
    end;
    
   finally
    MutexUnlock(Framebuffer.Lock);
   end; 
  end
 else
  begin
   Result:=ERROR_CAN_NOT_COMPLETE;
  end;
end;
   
{==============================================================================}

function BCM2708FramebufferRelease(Framebuffer:PFramebufferDevice):LongWord;
var
 Size:LongWord;
 Response:LongWord;
 Header:PBCM2835MailboxHeader;
 Footer:PBCM2835MailboxFooter;
 Tag:PBCM2835MailboxTagReleaseBuffer;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check Framebuffer}
 if Framebuffer = nil then Exit;
 if Framebuffer.Device.Signature <> DEVICE_SIGNATURE then Exit; 
 
 if MutexLock(Framebuffer.Lock) = ERROR_SUCCESS then 
  begin
   try
    {Calculate Size}
    Size:=SizeOf(TBCM2835MailboxHeader) + SizeOf(TBCM2835MailboxTagReleaseBuffer) + SizeOf(TBCM2835MailboxFooter);

    {Allocate Mailbox Buffer}
    Result:=ERROR_NOT_ENOUGH_MEMORY;
    Header:=GetSharedAlignedMem(Size,SIZE_16); {Must be 16 byte aligned}
    if Header = nil then Header:=GetAlignedMem(Size,SIZE_16); {Must be 16 byte aligned}
    if Header = nil then Exit;
    try
     {Clear Buffer}
     FillChar(Header^,Size,0);
    
     {Setup Header}
     Header.Size:=Size;
     Header.Code:=BCM2835_MBOX_REQUEST_CODE;
    
     {Setup Tag}
     Tag:=PBCM2835MailboxTagReleaseBuffer(PtrUInt(Header) + PtrUInt(SizeOf(TBCM2835MailboxHeader)));
     Tag.Header.Tag:=BCM2835_MBOX_TAG_RELEASE_BUFFER;
     Tag.Header.Size:=SizeOf(TBCM2835MailboxTagReleaseBuffer) - SizeOf(TBCM2835MailboxTagHeader);
     Tag.Header.Length:=SizeOf(Tag.Request);
    
     {Setup Footer}
     Footer:=PBCM2835MailboxFooter(PtrUInt(Tag) + PtrUInt(SizeOf(TBCM2835MailboxTagReleaseBuffer)));
     Footer.Tag:=BCM2835_MBOX_TAG_END;
     
     {Call Mailbox}
     Result:=MailboxPropertyCall(BCM2835_MAILBOX_0,BCM2835_MAILBOX0_CHANNEL_PROPERTYTAGS_ARMVC,Header,Response);
     if Result <> ERROR_SUCCESS then
      begin
       if DEVICE_LOG_ENABLED then DeviceLogError(nil,'BCM2708: FramebufferRelease: MailboxPropertyCall failed: ' + ErrorToString(Result));
       Exit;
      end; 
     
     {Update Statistics}
     Inc(Framebuffer.ReleaseCount);
     
     {Get Result}
     Result:=ERROR_SUCCESS;
    finally
     FreeMem(Header);
    end;
   finally
    MutexUnlock(Framebuffer.Lock);
   end; 
  end
 else
  begin
   Result:=ERROR_CAN_NOT_COMPLETE;
  end;
end;

{==============================================================================}

function BCM2708FramebufferSetProperties(Framebuffer:PFramebufferDevice;Properties:PFramebufferProperties):LongWord;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check Properties}
 if Properties = nil then Exit;
 
 {Check Framebuffer}
 if Framebuffer = nil then Exit;
 if Framebuffer.Device.Signature <> DEVICE_SIGNATURE then Exit; 
 
 if MutexLock(Framebuffer.Lock) = ERROR_SUCCESS then 
  begin
   try
    
    //To Do //Check Properties against current, modify if possible, otherwise reallocate ? (and Notify Resize)
    
   finally
    MutexUnlock(Framebuffer.Lock);
   end; 
  end
 else
  begin
   Result:=ERROR_CAN_NOT_COMPLETE;
  end;
end;

{==============================================================================}
{==============================================================================}
{BCM2708 Helper Functions}

{==============================================================================}
{==============================================================================}

initialization
 BCM2708Init;

{==============================================================================}
 
finalization
 {Nothing}

{==============================================================================}
{==============================================================================}

end.
 
 
 
 
 