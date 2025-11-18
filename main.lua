require("init")

function love.load()
    deep=deeplib:new()

    world=bump.newWorld(24)

    font = require("assets/font/skull")
    lg.setFont(font)
    shove.createLayer("game")

    lutEffect=love.graphics.newShader("shaders/lut.glsl")
    pal=lg.newImage("assets/lut.png")
    pal:setFilter("nearest","nearest")
    lutEffect:send("lut",pal)

    shove.addEffect("game",lutEffect)

    map=sti("assets/tilemap/test.lua",{"bump"})
    map:bump_init(world)

    local Base = require("class/player")
    b = Base(10,10)

    cam={x=0,y=0}

    shader={stripe=lg.newShader("shaders/stripe.glsl")}
end

function love.update(dt)
    input:update()
    b:update(dt)
    map:update(dt)
    cam.x,cam.y=b.x+b.w/2-conf.gW/2,b.y+b.h/2-conf.gH/2
    cam.x=clamp(cam.x,0,(map.width*map.tilewidth)-conf.gW)
    cam.y=clamp(cam.y,0,(map.height*map.tileheight)-conf.gH)
    shader.stripe:send("time",love.timer.getTime())
end 


function love.draw()
    beginDraw()
        lg.push()
        local cx,cy=math.floor(-cam.x),math.floor(-cam.y)
        lg.translate(cx,cy)

        for _, layer in ipairs(map.layers) do
            if layer.visible and layer.opacity > 0 then
                if layer.properties.overPlayer then
                    deep:queue(math.floor(b.y)+1,function()
                        map:drawLayer(layer)
                    end)
                else
                    map:drawLayer(layer)
                end
            end
        end

        b:draw()

        deep:draw()     

        lg.setColor(1,1,1,1)
        lg.translate(0,0)
        lg.pop()
    endDraw()
end
