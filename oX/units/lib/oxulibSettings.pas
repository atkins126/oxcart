{
   oxulibSettings, library mode settings
   Copyright (c) 2019. Dejan Boras

   Started On:    04.02.2019.
}

{$INCLUDE oxdefines.inc}
UNIT oxulibSettings;

INTERFACE

TYPE
   oxPLibrarySettings = ^oxTLibrarySettings;
   oxTLibrarySettings = record
      {is any of the library mode windows focused}
      Focused: boolean;
   end;

VAR
   oxLibrarySettings: oxTLibrarySettings;

IMPLEMENTATION

END.