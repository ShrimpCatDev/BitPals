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

    cam={x=0,y=0}
end

function love.update(dt)
    input:update()
    b:update(dt)
    map:update(dt)
    cam.x,cam.y=b.x+b.w/2-conf.gW/2,b.y+b.h/2-conf.gH/2
end 

function love.draw()
    beginDraw()
        lg.push()
        local cx,cy=math.floor(-cam.x),math.floor(-cam.y)
        lg.translate(cx,cy)
        map:draw(cx,cy)
        b:draw()

        lg.setColor(1,1,1,1)
        lg.translate(0,0)
        lg.pop()
        
    endDraw()
end
