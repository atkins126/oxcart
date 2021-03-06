{
   oxeduTestsPluginUI
   Copyright (C) 2017. Dejan Boras
}

{$INCLUDE oxheader.inc}
UNIT oxeduTestsPluginUI;

INTERFACE

   USES
      uStd, uTest,
      {ox}
      uOX, oxuRunRoutines, oxuTypes, oxuwndBase, oxuThreadTask,
      {ui}
      uiuWidget, uiWidgets, uiuContextMenu, uiuControl,
      {wdg}
      wdguCheckboxHierarchy, wdguDivisor, wdguButton, wdguList, wdguCheckbox,
      {oxed}
      uOXED, oxeduMenubar, oxeduTestsPlugin, oxeduTasks;

TYPE

   { oxedwdgTTestsHierarchy }

   oxedwdgTTestsHierarchy = class(wdgTCheckboxHierarchy)
      function GetValue(index: loopint): StdString; override;
      function GetSubItems({%H-}index: loopint; ref: pointer): TSimplePointerList; override;
      function Expandable(index: loopint): boolean; override;
      function IsChecked(ref: pointer): boolean; override;
   end;

   { oxeduiTTestsWindow }

   oxeduiTTestsWindow = class(oxuiTWindowBase)
      procedure SizeChanged(); override;
   end;

   oxedPTestsWindow = ^oxedTTestsWindow;

   { oxedTTestsWindow }

   oxedTTestsWindow = object(oxTWindowBase)
      wdg: record
         IncludeOx: wdgTCheckbox;
         Divisor: wdgTDivisor;
         List: oxedwdgTTestsHierarchy;
         Ok: wdgTButton;
         Scan: wdgTButton;
      end;

      menu: record
         Configure,
         Run: uiPContextMenuItem;
      end; static;

      constructor Create();

      procedure AddWidgets(); virtual;

      {run tests scan operation}
      procedure Scan();
      {run tests operation}
      procedure Run();

      procedure Update();
      procedure UpdateWidgets(enabled: boolean);
   end;

VAR
   oxedwndTests: oxedTTestsWindow;

IMPLEMENTATION

function canEnable(): boolean;
begin
   Result := oxedTasks.Running(nil) = 0;
end;


{ oxedwdgTTestsHierarchy }

function oxedwdgTTestsHierarchy.GetValue(index: loopint): StdString;
begin
   Result := PUnitTestResultsPool(Visible.List[index].Item)^.Results.Group;
end;

function oxedwdgTTestsHierarchy.GetSubItems(index: loopint; ref: pointer): TSimplePointerList;
var
   i: loopint;
   source: PUnitTestResultsPool;

begin
   Result.Initialize(Result);

   {do not return any results if we're running a scan right now}
   if(not oxedTests.CanTask(OXED_TEST_TASK_SCAN)) then
      exit;

   if(ref <> nil) then
      source := PUnitTestResultsPool(ref)
   else
      source := @UnitTests.Pool;

   Result.a := source^.n;
   Result.n := Result.a;
   SetLength(Result.List, Result.n);

   for i := 0 to (Result.n - 1) do
      Result.List[i] := @source^.List[i];
end;

function oxedwdgTTestsHierarchy.Expandable(index: loopint): boolean;
begin
   Result := PUnitTestResultsPool(Visible.List[index].Item)^.n > 0;
end;

function oxedwdgTTestsHierarchy.IsChecked(ref: pointer): boolean;
begin
   Result := PUnitTestResultsPool(ref)^.Enabled;
end;

function controlIncludeOxCheckbox(wdg: uiTWidget; {%H-}what: loopint): loopint;
begin
   oxedTests.IncludeOx := wdgTCheckbox(wdg).Checked();

   Result := -1;
end;

{ oxeduiTTestsWindow }

procedure oxeduiTTestsWindow.SizeChanged();
var
   handler: oxedPTestsWindow;

begin
   inherited SizeChanged();

   handler := BaseHandler;

   if(handler <> nil) and (handler^.wdg.Ok <> nil) then begin
      handler^.wdg.IncludeOx.SetPosition(wdgPOSITION_HORIZONTAL_LEFT or wdgPOSITION_VERTICAL_TOP);
      handler^.wdg.IncludeOx.SetControlMethod(@controlIncludeOxCheckbox);

      handler^.wdg.Ok.SetPosition(wdgPOSITION_HORIZONTAL_RIGHT or wdgPOSITION_VERTICAL_BOTTOM);
      handler^.wdg.Scan.Move(handler^.wdg.Ok.LeftOf(0) - handler^.wdg.Scan.GetComputedWidth() + 1, handler^.wdg.Ok.Position.y);

      handler^.wdg.Divisor.Move(0, handler^.wdg.Ok.AboveOf() + wdgDEFAULT_SPACING);
      handler^.wdg.Divisor.AutoSize();

      handler^.wdg.List.SetPosition(wdgPOSITION_HORIZONTAL_LEFT);
      handler^.wdg.List.Move(handler^.wdg.List.Position.x, handler^.wdg.IncludeOx.BelowOf());
      handler^.wdg.List.Resize(Dimensions.w - wdgDEFAULT_SPACING * 2, handler^.wdg.IncludeOx.BelowOf() - handler^.wdg.Divisor.AboveOf() - wdgDEFAULT_SPACING);
   end;
end;

{ oxedTTestsWindow }

constructor oxedTTestsWindow.Create();
begin
   Instance := oxeduiTTestsWindow;

   inherited Create();
end;

procedure oxedTTestsWindow.AddWidgets();
begin
   inherited AddWidgets();

   wdg.IncludeOx := wdgCheckbox.Add('Include oX tests', oxedTests.IncludeOx);

   wdg.Ok := wdgButton.Add('OK').UseCallback(@Close).SetButtonPosition([uiCONTROL_GRID_RIGHT]);
   wdg.Scan := wdgButton.Add('Scan').UseCallback(@Scan).SetButtonPosition([uiCONTROL_GRID_LEFT]);

   wdg.Divisor := wdgDivisor.Add('');

   uiWidget.Create.Instance := oxedwdgTTestsHierarchy;
   wdg.List := oxedwdgTTestsHierarchy(wdgList.Add());
   wdg.List.Load();

   wdg.List.SetPosition(wdgPOSITION_VERTICAL_TOP);

   oxeduiTTestsWindow(Window).SizeChanged();

   UpdateWidgets(canEnable());
end;

procedure oxedTTestsWindow.Scan();
begin
   wdg.List.RemoveAll();
   oxedTests.Scan();
end;

procedure oxedTTestsWindow.Run();
begin
   oxedTests.RunTests();
end;

procedure oxedTTestsWindow.Update();
begin
   if(wdg.List <> nil) then
      wdg.List.Load();
end;

procedure oxedTTestsWindow.UpdateWidgets(enabled: boolean);
begin
   if(wdg.Scan <> nil) then begin
      wdg.Scan.Enable(enabled);
      wdg.List.Enable(enabled);
   end;
end;

procedure update();
var
   enabled: boolean;

begin
   enabled := canEnable();

   oxedwndTests.UpdateWidgets(enabled);

   if(oxedTTestsWindow.menu.Run <> nil) then
      oxedTTestsWindow.menu.Run^.Enable(enabled);
end;

procedure scanDone();
begin
   if(oxedTests.TaskType = OXED_TEST_TASK_SCAN) then begin
      oxedwndTests.Update();
      update();
   end;
end;

procedure menubarInit();
begin
   oxedMenubar.Project.AddSeparator();
   oxedTTestsWindow.menu.Configure := oxedMenubar.Project.AddItem('Configure Tests', oxedwndTests.OpenWindowAction);
   oxedTTestsWindow.menu.Run := oxedMenubar.Project.AddItem('Run Tests', @oxedwndTests.Run);
end;

procedure init();
begin
   oxedwndTests.Create();
end;

procedure deinit();
begin
   FreeObject(oxedwndTests);
end;

INITIALIZATION
   oxed.Init.Add('ox.settings', @init, @deinit);
   oxedMenubar.OnInit.Add(@menubarInit);

   oxedTests.OnTaskStart.Add(@update);
   oxedTests.OnTaskDone.Add(@scanDone);

   oxedTasks.OnTaskStart.Add(@update);
   oxedTasks.OnTaskDone.Add(@update);

END.
