program CTC004;
{< The Coding Train Challenge #004 - Purple Rain }

// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/KkyIDI6rQJI
// Port: (C) 2024 Chixpy https://github.com/Chixpy
{$mode ObjFPC}{$H+}

uses
  Classes, SysUtils, CTypes, StrUtils, FileUtil, LazFileUtils, Math,
  SDL2, SDL2_GFX, SDL2_TTF, SDL2_Image,
  uCHXStrUtils,
  ucCHXSDL2Engine, uCHXSDL2Utils, uProcUtils,
  ucCTCDrop;

const
  { CHX: Renderer scales images to actual size of the window. }
  WinW = 800; { CHX: Window logical width. }
  WinH = 600; { CHX: Window logical height. }

  NDrops = 500;

type

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
    Drops : array of cCTCDrop;

  end;

  { cCTCEng }

  procedure cCTCEng.Setup;
  var
    i : integer;
    aDrop : cCTCDrop;
  begin
    SetLength(Drops, NDrops + 1);

    for i := 0 to NDrops do
    begin
      aDrop := cCTCDrop.Create(Random(WinW), RandomRange(-500, -50),
        Random(20));
      Drops[i] := aDrop;
    end;
  end;

  procedure cCTCEng.Finish;
  { CHX: Free any created objects. }
  var
    i : integer;
  begin
    for i := 0 to NDrops do
    begin
      Drops[i].Free;
    end;
  end;

  procedure cCTCEng.Compute(const FrameTime : CUInt32; var ExitProg : Boolean);
  var
    i : integer;
    aDrop : cCTCDrop;
  begin
    { CHX: If we want to pause when minimized or focus lost. }
    // if SDLWindow.Minimized then Exit;

    for i := 0 to NDrops do
    begin
      aDrop := Drops[i];
      aDrop.Fall;

      // Drop out of the window
      if (aDrop.y > WinH) then
      begin
        aDrop.y := RandomRange(-200, -100);
        aDrop.yspeed := map(aDrop.z, 0, 20, 4, 10);
      end;
    end;
  end;

  procedure cCTCEng.Draw;
  var
    i : integer;
    aDrop : cCTCDrop;
  begin
    SDL_SetRenderDrawColor(SDLWindow.PRenderer, 230, 230, 250, 255);
    SDL_RenderClear(SDLWindow.PRenderer);

    // Draw drops
    for i := 0 to NDrops do
    begin
      aDrop := Drops[i];

      // Drop.show
      thickLineRGBA(SDLWindow.PRenderer, round(aDrop.x),
        round(aDrop.y), round(aDrop.x),
        round(aDrop.y + aDrop.len),
        round(map(aDrop.z, 0, 20, 1, 5)),
        138, 43, 226, 255);
    end;
  end;

  procedure cCTCEng.HandleEvent(const aEvent : TSDL_Event;
  var Handled : Boolean; var ExitProg : Boolean);
  begin
    inherited HandleEvent(aEvent, Handled, ExitProg);
    if ExitProg then Exit; { CHX: Inherited Draw can change ExitProg. }

    { CHX: Some common events for fast reference, CTRL+MAYS+U removes comments
        while selecting the block.
      You can see full list in sdlevents.inc
      Window and general quit events are handled automatically in parent.
      Escape key is mapped to exit the program too.
    }

    //case aEvent.type_ of
    //  SDL_KEYDOWN : // (key: TSDL_KeyboardEvent);
    //  begin
    //      case aEvent.key.keysym.sym of
    //        //SDLK_UP : ;
    //        //SDLK_DOWN : ;
    //        //SDLK_LEFT : ;
    //        //SDLK_RIGHT : ;
    //        //SDLK_SPACE : ;
    //        else
    //          ;
    //      end;
    //  end;

    //  //SDL_MOUSEMOTION : // (motion: TSDL_MouseMotionEvent);
    //  //SDL_MOUSEBUTTONUP : // (button: TSDL_MouseButtonEvent);
    //  //SDL_MOUSEBUTTONDOWN : // (button: TSDL_MouseButtonEvent);
    //  //SDL_MOUSEWHEEL : // (wheel: TSDL_MouseWheelEvent);

    //  else
    //    ;
    //end;
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
    FreeAndNil(CTCEng);
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
