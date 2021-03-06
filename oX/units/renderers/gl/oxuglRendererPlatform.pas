{
   oxuglRendererPlatform, gl renderer platform specific component
   Copyright (c) 2020. Dejan Boras
}

{$INCLUDE oxheader.inc}
UNIT oxuglRendererPlatform;

INTERFACE

   USES
      uStd,
      {ox}
      oxuOGL, oxuglWindow;

TYPE
   oxglPPlatform = ^oxglTPlatform;

   { oxglTPlatform }

   oxglTPlatform = object
      constructor Create();

      procedure OnInitialize(); virtual;
      function PreInitWindow({%H-}wnd: oglTWindow): boolean; virtual;
      procedure OnInitWindow({%H-}wnd: oglTWindow); virtual;
      procedure SwapBuffers({%H-}wnd: oglTWindow); virtual;
      function GetContext({%H-}wnd: oglTWindow; {%H-}shareContext: oglTRenderingContext): oglTRenderingContext; virtual;
      function ContextCurrent({%H-}wnd: oglTWindow; {%H-}context: oglTRenderingContext): boolean; virtual;
      function ClearContext({%H-}wnd: oglTWindow): boolean; virtual;
      function DestroyContext({%H-}wnd: oglTWindow; {%H-}context: oglTRenderingContext): boolean; virtual;
   end;

IMPLEMENTATION

{ oxglTPlatform }

constructor oxglTPlatform.Create();
begin

end;

procedure oxglTPlatform.OnInitialize();
begin

end;

function oxglTPlatform.PreInitWindow(wnd: oglTWindow): boolean;
begin
   Result := false;
end;

procedure oxglTPlatform.OnInitWindow(wnd: oglTWindow);
begin

end;

procedure oxglTPlatform.SwapBuffers(wnd: oglTWindow);
begin

end;

function oxglTPlatform.GetContext(wnd: oglTWindow; shareContext: oglTRenderingContext): oglTRenderingContext;
begin
   Result := default(oglTRenderingContext);
end;

function oxglTPlatform.ContextCurrent(wnd: oglTWindow; context: oglTRenderingContext): boolean;
begin
   Result := true;
end;

function oxglTPlatform.ClearContext(wnd: oglTWindow): boolean;
begin
   Result := true;
end;

function oxglTPlatform.DestroyContext(wnd: oglTWindow; context: oglTRenderingContext): boolean;
begin
   Result := true;
end;

END.
