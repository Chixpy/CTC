program CTC031;
{< The Coding Train Challenge #031 - Flappy Bird }

// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/cXgA1d_E-jY
// Port: (C) 2024 Chixpy https://github.com/Chixpy
{$mode ObjFPC}{$H+}

uses
  Classes, SysUtils, CTypes, StrUtils, FileUtil, LazFileUtils, Math, fgl,
  SDL2, SDL2_GFX, SDL2_TTF, SDL2_Image,
  uCHXPoint3DF, uCHXStrUtils,
  ucCHXSDL2Engine, uCHXSDL2Utils,
  ucCTCPipe, ucCTCBird;

const
  // Renderer scales images to actual size of the window.
  WinW = 800; { CHX: Window logical width. }
  WinH = 600; { CHX: Window logical height. }

type
  PipeList = specialize TFPGObjectList<cCTCPipe>;

  { cCTCEng }

  cCTCEng = class(cCHXSDL2Engine)
  protected
    procedure Setup; override;
    procedure Finish; override;
    procedure Compute(const FrameTime : CUInt32; var ExitProg : Boolean);
      override;
    procedure Draw; override;
    procedure HandleEvent(const aEvent : TSDL_Event; var Handled : Boolean;
      var ExitProg : Boolean); override;

  public
    { CHX: Global variables. }
    b : cCTCBird;

    score : integer;
    jumping : Boolean;
    gravity : TPoint3DF;

    pipes : PipeList;

    //int rez = 20;

  end;

  { cCTCEng }

  procedure cCTCEng.Setup;
  begin
    score := 0;
    jumping := False;

    b := cCTCBird.Create(WinH);

    pipes := PipeList.Create(True);
    pipes.add(cCTCPipe.Create(WinW, WinH));
  end;

  procedure cCTCEng.Finish;
  begin
    { CHX: Free any created objects. }
    FreeAndNil(pipes);
    FreeAndNil(b);
  end;

  procedure cCTCEng.Compute(const FrameTime : CUInt32; var ExitProg : Boolean);
  var
    safe : Boolean;
    p : cCTCPipe;
    i : integer;
  begin
    { CHX: If we want to pause when minimized or focus lost. }
    // if SDLWindow.Minimized then Exit;

    if (FrameCount mod 75) = 0 then
      pipes.add(cCTCPipe.Create(WinW, WinH));

    b.update();

    safe := True;

    i := pipes.Count - 1;
    while i >= 0 do
    begin
      p := pipes[i];
      p.update;

      if (p.hits(b)) then safe := False;

      if p.x < -p.w then
        pipes.Delete(i);

      Dec(i);
    end;

    if safe then
      Inc(score)
    else
      score -= 50;
  end;

  procedure cCTCEng.Draw;
  var
    p : cCTCPipe;
    aRect : TSDL_FRect;
  begin
    // Background and frame clear.
    SDL_SetRenderDrawColor(SDLWindow.PRenderer, 0, 0, 0, 255);
    SDL_RenderClear(SDLWindow.PRenderer);

    // Pipe.Draw()
    for p in pipes do
    begin
      if p.hited then
        SDL_SetRenderDrawColor(SDLWindow.PRenderer, 255, 0, 0, 255)
      else
        SDL_SetRenderDrawColor(SDLWindow.PRenderer, 255, 255, 255, 255);

      aRect := SDLFRect(p.x, 0, p.w, p.top);
      SDL_RenderFillRectF(SDLWindow.PRenderer, @aRect);

      aRect := SDLFRect(p.x, WinH - p.bottom, p.w, p.bottom);
      SDL_RenderFillRectF(SDLWindow.PRenderer, @aRect);
    end;

    //  bird.Draw()
    filledCircleRGBA(SDLWindow.PRenderer, Round(b.pos.x), Round(b.pos.y),
      Round(b.r), 255, 255, 255, 255);

    if score < 0 then score := 0;

    DefFont.RenderDynStr(score.ToString, WinW div 2, 50);
  end;

  procedure cCTCEng.HandleEvent(const aEvent : TSDL_Event;
  var Handled : Boolean; var ExitProg : Boolean);
  begin
    inherited HandleEvent(aEvent, Handled, ExitProg);
    if ExitProg then Exit; { CHX: Inherited Draw don't change ExitProg. }

    { CHX: Some common events for fast reference, CTRL+MAYS+U removes comments
        while selecting the block.
      You can see full list in sdlevents.inc
      Window and general quit events are handled automatically in parent.
      Escape key is mapped to exit the program too.
    }

    case aEvent.type_ of
      SDL_KEYDOWN : // (key: TSDL_KeyboardEvent);
      begin
        b.applyForce(Point3DF(0, -5));
        //case aEvent.key.keysym.sym of
        //  //SDLK_UP : ;
        //  //SDLK_DOWN : ;
        //  //SDLK_LEFT : ;
        //  //SDLK_RIGHT : ;
        //  //SDLK_SPACE : ;
        //  else
        //    ;
        //end;
      end;

        //SDL_MOUSEMOTION : // (motion: TSDL_MouseMotionEvent);
        //SDL_MOUSEBUTTONUP : // (button: TSDL_MouseButtonEvent);
        //SDL_MOUSEBUTTONDOWN : // (button: TSDL_MouseButtonEvent);
        //SDL_MOUSEWHEEL : // (wheel: TSDL_MouseWheelEvent);

      else
        ;
    end;
  end;

  { Main program }

var
  BaseFolder : string;
  CTCEng : cCTCEng;

  {$R *.res}

begin
  // Changing base folder to parents exe folder.
  BaseFolder := ExtractFileDir(ExcludeTrailingPathDelimiter(ProgramDirectory));
  ChDir(BaseFolder);

  // Standard format setting (for .ini and other conversions)
  // This overrides user local settings which can cause errors.
  StandardFormatSettings;

  try
    CTCEng := cCTCEng.Create(ApplicationName, WinW, WinH, True, False);
    CTCEng.Config.DefFontSize := WinH div 25;
    // Actually,they are less than 25 lines because of LineHeight
    CTCEng.Config.DefFontColor := SDLColor(255,255,255,255);
    CTCEng.Config.DefFontFile := 'FreeMonoBold.ttf';  
    CTCEng.ShowFrameRate := True;
    CTCEng.Init;
    CTCEng.Run;
  finally
    CTCEng.Free;
  end;
end.
{
This source is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free
Software Foundation; either version 3 of the License, or (at your option)
any later version.

This code is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
details.

A copy of the GNU General Public License is available on the World Wide Web
at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
to the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
MA 02111-1307, USA.
}
