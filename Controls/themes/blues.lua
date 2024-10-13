local love = love
local Graphics = love.graphics
local ww = Graphics:getWidth()
local wh = Graphics:getHeight()
local Default = {
  [1] = {
    colors = {
      downColor = {
        0.0274509803922,
        0.0274509803922,
        0.0274509803922
      },
      hoverColor = {
        0.698,
        0.725,
        0.749
      },
      upColor = {
        0.0980392156863,
        0.101960784314,
        0.0980392156863
      },
      disabledColor = {
        0.0980392156863,
        0.101960784314,
        0.0980392156863
      },
      strokeColor = {
        0.471,
        0.471,
        0.439
      },
      fontColor = {
        1,
        1,
        1
      },
      scrollBar = {
        0.14,
        0.14,
        0.14
      }
    },
    common = {
      stroke = 2,
      fontSize = 13,
      iconAndTextSpace = 8
    },
    frame = {
      toolBarColor = {
        0.161,
        0.29,
        0.478
      },
      toolBarColorUnfocused = {
        0.62,
        0.62,
        0.576
      },
      contentBackground = {
        0.082,
        0.086,
        0.09
      },
      toolBarTitleColor = {
        1,
        1,
        1
      }
    },
    button = {
      width = 100,
      height = 50,
      rx = 10,
      ry = 10,
      borderLineStyle = "smooth"
    },
    checkBox = {
      width = 25,
      height = 25,
      rx = 2,
      ry = 2,
      margin = 3,
      radius = 20,
      segments = 300,
      stroke = 3,
      pressedColor = {
        0.741,
        0.761,
        0.831
      },
      borderLineColor = {
        0.361,
        0.365,
        0.38
      },
      borderLineStyle = "smooth"
    },
    textField = {
      rx = 15,
      ry = 15,
      marginCorner = 18,
      textAreaColor = {
        0.0392156862745,
        0.0392156862745,
        0.0392156862745
      },
      textColor = {
        1,
        1,
        1
      },
      keyChronoRepeatTime = 0.01
    },
    scrollBar = {
      width = 13,
      height = 13
    },
    content = {
      width = ww / 2,
      height = wh / 2,
      radius = ww / 4,
      rx = 1,
      ry = 1,
      backgroundColorFocuse = {
        0.082,
        0.086,
        0.09
      },
      backgroundColorUnFocuse = {
        0.808,
        0.804,
        0.859
      }
    },
    circleButton = {
      radius = 30,
      outlineSegNbr = 1000
    },
    polyButton = {
      radius = 10
    }
  }
}
return Default
