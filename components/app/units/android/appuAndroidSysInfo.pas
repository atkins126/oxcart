{
   Gathers information on android systems
   Copyright (C) 2020. Dejan Boras
}

{$INCLUDE oxheader.inc}
UNIT appuAndroidSysInfo;

INTERFACE

	USES
      appuSysInfoBase,
      appuLinuxSysInfo;

procedure appAndroidSysInfoGetInformation();

IMPLEMENTATION

procedure appAndroidSysInfoGetInformation();
begin
   appLinuxSysInfoGetInformation();
end;

INITIALIZATION
   appSI.GetInformation := @appAndroidSysInfoGetInformation;

END.
