{
   oxeduAndroidPlatform, android platform build specifics
   Copyright (C) 2019. Dejan Boras

   Started On:    10.06.2019.
}

{$INCLUDE oxdefines.inc}
UNIT oxeduAndroidPlatform;

INTERFACE

   USES
      uStd,
      {ox}
      oxuRunRoutines,
      {oxed}
      uOXED, oxeduPlatform, oxeduPlatformConfiguration, oxeduAndroidSettings;

TYPE
   { oxedTAndroidPlatform }

   oxedTAndroidPlatform = class(oxedTPlatform)
      constructor Create(); override;

      procedure ProjectReset(); override;
   end;

IMPLEMENTATION

{ oxedTAndroidPlatform }

constructor oxedTAndroidPlatform.Create();
begin
   inherited;

   Name := 'Android';
   id := 'android';
   GlyphName := 'brands:61819';

   Configuration := oxedTPlatformConfiguration.Create();

   AddArchitecture('Default', '');
end;

procedure oxedTAndroidPlatform.ProjectReset();
begin
   oxedAndroidSettings.Reset();
end;

procedure init();
begin
   oxedPlatforms.Add(oxedTAndroidPlatform.Create());
end;

INITIALIZATION
   oxed.Init.Add('platform.android', @init);

END.
