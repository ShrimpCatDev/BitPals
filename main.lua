require("init")

function love.load()
    font = require("assets/font/skull")
    lg.setFont(font)
    shove.createLayer("game")

    lutEffect=love.graphics.newShader("shaders/lut.glsl")
    pal=lg.newImage("assets/lut.png")
    pal:setFilter("nearest","nearest")
    lutEffect:send("lut",pal)

    shove.addEffect("game",lutEffect)

    map=sti("assets/tilemap/test.lua")

    local Base = require("class/player")
    b = Base(10,10)
end

function love.update(dt)
    input:update()
    b:update(dt)
    map:update(dt)
end 

function love.draw()
    beginDraw()
        map:draw()
        b:draw()
        love.graphics.setBlendMode("multiply", "premultiplied")
        lg.setColor(0.8,0,0,1)
        lg.rectangle("fill",80,80,32,32)
        lg.setColor(0.023,0.353,0.71,1)
        lg.rectangle("fill",80+32,80,32,32)
        lg.setColor(0,1,0,1)
        lg.rectangle("fill",80,80+32,32,32)

        love.graphics.setBlendMode("alpha")
        lg.setColor(0,0,0,0.7)
        lg.rectangle("fill",80+32,80+32,32,32)

        lg.setColor(1,1,1,1)
        
    endDraw()
end
