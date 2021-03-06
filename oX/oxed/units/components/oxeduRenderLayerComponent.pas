{
   oxeduRenderLayerComponent, oxed render layer component
   Copyright (C) 2019. Dejan Boras
}

{$INCLUDE oxheader.inc}
UNIT oxeduRenderLayerComponent;

INTERFACE

   USES
      uStd,
      {ox}
      oxuRunRoutines,
      oxuRenderLayerComponent, oxeduEditRenderers, oxeduComponent, oxeduComponentGlyphs;

TYPE
   { oxedTRenderLayerEditRenderer }

   oxedTRenderLayerEditRenderer = class(oxedTEditRenderer)
      constructor Create();
   end;

VAR
   oxedRenderLayerEditRenderer: oxedTRenderLayerEditRenderer;

IMPLEMENTATION

{ oxedTRenderLayerEditRenderer }

constructor oxedTRenderLayerEditRenderer.Create();
begin
   Name := 'RenderLayer';

   oxedComponentGlyphs.Add(oxTRenderLayerComponent, '', $f0eb);
   Associate(oxTRenderLayerComponent);
end;

procedure init();
begin
   oxedRenderLayerEditRenderer := oxedTRenderLayerEditRenderer.Create();
end;

procedure deinit();
begin
   FreeObject(oxedRenderLayerEditRenderer);
end;

INITIALIZATION
   oxedEditRenderers.Init.Add('render_layer', @init, @deinit);

END.
