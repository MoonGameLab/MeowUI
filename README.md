# MeowUI

Minimalist and light-weight library based on catui https://github.com/wilhantian/catui.

### Improvements

* Unlike catui this library has NO external dependencies.
* Has a built-in Chrono class (Timers manager). see Docs.
* Has the same level of extensibility as catui and more since it is based on moonscript class system.
* Lighter than catui.
* A LOT of assertion which improves the readability of the code and helps detect bugs.
* Unlike catui the controls have a unique id which prevent from attaching the same child multiple times.
* Fully documented.



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
  
  -- 					 For the full example see:
  -- https://github.com/Tourahi/MeowUI/blob/master/Controls/Button.moon
  
  
  	
  ```

  * And you are DONE. You can be as creative as you want.
  * If you created some cool stuff and you want to contribute Pull requests are welcome.

  

###### Status 

* Core : Done
* Example Controls : To-Do 

