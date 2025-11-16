require("init")

function love.load()
    font = require("assets/font/skull")
    lg.setFont(font)
    shove.createLayer("game")

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
    endDraw()
end
