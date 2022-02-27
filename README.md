# MeowUI

STATUS : (Alpha) Under development.

Minimalist and light-weight library based on catui https://github.com/wilhantian/catui.

You can find the demo here : https://github.com/Tourahi/MeowUI-Demo


## How to make a control ?

* Firstly you need to require MeowUI in the main or in the file where you want to define the new control class.

  * ` assert require "MeowUI"`

* Now all you have to do is create a control class that extends MeowUI.Control.

  ```lua
  class Button extends MeowUI.Control
    new: =>
      -- Send Bounding box type to the parent constructor.
      super "Box" -- Currently Bounding box can be a Circle also.
  
      -- Control properties example
      @width = 100
      @height = 50
      @stroke = 1
      @font = Graphics.newFont 16
      @iconAndTextSpace = 8
      @textDrawable = Graphics.newText @font, ""
      ...
  
      -- Attach class methods to events
      -- The method will be executed every time the event attached to it is fired.
      -- See: https://tourahi.github.io/MeowUI/classes/Event.html#Event\on
      @on "UI_DRAW", @onDraw, @



    onDraw: =>
      -- Bounding box you can use in drawing the control
      box = @getBoundingBox!
    
      -- Draw whatever you want just keep in mind the type of the boundingBox you are using.
      -- Dynamic Bbox type will be added in future releases.
    
      --              	For the full example see:
      --https://github.com/Tourahi/MeowUI/blob/master/Controls/Button.moon



  ```

  * And you are DONE. You can be as creative as you want.
  * If you created some cool stuff and you want to contribute Pull requests are welcome.

* Finally in the main

  ```lua
  -- Always require MeowUI before any control classes.
  assert require "MeowUI"

  Button = assert require "MeowUI.Controls.Button"
  Graphics = love.graphics

  with love
    .load = ->
      -- The manager instance.
      -- This instance is the engine of MeowUI.
      -- See: https://tourahi.github.io/MeowUI/classes/Manager.html
      export manager = MeowUI.manager

      -- Root control.
      -- See: https://tourahi.github.io/MeowUI/classes/Root.html
      root = manager\getRoot!

      -- Create the button.
      -- Button extends Control so naturally it has all of Controls methods + It's own.
      exit = Button!
      with exit
        \setPos 100, 100
        \setEnabled true
        \setText "PRESS"
        \onClick ->
          print "Clicked"


      -- Add exit btn as a child of the root core container. (It's just a Control).
      -- You can add it to the popUp or Option or Tip Containers.
      -- Just keep in minds all of these have different depths.
      -- See InitContainers: https://github.com/Tourahi/MeowUI/blob/master/src/Core/Root.moon
      root\addCoreChild exit

      -- Now all you have to do is call the manager callbacks
      -- inside the corresponding love2D callbacks.
    .update = (dt) ->
      manager\update dt

    .draw = ->
      manager\draw!

    .mousepressed = (x, y, button) ->
      manager\mousepressed x, y, button


    .keypressed = (key, is_r) ->
      manager\keypressed key, is_r


    .mousemoved = (x, y, button) ->
      manager\mousemoved x, y, button

    .mousereleased = (x, y, button) ->
      manager\mousereleased x, y, button

    .wheelmoved = (x, y) ->
      manager\wheelmoved x, y

    .keyreleased = (key) ->
      manager\keyreleased key

    .textinput = (text) ->
      manager\textinput text

  ```



###### Status

* Core : Done
* Example Controls : To-Do

