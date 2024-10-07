# **MeowUI**

[LÖVE](https://love2d.org/) GUI library written in MoonScript.

Inspired by [CatUI](https://github.com/wilhantian/catui), but the core modules were heavily modified. Some inspiration was also taken from [LoveFrames](https://github.com/linux-man/LoveFrames).

Currently based on LÖVE 11.4 MoonScript 0.5 

#### DOCS 

https://moongamelab.github.io/MeowUI/

### Demo

​	See : https://github.com/Tourahi/MeowUI-Demo

​	Note : Don't forget to clone with "--recurse-submodules" to clone utf8 submodule also.

![Scrn](https://github.com/MoonGameLab/MeowUI/blob/master/public/Scrn.png)	

**Third-party**

​	utf8.lua : https://github.com/Stepets/utf8.lua

# **Hello, World!**

```lua
-- Always require MeowUI before any control 
assert require "MeowUI"	
-- Include a control. 
-- (You can expand your own controls based on your needs. See controls for examples) 
Button = assert require MeowUI.c_cwd .. "Button"

with love
  .load = ->
    -- Get the manager (Takes care of all events). <Singleton>
    export manager = MeowUI.manager
    -- Get the root control. <Singleton>
    root = manager\getRoot!

    -- And lets make a fancy polygon shaped button.
    bPoly = with Button "Polygon"
      \setPosition 200, 200
      \setRadius 25
      \setSides 6

    -- Finally add the new button as a child to the root so it can be drawn updated etc...
    root\addChild bPoly

  .update = (dt) ->
    manager\update dt

  .draw = ->
    manager\draw!

  .mousepressed = (x, y, button) ->
    manager\mousepressed x, y, button

  .keypressed = (key, is_r) ->
    manager\keypressed key, is_r

  .mousemoved = (x, y, dx, dy, istouch ) ->
    manager\mousemoved x, y, dx, dy, istouch

  .mousereleased = (x, y, dx, dy, istouch ) ->
    manager\mousereleased x, y, dx, dy, istouch

  .wheelmoved = (x, y) ->
    manager\wheelmoved x, y

  .keyreleased = (key) ->
    manager\keyreleased key

  .textinput = (text) ->
    manager\textinput text


```

