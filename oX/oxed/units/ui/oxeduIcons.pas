{
   oxeduIcons, oxed icon management
   Copyright (C) 2017. Dejan Boras

   Started On:    23.04.2017.
}

{$INCLUDE oxdefines.inc}
UNIT oxeduIcons;

INTERFACE

   USES
      uStd, StringUtils,
      {ox}
      uOX, oxuPaths, oxuFreetype, oxuTexture, oxuTexturePool, uiuContextMenu, oxuDefaultTexture,
      oxuGlyph,
      {oxed}
      uOXED, oxuFileIcons;

TYPE
   { oxedTIconsGlobal }

   oxedTIconsGlobal = record
      {default size for glyphs}
      DefaultSize: loopint;
      {will return glyph even if one cannot be loaded due to issues (to prevent any potential crashes)}
      AlwaysReturnGlyphs: boolean;

      function Create(c: longword; size: longint = 0; const name: string = ''): oxTTexture;
      function Create(const c: string; size: longint = 0): oxTTexture;

      procedure Create(item: uiPContextMenuItem; c: longword; size: longint = 0);
   end;

VAR
   oxedIcons: oxedTIconsGlobal;

IMPLEMENTATION

procedure init();
var
   tex: oxTTexture;

begin
   {file}
   tex := oxedIcons.Create('file');
   oxFileIcons.SetFile(tex);

   {folder}
   tex := oxedIcons.Create($f07b {folder});
   oxFileIcons.SetDirectory(tex);

   {file-code-o}
   tex := oxedIcons.Create($f1c9 {file-code-o});
   oxFileIcons.Add(tex, 'pas');
   oxFileIcons.Add(tex, 'pp');
   oxFileIcons.Add(tex, 'lpr');

   {file-tex}
   tex := oxedIcons.Create($f15c {'file-text'});
   oxFileIcons.Add(tex, 'txt');
   oxFileIcons.Add(tex, 'md');

   {file-image-o}
   tex := oxedIcons.Create($f1c5 {file-image});
   oxFileIcons.Add(tex, 'png');
   oxFileIcons.Add(tex, 'tga');
   oxFileIcons.Add(tex, 'jpeg');
   oxFileIcons.Add(tex, 'jpg');

   {file-archive-o}
   tex := oxedIcons.Create($f1c6 {file-archive-o});
   oxFileIcons.Add(tex, 'zip');
   oxFileIcons.Add(tex, '7z');
   oxFileIcons.Add(tex, 'rar');

   {file-audio-o}
   tex := oxedIcons.Create($f1c7 {file-audio-o});
   oxFileIcons.Add(tex, 'wav');
   oxFileIcons.Add(tex, 'mp3');
   oxFileIcons.Add(tex, 'ogg');
   oxFileIcons.Add(tex, 'flac');

   {file-audio-o}
   tex := oxedIcons.Create($f1c8 {file-video-o});
   oxFileIcons.Add(tex, 'mp4');
   oxFileIcons.Add(tex, 'mkv');
   oxFileIcons.Add(tex, 'h264');
   oxFileIcons.Add(tex, 'h264');
   oxFileIcons.Add(tex, 'wmv');

   {git}
   tex := oxedIcons.Create($f1d2{git});
   oxFileIcons.Add(tex, 'gitignore');
end;

{ oxedTIconsGlobal }

function oxedTIconsGlobal.Create(c: longword; size: longint; const name: string): oxTTexture;
var
   map: oxPGlyphMap = nil;
   codeName: string;

begin
   if(name = '') then begin
      codeName := sf(c);
      map := oxGlyphs.Load(codeName, codeName, size);
   end else
      map := oxGlyphs.Load(name, name, size);

   if(map <> nil) and (map^.Texture <> nil) then
      exit(map^.Texture);

   if(AlwaysReturnGlyphs) then
      exit(oxDefaultTexture.Texture);

   Result := nil;
end;

function oxedTIconsGlobal.Create(const c: string; size: longint): oxTTexture;
begin
   Result := Create(0, size, c);
end;

procedure oxedTIconsGlobal.Create(item: uiPContextMenuItem; c: longword; size: longint);
var
   tex: oxTTexture;

begin
   tex := Create(c, size);

   if(tex <> nil) then
      item^.SetGlyph(tex);
end;

INITIALIZATION
   oxedIcons.DefaultSize := 64;
   oxedIcons.AlwaysReturnGlyphs := true;

   oxed.Init.iAdd('oxed.icons', @init);

END.
