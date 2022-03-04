Graphics = love.graphics
ww = Graphics\getWidth!
wh = Graphics\getHeight!

Style = {
  ["dark-green-neon"]: {
    colors: {
      downColor: { 0.0274509803922 ,0.0274509803922 ,0.0274509803922 }
      hoverColor: { 0.2, 0.2, 0.2 }
      upColor: { 0.0980392156863, 0.101960784314, 0.0980392156863 }
      disabledColor: { 0.0980392156863, 0.101960784314, 0.0980392156863 }
      strokeColor: { 0.149019607843, 0.929411764706, 0.286274509804}
      fontColor: { 1, 1, 1 }
      backgroundColor: { 0.0392156862745, 0.0392156862745, 0.0392156862745 }
      contentBackgroundColor: { 0.0392156862745, 0.0392156862745, 0.0392156862745 }
      scrollBar: { 0.14, 0.14, 0.14 }
    }

    common: {
      stroke: 2
      fontSize: 16
      iconAndTextSpace: 8
    }

    button: {
      width: 100
      height: 50
      rx: 10
      ry: 10
    }

    scrollBar: {
      width: 13
      height: 13
    }

    content: {
      -- box
      width: ww/2
      height: wh/2
      -- Circle/Polygon
      radius: ww/4
      rx: 1
      ry: 1
    }

    circleButton: {
      radius: 30
    }

    polyButton: {
      radius: 10
    }
  }
}


Style
