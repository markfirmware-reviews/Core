{
Ultibo Real Time Clock device interface unit.

Copyright (C) 2016 - SoftOz Pty Ltd.

Arch
====

 <All>

Boards
======

 <All>

Licence
=======

 LGPLv2.1 with static linking exception (See COPYING.modifiedLGPL.txt)
 
Credits
=======

 Information for this unit was obtained from:

 
References
==========


RTC Devices
===========

}

{$mode delphi} {Default to Delphi compatible syntax}
{$H+}          {Default to AnsiString}
{$inline on}   {Allow use of Inline procedures}

unit RTC; 

interface

uses GlobalConfig,GlobalConst,GlobalTypes,Platform,Threads,Devices,SysUtils;

{==============================================================================}
{Global definitions}
{$INCLUDE GlobalDefines.inc}

{==============================================================================}
const
 {RTC specific constants}
 RTC_NAME_PREFIX = 'RTC';  {Name prefix for RTC Devices}
 
 {RTC Device Types}
 RTC_TYPE_NONE      = 0;
 
 {RTC Device States}
 RTC_STATE_DISABLED = 0;
 RTC_STATE_ENABLED  = 1;
 
 {RTC Device Flags}
 RTC_FLAG_NONE          = $00000000;
 
 {RTC logging}
 RTC_LOG_LEVEL_DEBUG     = LOG_LEVEL_DEBUG;  {RTC debugging messages}
 RTC_LOG_LEVEL_INFO      = LOG_LEVEL_INFO;   {RTC informational messages, such as a device being attached or detached}
 RTC_LOG_LEVEL_ERROR     = LOG_LEVEL_ERROR;  {RTC error messages}
 RTC_LOG_LEVEL_NONE      = LOG_LEVEL_NONE;   {No RTC messages}

var 
 RTC_DEFAULT_LOG_LEVEL:LongWord = RTC_LOG_LEVEL_INFO; {Minimum level for RTC messages.  Only messages with level greater than or equal to this will be printed}
 
var 
 {RTC logging}
 RTC_LOG_ENABLED:Boolean; 

{==============================================================================}
type
 {RTC specific types}

 {RTC Properties}
 PRTCProperties = ^TRTCProperties;
 TRTCProperties = record
  //To Do
 end;
 
 {RTC Device}
 PRTCDevice = ^TRTCDevice;
 
 {RTC Enumeration Callback}
 TRTCEnumerate = function(RTC:PRTCDevice;Data:Pointer):LongWord;
 {RTC Notification Callback}
 TRTCNotification = function(Device:PDevice;Data:Pointer;Notification:LongWord):LongWord;
 
 {RTC Device Methods}
 TRTCDeviceGetTime = function(RTC:PRTCDevice):Int64;
 TRTCDeviceSetTime = function(RTC:PRTCDevice;const Time:Int64):LongWord;
 TRTCDeviceProperties = function(RTC:PRTCDevice;Properties:PRTCProperties):LongWord;
 
 TRTCDevice = record
  {Device Properties}
  Device:TDevice;                                 {The Device entry for this RTC}
  {RTC Properties}
  RTCId:LongWord;                                 {Unique Id of this RTC in the RTC table}
  RTCState:LongWord;                              {RTC state (eg RTC_STATE_ENABLED)}
  DeviceGetTime:TRTCDeviceGetTime;                {A Device specific DeviceGetTime method implementing the standard RTC device interface}
  DeviceSetTime:TRTCDeviceSetTime;                {A Device specific DeviceSetTime method implementing the standard RTC device interface}
  DeviceProperties:TRTCDeviceProperties;          {A Device specific DeviceProperties method implementing the standard RTC device interface}
  {Statistics Properties}
  //To Do
  {Driver Properties}
  Lock:TMutexHandle;                              {Device lock}
  //To Do
  Properties:TRTCProperties;                      {Device properties}
  {Internal Properties}                                                                        
  Prev:PRTCDevice;                                {Previous entry in RTC table}
  Next:PRTCDevice;                                {Next entry in RTC table}
 end; 
  
{==============================================================================}
{var}
 {RTC specific variables}
 
{==============================================================================}
{Initialization Functions}
procedure RTCInit;
 
{==============================================================================}
{RTC Functions}
function RTCDeviceGetTime(RTC:PRTCDevice):Int64;
function RTCDeviceSetTime(RTC:PRTCDevice;const Time:Int64):LongWord;
 
function RTCDeviceProperties(RTC:PRTCDevice;Properties:PRTCProperties):LongWord;
  
function RTCDeviceCreate:PRTCDevice;
function RTCDeviceCreateEx(Size:LongWord):PRTCDevice;
function RTCDeviceDestroy(RTC:PRTCDevice):LongWord;

function RTCDeviceRegister(RTC:PRTCDevice):LongWord;
function RTCDeviceDeregister(RTC:PRTCDevice):LongWord;

function RTCDeviceFind(RTCId:LongWord):PRTCDevice;
function RTCDeviceEnumerate(Callback:TRTCEnumerate;Data:Pointer):LongWord;
 
function RTCDeviceNotification(RTC:PRTCDevice;Callback:TRTCNotification;Data:Pointer;Notification,Flags:LongWord):LongWord;

{==============================================================================}
{RTL RTC Functions}
function SysRTCAvailable:Boolean;

function SysRTCGetTime:Int64;
function SysRTCSetTime(const Time:Int64):LongWord;

{==============================================================================}
{RTC Helper Functions}
function RTCGetCount:LongWord; inline;
function RTCDeviceGetDefault:PRTCDevice; inline;
function RTCDeviceSetDefault(RTC:PRTCDevice):LongWord; 

function RTCDeviceCheck(RTC:PRTCDevice):PRTCDevice;

procedure RTCLog(Level:LongWord;RTC:PRTCDevice;const AText:String);
procedure RTCLogInfo(RTC:PRTCDevice;const AText:String); inline;
procedure RTCLogError(RTC:PRTCDevice;const AText:String); inline;
procedure RTCLogDebug(RTC:PRTCDevice;const AText:String); inline;

{==============================================================================}
{==============================================================================}

implementation

{==============================================================================}
{==============================================================================}
var
 {RTC specific variables}
 RTCInitialized:Boolean;

 RTCDeviceTable:PRTCDevice;
 RTCDeviceTableLock:TCriticalSectionHandle = INVALID_HANDLE_VALUE;
 RTCDeviceTableCount:LongWord;

 RTCDeviceDefault:PRTCDevice;
 
{==============================================================================}
{==============================================================================}
{Initialization Functions}
procedure RTCInit;
begin
 {}
 {Check Initialized}
 if RTCInitialized then Exit;
 
 {Initialize Logging}
 RTC_LOG_ENABLED:=(RTC_DEFAULT_LOG_LEVEL <> RTC_LOG_LEVEL_NONE); 
 
 {Initialize RTC Table}
 RTCDeviceTable:=nil;
 RTCDeviceTableLock:=CriticalSectionCreate; 
 RTCDeviceTableCount:=0;
 if RTCDeviceTableLock = INVALID_HANDLE_VALUE then
  begin
   if RTC_LOG_ENABLED then RTCLogError(nil,'Failed to create RTC table lock');
  end;
 RTCDeviceDefault:=nil;
 
 {Register Platform RTC Handlers}
 RTCAvailableHandler:=SysRTCAvailable;
 RTCGetTimeHandler:=SysRTCGetTime;
 RTCSetTimeHandler:=SysRTCSetTime;
 
 RTCInitialized:=True;
end;
 
{==============================================================================}
{==============================================================================}
{RTC Functions}
function RTCDeviceGetTime(RTC:PRTCDevice):Int64;
begin
 {}
 Result:=0;
 //To Do
 
end;

{==============================================================================}

function RTCDeviceSetTime(RTC:PRTCDevice;const Time:Int64):LongWord;
begin
 {}
 Result:=0;
 //To Do
 
end;
 
{==============================================================================}
 
function RTCDeviceProperties(RTC:PRTCDevice;Properties:PRTCProperties):LongWord;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 //To Do
 
end;

{==============================================================================}

function RTCDeviceCreate:PRTCDevice;
{Create a new RTC entry}
{Return: Pointer to new RTC entry or nil if RTC could not be created}
begin
 {}
 Result:=RTCDeviceCreateEx(SizeOf(TRTCDevice));
end;

{==============================================================================}

function RTCDeviceCreateEx(Size:LongWord):PRTCDevice;
{Create a new RTC entry}
{Size: Size in bytes to allocate for new RTC (Including the RTC entry)}
{Return: Pointer to new RTC entry or nil if RTC could not be created}
begin
 {}
 Result:=nil;
 
 {Check Size}
 if Size < SizeOf(TRTCDevice) then Exit;
 
 {Create RTC}
 Result:=PRTCDevice(DeviceCreateEx(Size));
 if Result = nil then Exit;
 
 {Update Device}
 Result.Device.DeviceBus:=DEVICE_BUS_NONE;   
 Result.Device.DeviceType:=RTC_TYPE_NONE;
 Result.Device.DeviceFlags:=RTC_FLAG_NONE;
 Result.Device.DeviceData:=nil;

 {Update RTC}
 Result.RTCId:=DEVICE_ID_ANY;
 Result.RTCState:=RTC_STATE_DISABLED;
 Result.DeviceGetTime:=nil;
 Result.DeviceSetTime:=nil;
 Result.DeviceProperties:=nil;
 Result.Lock:=INVALID_HANDLE_VALUE;
 
 {Create Lock}
 Result.Lock:=MutexCreate;
 if Result.Lock = INVALID_HANDLE_VALUE then
  begin
   if RTC_LOG_ENABLED then RTCLogError(nil,'Failed to create lock for RTC device');
   RTCDeviceDestroy(Result);
   Result:=nil;
   Exit;
  end;
end;

{==============================================================================}

function RTCDeviceDestroy(RTC:PRTCDevice):LongWord;
{Destroy an existing RTC entry}
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check RTC}
 if RTC = nil then Exit;
 if RTC.Device.Signature <> DEVICE_SIGNATURE then Exit;
 
 {Check RTC}
 Result:=ERROR_IN_USE;
 if RTCDeviceCheck(RTC) = RTC then Exit;

 {Check State}
 if RTC.Device.DeviceState <> DEVICE_STATE_UNREGISTERED then Exit;
 
 {Destroy Lock}
 if RTC.Lock <> INVALID_HANDLE_VALUE then
  begin
   MutexDestroy(RTC.Lock);
  end;
 
 {Destroy RTC} 
 Result:=DeviceDestroy(@RTC.Device);
end;

{==============================================================================}

function RTCDeviceRegister(RTC:PRTCDevice):LongWord;
{Register a new RTC in the RTC table}
var
 RTCId:LongWord;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check RTC}
 if RTC = nil then Exit;
 if RTC.RTCId <> DEVICE_ID_ANY then Exit;
 if RTC.Device.Signature <> DEVICE_SIGNATURE then Exit;
 
 {Check RTC}
 Result:=ERROR_ALREADY_EXISTS;
 if RTCDeviceCheck(RTC) = RTC then Exit;
 
 {Check State}
 if RTC.Device.DeviceState <> DEVICE_STATE_UNREGISTERED then Exit;
 
 {Insert RTC}
 if CriticalSectionLock(RTCDeviceTableLock) = ERROR_SUCCESS then
  begin
   try
    {Update RTC}
    RTCId:=0;
    while RTCDeviceFind(RTCId) <> nil do
     begin
      Inc(RTCId);
     end;
    RTC.RTCId:=RTCId;
    
    {Update Device}
    RTC.Device.DeviceName:=RTC_NAME_PREFIX + IntToStr(RTC.RTCId); 
    RTC.Device.DeviceClass:=DEVICE_CLASS_RTC;
    
    {Register Device}
    Result:=DeviceRegister(@RTC.Device);
    if Result <> ERROR_SUCCESS then
     begin
      RTC.RTCId:=DEVICE_ID_ANY;
      Exit;
     end; 
    
    {Link RTC}
    if RTCDeviceTable = nil then
     begin
      RTCDeviceTable:=RTC;
     end
    else
     begin
      RTC.Next:=RTCDeviceTable;
      RTCDeviceTable.Prev:=RTC;
      RTCDeviceTable:=RTC;
     end;
 
    {Increment Count}
    Inc(RTCDeviceTableCount);
    
    {Check Default}
    if RTCDeviceDefault = nil then
     begin
      RTCDeviceDefault:=RTC;
     end;
    
    {Return Result}
    Result:=ERROR_SUCCESS;
   finally
    CriticalSectionUnlock(RTCDeviceTableLock);
   end;
  end
 else
  begin
   Result:=ERROR_CAN_NOT_COMPLETE;
  end;  
end;

{==============================================================================}

function RTCDeviceDeregister(RTC:PRTCDevice):LongWord;
{Deregister a RTC from the RTC table}
var
 Prev:PRTCDevice;
 Next:PRTCDevice;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check RTC}
 if RTC = nil then Exit;
 if RTC.RTCId = DEVICE_ID_ANY then Exit;
 if RTC.Device.Signature <> DEVICE_SIGNATURE then Exit;
 
 {Check RTC}
 Result:=ERROR_NOT_FOUND;
 if RTCDeviceCheck(RTC) <> RTC then Exit;
 
 {Check State}
 if RTC.Device.DeviceState <> DEVICE_STATE_REGISTERED then Exit;
 
 {Remove RTC}
 if CriticalSectionLock(RTCDeviceTableLock) = ERROR_SUCCESS then
  begin
   try
    {Deregister Device}
    Result:=DeviceDeregister(@RTC.Device);
    if Result <> ERROR_SUCCESS then Exit;
    
    {Unlink RTC}
    Prev:=RTC.Prev;
    Next:=RTC.Next;
    if Prev = nil then
     begin
      RTCDeviceTable:=Next;
      if Next <> nil then
       begin
        Next.Prev:=nil;
       end;       
     end
    else
     begin
      Prev.Next:=Next;
      if Next <> nil then
       begin
        Next.Prev:=Prev;
       end;       
     end;     
 
    {Decrement Count}
    Dec(RTCDeviceTableCount);
 
    {Check Default}
    if RTCDeviceDefault = RTC then
     begin
      RTCDeviceDefault:=RTCDeviceTable;
     end;
 
    {Update RTC}
    RTC.RTCId:=DEVICE_ID_ANY;
 
    {Return Result}
    Result:=ERROR_SUCCESS;
   finally
    CriticalSectionUnlock(RTCDeviceTableLock);
   end;
  end
 else
  begin
   Result:=ERROR_CAN_NOT_COMPLETE;
  end;  
end;

{==============================================================================}

function RTCDeviceFind(RTCId:LongWord):PRTCDevice;
var
 RTC:PRTCDevice;
begin
 {}
 Result:=nil;
 
 {Check Id}
 if RTCId = DEVICE_ID_ANY then Exit;
 
 {Acquire the Lock}
 if CriticalSectionLock(RTCDeviceTableLock) = ERROR_SUCCESS then
  begin
   try
    {Get RTC}
    RTC:=RTCDeviceTable;
    while RTC <> nil do
     begin
      {Check State}
      if RTC.Device.DeviceState = DEVICE_STATE_REGISTERED then
       begin
        {Check Id}
        if RTC.RTCId = RTCId then
         begin
          Result:=RTC;
          Exit;
         end;
       end;
       
      {Get Next}
      RTC:=RTC.Next;
     end;
   finally
    {Release the Lock}
    CriticalSectionUnlock(RTCDeviceTableLock);
   end;
  end;
end;
       
{==============================================================================}

function RTCDeviceEnumerate(Callback:TRTCEnumerate;Data:Pointer):LongWord;
var
 RTC:PRTCDevice;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check Callback}
 if not Assigned(Callback) then Exit;
 
 {Acquire the Lock}
 if CriticalSectionLock(RTCDeviceTableLock) = ERROR_SUCCESS then
  begin
   try
    {Get RTC}
    RTC:=RTCDeviceTable;
    while RTC <> nil do
     begin
      {Check State}
      if RTC.Device.DeviceState = DEVICE_STATE_REGISTERED then
       begin
        if Callback(RTC,Data) <> ERROR_SUCCESS then Exit;
       end;
       
      {Get Next}
      RTC:=RTC.Next;
     end;
     
    {Return Result}
    Result:=ERROR_SUCCESS;
   finally
    {Release the Lock}
    CriticalSectionUnlock(RTCDeviceTableLock);
   end;
  end
 else
  begin
   Result:=ERROR_CAN_NOT_COMPLETE;
  end;  
end;

{==============================================================================}

function RTCDeviceNotification(RTC:PRTCDevice;Callback:TRTCNotification;Data:Pointer;Notification,Flags:LongWord):LongWord;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check RTC}
 if RTC = nil then
  begin
   Result:=DeviceNotification(nil,DEVICE_CLASS_RTC,Callback,Data,Notification,Flags);
  end
 else
  begin 
   {Check RTC}
   if RTC.Device.Signature <> DEVICE_SIGNATURE then Exit;

   Result:=DeviceNotification(@RTC.Device,DEVICE_CLASS_RTC,Callback,Data,Notification,Flags);
  end; 
end;

{==============================================================================}
{==============================================================================}
{RTL RTC Functions}
function SysRTCAvailable:Boolean; 
{Check if an RTC device is available}
begin
 {}
 Result:=(RTCDeviceDefault <> nil);
end;

{==============================================================================}

function SysRTCGetTime:Int64;
begin
 {}
 Result:=0;
 
 if RTCDeviceDefault = nil then Exit;

 Result:=RTCDeviceGetTime(RTCDeviceDefault);
end;

{==============================================================================}

function SysRTCSetTime(const Time:Int64):LongWord;
begin
 {}
 Result:=0;
 
 if RTCDeviceDefault = nil then Exit;

 Result:=RTCDeviceSetTime(RTCDeviceDefault,Time);
end;

{==============================================================================}
{==============================================================================}
{RTC Helper Functions}
function RTCGetCount:LongWord; inline;
{Get the current RTC count}
begin
 {}
 Result:=RTCDeviceTableCount;
end;

{==============================================================================}

function RTCDeviceGetDefault:PRTCDevice; inline;
{Get the current default RTC device}
begin
 {}
 Result:=RTCDeviceDefault;
end;

{==============================================================================}

function RTCDeviceSetDefault(RTC:PRTCDevice):LongWord; 
{Set the current default RTC device}
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check RTC}
 if RTC = nil then Exit;
 if RTC.Device.Signature <> DEVICE_SIGNATURE then Exit;
 
 {Acquire the Lock}
 if CriticalSectionLock(RTCDeviceTableLock) = ERROR_SUCCESS then
  begin
   try
    {Check RTC}
    if RTCDeviceCheck(RTC) <> RTC then Exit;
    
    {Set RTC Default}
    RTCDeviceDefault:=RTC;
    
    {Return Result}
    Result:=ERROR_SUCCESS;
   finally
    {Release the Lock}
    CriticalSectionUnlock(RTCDeviceTableLock);
   end;
  end
 else
  begin
   Result:=ERROR_CAN_NOT_COMPLETE;
  end;
end;

{==============================================================================}

function RTCDeviceCheck(RTC:PRTCDevice):PRTCDevice;
{Check if the supplied RTC is in the RTC table}
var
 Current:PRTCDevice;
begin
 {}
 Result:=nil;
 
 {Check RTC}
 if RTC = nil then Exit;
 if RTC.Device.Signature <> DEVICE_SIGNATURE then Exit;
 
 {Acquire the Lock}
 if CriticalSectionLock(RTCDeviceTableLock) = ERROR_SUCCESS then
  begin
   try
    {Get RTC}
    Current:=RTCDeviceTable;
    while Current <> nil do
     begin
      {Check RTC}
      if Current = RTC then
       begin
        Result:=RTC;
        Exit;
       end;
      
      {Get Next}
      Current:=Current.Next;
     end;
   finally
    {Release the Lock}
    CriticalSectionUnlock(RTCDeviceTableLock);
   end;
  end;
end;

{==============================================================================}

procedure RTCLog(Level:LongWord;RTC:PRTCDevice;const AText:String);
var
 WorkBuffer:String;
begin
 {}
 {Check Level}
 if Level < RTC_DEFAULT_LOG_LEVEL then Exit;
 
 WorkBuffer:='';
 {Check Level}
 if Level = RTC_LOG_LEVEL_DEBUG then
  begin
   WorkBuffer:=WorkBuffer + '[DEBUG] ';
  end
 else if Level = RTC_LOG_LEVEL_ERROR then
  begin
   WorkBuffer:=WorkBuffer + '[ERROR] ';
  end;
 
 {Add Prefix}
 WorkBuffer:=WorkBuffer + 'RTC: ';
 
 {Check RTC}
 if RTC <> nil then
  begin
   WorkBuffer:=WorkBuffer + RTC_NAME_PREFIX + IntToStr(RTC.RTCId) + ': ';
  end;

 {Output Logging}  
 LoggingOutputEx(LOGGING_FACILITY_RTC,LogLevelToLoggingSeverity(Level),'RTC',WorkBuffer + AText);
end;

{==============================================================================}

procedure RTCLogInfo(RTC:PRTCDevice;const AText:String); inline;
begin
 {}
 RTCLog(RTC_LOG_LEVEL_INFO,RTC,AText);
end;

{==============================================================================}

procedure RTCLogError(RTC:PRTCDevice;const AText:String); inline;
begin
 {}
 RTCLog(RTC_LOG_LEVEL_ERROR,RTC,AText);
end;

{==============================================================================}

procedure RTCLogDebug(RTC:PRTCDevice;const AText:String); inline;
begin
 {}
 RTCLog(RTC_LOG_LEVEL_DEBUG,RTC,AText);
end;

{==============================================================================}
{==============================================================================}

initialization
 RTCInit;

{==============================================================================}
 
finalization
 {Nothing}

{==============================================================================}
{==============================================================================}

end.
  