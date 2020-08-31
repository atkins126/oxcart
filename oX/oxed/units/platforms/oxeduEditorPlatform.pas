{
   oxeduEditorPlatform, editor build specifics
   Copyright (C) 2019. Dejan Boras
}

{$INCLUDE oxdefines.inc}
UNIT oxeduEditorPlatform;

INTERFACE

   USES
      uStd, uFPCHelpers,
      {ox}
      oxuRunRoutines,
      {oxed}
      uOXED, oxeduPlatform, oxeduPlatformConfiguration;

TYPE
   { oxedTEditorPlatformArchitecture }

   oxedTEditorPlatformArchitecture = class(oxedTPlatformArchitecture)
   end;

   { oxedTEditorPlatform }

   oxedTEditorPlatform = class(oxedTPlatform)
      Architecture: oxedTEditorPlatformArchitecture;
      constructor Create(); override;

      procedure Load(); override;
   end;

VAR
   oxedEditorPlatform: oxedTEditorPlatform;

IMPLEMENTATION

{ oxedTEditorPlatform }

constructor oxedTEditorPlatform.Create();
begin
   inherited;

   Name := 'Editor';
   Id := 'editor';
   GlyphName := 'brands:61820';
   OS := LowerCase(FPC_TARGETOS);

   {editor platform is always enabled}
   Enabled := true;

   Configuration := oxedTPlatformConfiguration.Create();
   Architecture := oxedTEditorPlatformArchitecture.Create('editor', LowerCase(FPC_TARGETCPU));
   AddArchitecture(Architecture);
end;

procedure oxedTEditorPlatform.Load();
begin
   {prevent disabling editor platform via config file}
   Enabled := true;
end;

procedure init();
begin
   oxedEditorPlatform := oxedTEditorPlatform.Create();
   oxedPlatforms.Add(oxedEditorPlatform);
end;

INITIALIZATION
   oxed.Init.Add('platform.editor', @init);

END.
