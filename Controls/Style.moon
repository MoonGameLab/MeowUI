love = love
Graphics = love.graphics
ww = Graphics\getWidth!
wh = Graphics\getHeight!

-- Style will be handled better in the future i promise :).

Style =

  ["dark-green-neon"]: {
    colors:
      downColor: { 0.0274509803922 ,0.0274509803922 ,0.0274509803922 }
      hoverColor: { 0.2, 0.2, 0.2 }
      upColor: { 0.0980392156863, 0.101960784314, 0.0980392156863 }
      disabledColor: { 0.0980392156863, 0.101960784314, 0.0980392156863 }
      strokeColor: { 0.149019607843, 0.929411764706, 0.286274509804}
      fontColor: { 1, 1, 1 }
      contentBackgroundColor: { 0.0392156862745, 0.0392156862745, 0.0392156862745 }
      scrollBar: { 0.14, 0.14, 0.14 }

    common:
      stroke: 2
      fontSize: 13
      iconAndTextSpace: 8

    button:
      width: 100
      height: 50
      rx: 10
      ry: 10

    textField:
      rx: 5
      ry: 5
      marginCorner: 18
      textAreaColor: { 0.0392156862745, 0.0392156862745, 0.0392156862745 }
      textColor: { 1, 1, 1 }

    scrollBar:
      width: 13
      height: 13

    content:
      -- box
      width: ww/2
      height: wh/2
      -- Circle/Polygon
      radius: ww/4
      rx: 1
      ry: 1

    circleButton:
      radius: 30

    polyButton:
      radius: 10
  }

Style
