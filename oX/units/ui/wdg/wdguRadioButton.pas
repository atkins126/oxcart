{
   wdguRadioButton, progress bar widget for the UI
   Copyright (C) 2011. Dejan Boras
}

{$INCLUDE oxheader.inc}
UNIT wdguRadioButton;

INTERFACE

   USES
      uStd, uColors, vmVector,
      {app}
      appuKeys, appuMouse,
      {oX}
      oxuTypes, oxuFont, oxumPrimitive, oxuTexture, oxuTransform,
      {ui}
      uiuWindowTypes, uiuWindow, uiuSkinTypes,
      uiuWidget, uiWidgets, uiuRegisteredWidgets,
      wdguBase;

TYPE

   { wdgTRadioButton }

   wdgTRadioButton = class(uiTWidget)
   public
      procedure Point(var e: appTMouseEvent; {%H-}x, {%H-}y: longint); override;
      procedure Render(); override;
      function Key(var k: appTKeyEvent): boolean; override;

      function SetGroup(g: loopint): wdgTRadioButton; override;

      {set the check-box state}
      procedure Mark();
   end;

   { wdgTRadioButtonGlobal }

   wdgTRadioButtonGlobal = object(specialize wdgTBase<wdgTRadioButton>)
      Diameter,
      CaptionSpace: longint; static;
      Inner,
      Outer: oxTPrimitiveModel; static;

      clrDisabled: TColor4ub; static;

      procedure SetSize(w, h: longint);

      function Add(const Caption: StdString;
                  const Pos: oxTPoint;
                  value: boolean = false): wdgTRadioButton;
   end;

VAR
   wdgRadioButton: wdgTRadioButtonGlobal;

IMPLEMENTATION

procedure wdgTRadioButton.Point(var e: appTMouseEvent; {%H-}x, {%H-}y: longint);
begin
   if(e.Action and appmcRELEASED > 0) and (e.Button and appmcLEFT > 0) then
      Mark();
end;

procedure wdgTRadioButton.Render();
var
   f: oxTFont;
   offset: longint;
   m: TMatrix4f;

begin
   offset := wdgRadioButton.Diameter div 2;

   m := oxTransform.Matrix;
   oxTransform.Translate(Position.x + offset, Position.y - offset, 0);
   oxTransform.Apply();

   SetColor(uiTSkin(uiTWindow(wnd).Skin).Colors.Highlight);

   wdgRadioButton.Outer.Render();

   {if selected, choose the inner one}
   if(wdgpTRUE in Properties) then
      wdgRadioButton.Inner.Render();

   oxTransform.Apply(m);

   if(Caption <> '') then begin
      f := CachedFont;
      offset := abs((wdgRadioButton.Diameter - f.GetHeight()) div 2) + f.GetHeight();

      f.Start();
      f.Write(RPosition.x + wdgRadioButton.Diameter + wdgRadioButton.CaptionSpace, RPosition.y - offset, Caption);
      oxf.Stop();
   end;
end;

function wdgTRadioButton.Key(var k: appTKeyEvent): boolean;
begin
   Result := false;

   if(k.Key.Equal(kcSPACE) or k.Key.Equal(kcENTER)) then begin
      if(k.Key.Released()) then
	     Mark();

      Result := true;
   end;
end;

function wdgTRadioButton.SetGroup(g: loopint): wdgTRadioButton;
begin
   Result := wdgTRadioButton(inherited SetGroup(g));
end;

procedure wdgTRadioButton.Mark();
var
   w: uiPWidgets;
   i: longint;

begin
   w := GetWidgetsContainer();

   {go through widgets}
   for i := 0 to w^.w.n - 1 do begin
      if (uiTWidget(w^.w.List[i]).Group = Group) and (w^.w.List[i].ClassType = wdgTRadioButton) then
         Exclude(wdgTRadioButton(w^.w.List[i]).Properties, wdgpTRUE);
   end;

   Include(Properties, wdgpTRUE);

   {TODO: Send events about state change perhaps}
end;

procedure wdgTRadioButtonGlobal.SetSize(w, h: longint);
begin
   Diameter := w;
   Diameter := h;

   Inner.InitDisk((Diameter / 2) * 0.75, 32);
   Outer.InitCircle(Diameter / 2, 32);
end;

function wdgTRadioButtonGlobal.Add(const Caption: StdString;
         const Pos: oxTPoint;
         value: boolean = false): wdgTRadioButton;

begin
   Result := wdgTRadioButton(uiWidget.Add(internal, Pos, oxDimensions(0, 0)));

   if(Result <> nil) then begin
      Result.SetCaption(Caption);

      if(value) then
         Result.Mark();

      if(Result.Dimensions.h = 0) then
         Result.Dimensions.h := wdgRadioButton.Diameter;

      if(Result.Dimensions.w = 0) then begin
         Result.Dimensions.w := wdgRadioButton.Diameter + wdgRadioButton.CaptionSpace;

         inc(Result.Dimensions.w, Result.CachedFont.GetLength(Caption));
      end;
   end;
end;

INITIALIZATION
   wdgRadioButton.Create('radio_button');
   wdgRadioButton.SetSize(16, 16);
   wdgRadioButton.CaptionSpace := 4;
   wdgRadioButton.clrDisabled.Assign(96, 96, 96, 255);

END.
