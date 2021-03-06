{
   oxeduSceneView, oxed scene view window
   Copyright (C) 2016. Dejan Boras
}

{$INCLUDE oxheader.inc}
UNIT oxeduSceneView;

INTERFACE

   USES
      uStd,
      {ox}
      oxuRunRoutines, oxuSceneRender,
      {oxed}
      uOXED, oxeduMenubar, oxeduWindow, oxeduSceneWindow;

TYPE

   { oxedTSceneViewWindow }

   oxedTSceneViewWindow = class(oxedTSceneWindow)
      procedure Initialize(); override;
   end;

   oxedTSceneView = class(oxedTWindowClass)
   end;

VAR
   oxedSceneView: oxedTSceneView;

IMPLEMENTATION

procedure openSceneView();
begin
   oxedSceneView.CreateWindow();
end;

procedure init();
begin
   oxedSceneView := oxedTSceneView.Create('View', oxedTSceneViewWindow);
end;

procedure initMenubar();
begin
   oxedMenubar.OpenWindows.AddItem('Scene View', @openSceneView);
end;

procedure deinit();
begin
   FreeObject(oxedSceneView);
end;

{ oxedTSceneViewWindow }

procedure oxedTSceneViewWindow.Initialize();
begin
   inherited;

   wdg.SceneRender.RenderSceneCameras := false;
end;

INITIALIZATION
   oxed.Init.Add('scene.view', @init, @deinit);
   oxedMenubar.OnInit.Add(@initMenubar);

END.
