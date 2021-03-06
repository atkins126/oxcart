{
   oxeduEditRenderers, oxed edit window renderers
   Copyright (C) 2017. Dejan Boras
}

{$INCLUDE oxheader.inc}
UNIT oxeduComponentGlyphs;

INTERFACE

   USES
      uStd,
      {ox}
      uOX, oxuComponent, oxeduComponentGlyph, oxeduComponent,
      {oxed}
      oxeduIcons;

TYPE
   { oxedTComponentGlyphs }

   oxedTComponentGlyphs = record
      function Add(component: oxTComponentType; name: string = ''; code: loopint = 0): oxedPComponentGlyph;
   end;

VAR
   oxedComponentGlyphs: oxedTComponentGlyphs;

IMPLEMENTATION

{ oxedTComponentGlyphs }

function oxedTComponentGlyphs.Add(component: oxTComponentType; name: string; code: loopint): oxedPComponentGlyph;
var
   oxc: oxedPComponent;

begin
   assert(component <> nil, 'Trying to add a nil component type: ' + name);

   oxc := oxedComponents.Find(component);

   if(oxc <> nil) then begin
      oxc^.Glyph.Component := component;
      oxc^.Glyph.Name := name;
      oxc^.Glyph.Code := code;

      if(ox.Initialized) then
         oxc^.Glyph.CreateTexture();

      exit(@oxc^.Glyph);
   end;

   Result := nil;
end;

END.
