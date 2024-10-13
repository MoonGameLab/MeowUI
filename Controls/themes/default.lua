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
        0.2,
        0.2,
        0.2
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
        0.149019607843,
        0.929411764706,
        0.286274509804
      },
      fontColor = {
        1,
        1,
        1
      },
      contentBackgroundColor = {
        0.0392156862745,
        0.0392156862745,
        0.0392156862745
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
    button = {
      width = 100,
      height = 50,
      rx = 10,
      ry = 10,
      borderLineStyle = "rough"
    },
    checkBox = {
      width = 25,
      height = 25,
      rx = 2,
      ry = 2,
      margin = 4,
      radius = 20,
      segments = 300,
      stroke = 3
    },
    textField = {
      rx = 5,
      ry = 5,
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
      ry = 1
    },
    circleButton = {
      radius = 30
    },
    polyButton = {
      radius = 10
    }
  }
}
return Default
