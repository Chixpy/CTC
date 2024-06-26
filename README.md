# The Coding Train Challenges

Initially this ports of [The Coding Train Challenges](http://codingtra.in) 
by Daniel Shiffman were used for testing SDL2 and creating a basic engine in
FPC/Lazarus in [CHXPas](https://github.com/Chixpy/CHXPas). But after doing many
challenges, I moved them to their own repository.

Basically, Processing code is ported "as is", althougth it is not very optimized
or Pascal friendly. The main changes are:

  - No Garbage Collector, so reserved dynamic memory and objects are freed
    manually.
  - Processing's Draw is splitted in cCTCEng `Compute` and `Draw` methods.
    - `cCTCEng.Compute`: To update program state.
    - `cCTCEng.Draw`: Usually to implement Show/Draw methods of created classes.
  - Console output is displayed in SDL Window, although we can create
    applications with a console window and WriteLn (and ReadLn) strings.
  - HUE colors are changed to grayscales, at least until a RGB(A)<->HSL/V(A)
    function is implemented.

Some day, maybe, improved and better "Pascalized" version of programs and
classes will be done while ucSDL2Engine is evolving as needed.

## SDLProcessing.lpi

This is the main base program to simulate Processing. To use it simply open and
`Save Proyect As...` with a new name. NOTE: Doing this only updates unit folders
in current build mode, then you must copy then to the other in project options.

This is not the prefered way of using cCHXSDL2Engine; because in Pascal
every class is in its own unit usually (unless it's a package), instead
creating a child class in main program file.

Pascal doesn't have Garbage Collector as is, so allocated memory and objects
must be freed. In FPC, we can make reference counted interfaced objects wich
can autofree, but it's easier free them manually.

`ExitProg` var is used to Finish the program in `Compute` and `HandleEvent`.

Processing's `Draw` is splited in `Compute` and `Draw`. Both are called
every frame. `Compute` has FrameTime var with millisecond passed between
frames.

The pourpose of `Draw` in the main program is for implementation of
`Show`/`Draw`/etc. methods of classes. I'm not sure wich is the best way to
implement them in this ports. (pass SDLRenderer as parameter or as property of
an common ancestor class).

Some Events are listed and commented out to have an easy reference, and window
events and any quit event is handled automatically. Some basic interface
components handle automatically their related events. If not overrided or
already handled some default keys are defined:

  - `Esc` key is mapped to exit the program.
  - `F11` will toggle to show framerate in window title.
  - `Tab` change current focused component.

If window is resized, SDL Renderer automatically stretch image to its actual
size. If soft renderer is used it will be scaled by integer values, because
it shows vertical black stripes on some gfx primitives ¿?.

## Done

Here are the coding challenges ported. Sorted by when they were ported.

| # | Name | Comments |
|---:|:---|:---|
| CTC001 | Starfield | Testing SDL_RenderXXX and SDL_GFX functions. Manual tweak of simple coordinates tranformations (PMM) |
| CTC004 | Purple Rain |  |
| CTC005 | Space Invaders |  |
| CTC003 | The Snake Game | First Keyboard event handling |
| CTC006 | Mitosis Simulation | First Mouse event handling |
| CTC010 | Maze Generator |  |
| CTC013 | Reaction Diffusion Algorithm | Direct renderer pixel access. (Redone later with direct texture pixel access) |
| CTC015 | Object-Oriented Fractal Trees |  |
| CTC017 | Space Colonization |  |
| CTC019 | Superellipse | First UI pseudo-component, a TrackBar. |
| CTC021 | Mandelbrot | Direct texture pixel access. (And redone later with direct renderer pixel access) |
| CTC022 | Julia Set |  |
| CTC023 | 2D Supershapes |  |
| CTC027 | Fireworks (2D) |  |
| CTC028 | Metaballs |  |
| CTC031 | Flappy Bird | First program with text, so a way to render text was implemented. |
| CTC033 | Poisson-disc Sampling | |
| CTC034 | Diffusion-Limited Aggregation | |
| CTC035.1 | Traveling Salesperson (Random Swap) | SDL_RenderDrawLines vs polygonColor |
| CTC035.2 | Lexicographic Order |  |
| CTC035.3 | Traveling Salesperson (Lexicographic Order) | Speeding things up in compute with a fixed number of itertions, some day this will be changed to dynamic. |
| CTC035.4 | Traveling Salesperson (Genetic Algorithm) | First genetic algorittm ported |
| CTC036 | Blobby! | I had to implement a Perlin noise algorithm...<br />This time from [Hugo Elias](http://web.archive.org/web/20160325134143/http://freespace.virgin.net/hugo.elias/models/m_perlin.htm|) |
| CTC037 | Diastic Machine | Implemented raw user text input. We can show console... but result is shown in SDL Window. |
| CTC038 | Word Interactor | First actual UI components and their events. A TextEdit and a Button components.  |
| CTC039 | Mad Libs Generator | Using Local data and no RegExp |
| CTC040.1 | Word Counter (P5) | It's the same as CTC040.2, implemented as CTC040_2 |
| CTC040.2 | Word Counter (Processing)| It's the same as CTC040.1 |
| CTC040.3 | TF-IDF |  |
| CTC042.1 | Markov Chain | Github code is a little different from the video algorithm |
| CTC042.2 | Markov Chain Name Generator |  |
| CTC044 | AFINN-111 Sentiment Analysis | It's easier read .txt file in Pascal. |
| CTC046 | Asteroids | Manual tweak of PMM manipulations. |

## Skipped

Reasons to skip:

| # | Reason | Name |
|---:|:--:|:---|
| CTC002 | 3D | Menger Sponge Fractal |
| CTC007 | PMM | Solar System (2D) |
| CTC008 | 3D | Solar System (3D) |
| CTC009 | 3D | Solar System (3D) with textures |
| CTC011 | 3D | 3D Terrain Generation with Perlin Noise |
| CTC012 | 3D | The Lorenz Attractor |
| CTC014 | PMM | Recursive Fractal Trees |
| CTC016 | PMM | Fractal Trees - L-System |
| CTC018 | 3D | 3D Fractal Trees |
| CTC020 | TXL | 3D Cloth with Toxiclibs |
| CTC024 | PMM | Perlin Noise Flow Field |
| CTC025 | 3D | Spherical Geometry |
| CTC026 | 3D | 3D Supershapes |
| CTC027 | 3D | Fireworks (3D) |
| CTC029 | PMM | Smart Rockets in p5.js |
| CTC030 | PMM | Phyllotaxis |
| CTC032.1 | PMM | Agar.io |
| CTC032.2 | PMM & S/C | Agar.io |
| CTC041 | SND | Clappy Bird |
| CTC043 | TRC | Context-Free Grammar |
| CTC045 | FDB | Saving p5.js Drawings to Firebase |

  - 3D: Not done now, because needs a 3D engine; they can be done with
      OpenGL/Vulkan setup (SDL, TBGRABitmap or any other OpenGl context).
  - FDB: Use Firebase and personal API key, etc.
  - PMM: Not done because Processing coordinate matrix manipulations
    (pushMatrix, rotate, translate, popMatrix, etc.). They change the
    coordinate system in a stack and apply to all points to make relative
    translations and rotations. Not sure how to implement it:
    - Manually tweak drawing of points and lines.
    - Maybe creating a stack of new rendering textures on pushMatrix. They
      can be rotated, translated and zoomed, then render in parent texture
      on popMatrix. But, we can't draw on negative coords
    - Or making a wrapper of all drawing function that makes all
      transformations before actual drawing.
    - Or, without SDL, TBGRABitmap has TBGRACanvas2D wich simulates JavaScript
      Canvas with rotate, scale, translate, save (pushMatrix) and
      restore (popMatrix). But I need to create a new engine based on
      TBGRABitmap (and maybe I can redo all SDL examples in TBGRABitmap too
      :-P ).
  - TRC: It uses tracery.js: a story-grammar generation library.
  - TXL: Use toxiclibs physics library.
  - S/C: Use of Server / Client sockets.
  - SND: Uses microphone input. CTC041 its nearly done, but I don't know how
      actually interpret stream data in callback function, and extract the
      volume as needed.

Not Skipped now:

  - TXT: Draw text with graphics.
  - EVN: Keyboard or mouse events (They were skipped before uploaded to Github).

## ToDo

| # | Name | Pre-comments |
|---:|:---|:---|
| CTC047 | Pixel Sorting in Processing | Pixels are sorted by HUE... |
| CTC048 | White House Social Media Data Visualization | JSON load, fcl-json |
| CTC049 | Photo Mosaic with White House Social Media Images | Well, I must search a free set of images |
| CTC050 | Circle Packing |  |
| CTC051 | A* Pathfinding Algorithm |  |
| CTC052 | Random Walker | This is an implementation form Code of the Nature book by Shiffman, CHXPas have already one Randomwalker implemented |
| CTC053 | Random Walker with Vectors and Lévy Flight |  |
| CTC054 | Islamic Star Patterns |  |
| CTC055 | Mathematical Rose Patterns |  |
| CTC056 | Attraction and Repulsion Forces |  |
| CTC057 | Mapping Earthquake Data |  |
| CTC058 | 3D Earthquake Data Visualization |  |
| CTC059 | Steering Behaviors |  |
| CTC060 | Butterfly Generator |  |
| CTC061 | Fractal Spirograph |  |
| CTC062 | Plinko with Matter.js |  |
| CTC063 | Texturing Cloth Simulation |  |
| CTC064 | Kinematics |  |
| CTC065 | Binary Tree |  |
| CTC066 | JavaScript Countdown Timer |  |
| CTC067 | Pong! |  |
| CTC068 | Breadth-First Search |  |
| CTC069 | Evolutionary Steering Behaviors |  |
| CTC070 | Nearest Neighbors Recommendation Engine |  |
| CTC071 | Minesweeper |  |
| CTC072 | Frogger |  |
| CTC073 | Acrostic |  |
| CTC074 | Clock |  |
| CTC075 | Wikipedia API |  |
| CTC076 | 10Print |  |
| CTC077 | Recursion |  |
| CTC078 | Simple Particle System |  |
| CTC079 | Number Guessing Chatbot |  |
| CTC080 | Voice Chatbot with p5.Speech |  |
| CTC081 | Circle Morphing |  |
| CTC082 | Image Chrome Extension - The Ex-Kitten-sion! |  |
| CTC083 | Chrome Extension with p5.js Sketch - Doodle Chrome Extension |  |
| CTC084 | Word Definition Chrome Extension |  |
| CTC085 | The Game of Life |  |
| CTC086 | Cube Wave by Bees and Bombs |  |
| CTC087 | 3D Knots |  |
| CTC088 | Snowfall |  |
| CTC089 | Langton's Ant |  |
| CTC090 | Floyd-Steinberg Dithering |  |
| CTC091 | Snakes & Ladders |  |
| CTC092 | XOR Problem |  |
| CTC093 | Double Pendulum |  |
| CTC094 | 2048 Sliding Puzzle Game |  |
| CTC095 | Approximating the Value of Pi |  |
| CTC096 | Visualizing the Digits of Pi |  |
| CTC097 | The Book of Pi |  |
| CTC098 | Quadtree |  |
| CTC099 | Neural Network Color Predictor |  |
| CTC100 | Neuroevolution Flappy Bird |  |
| CTC101 | May the 4th Scrolling Text |  |




