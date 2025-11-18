local conf = {}

conf.gW = 288
conf.gH = 192

conf.wW = conf.gW*4
conf.wH = conf.gH*4

conf.textureFilter = "nearest"
conf.fit = "aspect"
conf.render="layer"
conf.vsync=true

conf.input={
    controls={
        up={"key:up"},
        down={"key:down"},
        left={"key:left"},
        right={"key:right"},
        action={"key:z"}
    },
    pairs={
        move={'left','right','up','down'}
    },
    joystick = love.joystick.getJoysticks()[1],
}

return conf