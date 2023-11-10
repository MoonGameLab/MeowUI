love = love
Graphics = love.graphics
ww = Graphics\getWidth!
wh = Graphics\getHeight!

-- Author : T.amine
Default =

  [1]: {
    colors:
      downColor: { 0.0274509803922 ,0.0274509803922 ,0.0274509803922 }
      hoverColor: {0.698, 0.725, 0.749}
      upColor: { 0.0980392156863, 0.101960784314, 0.0980392156863 }
      disabledColor: { 0.0980392156863, 0.101960784314, 0.0980392156863 }
      strokeColor: { 0.471, 0.471, 0.439}
      fontColor: { 1, 1, 1 }
      contentBackgroundColor: {0.082, 0.086, 0.09}
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
      borderLineStyle: "smooth"

    checkBox:
      width: 25
      height: 25
      rx: 2
      ry: 2
      margin: 4
      radius: 20
      segments: 300
      stroke: 3


    textField:
      rx: 5
      ry: 5
      marginCorner: 18
      textAreaColor: { 0.0392156862745, 0.0392156862745, 0.0392156862745 }
      textColor: { 1, 1, 1 }
      keyChronoRepeatTime: 0.01

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
      outlineSegNbr: 1000 -- TO-DO: seperate from normal drawing

    polyButton:
      radius: 10
  }

Default
