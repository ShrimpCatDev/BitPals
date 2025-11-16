require("init")

function love.load()
    font = require("assets/font/skull")
    lg.setFont(font)
    shove.createLayer("game")

    local Base = require("class/player")
    b = Base(10,10)
end

function love.update(dt)
    input:update()
    b:update(dt)
end 

function love.draw()
    beginDraw()
        b:draw()
    endDraw()
end
