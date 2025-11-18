require("init")

function love.load()
    deep=deeplib:new()

    world=bump.newWorld(24)

    --font = require("assets/font/capy")
    font=lg.newFont("assets/font/monogram-extended.ttf",16)
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

    talkies.font=font
    talkies.padding=4
    talkies.rounding=2
    talkies.titleBackgroundColor=color("#065ab5")
    talkies.messageBackgroundColor=color("#1d2b53")
end

function love.update(dt)
    talkies.update(dt)
    input:update()
    if not talkies.isOpen() then
        b:update(dt)
    end
    map:update(dt)
    cam.x,cam.y=b.x+b.w/2-conf.gW/2,b.y+b.h/2-conf.gH/2
    cam.x=clamp(cam.x,0,(map.width*map.tilewidth)-conf.gW)
    cam.y=clamp(cam.y,0,(map.height*map.tileheight)-conf.gH)

    if input:pressed("action") then
        talkies.onAction()
    elseif input:pressed("up") then
        talkies.prevOption()
    elseif input:pressed("down") then
        talkies.nextOption()
    end
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
        talkies.draw()
    endDraw()
end

function love.keypressed(k)
    if k=="p" then
        talkies.say("mystical dev","hello world!")
        talkies.say("mystical dev","this is just a test, I'm working on dialouge things in this game so we can have a story!")
        talkies.say("mystical dev","shoutout to the talkies library, now i don't need to make my own dialog system...")
        talkies.say("mystical dev","hey, whats your favorite ice cream flavor by the way?",{options={{"chocolate",function() talkies.say("mystical dev","ew gross") end},{"vanilla",function() talkies.say("mystical dev","based") end}}})
    end
end
