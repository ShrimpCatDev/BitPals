require("init")

function love.load()
    gs=require("lib/hump/gamestate")
    gs.registerEvents()
    deep=deeplib:new()

    --font = require("assets/font/capy")
    font=lg.newFont("assets/font/monogram-extended.ttf",16)
    lg.setFont(font)
    shove.createLayer("game")

    lutEffect=love.graphics.newShader("shaders/lut.glsl")
    pal=lg.newImage("assets/lut.png")
    pal:setFilter("nearest","nearest")
    lutEffect:send("lut",pal)

    shove.addEffect("game",lutEffect)

    talkies.font=font
    talkies.padding=4
    talkies.rounding=2
    talkies.titleBackgroundColor=color("#065ab5")
    talkies.messageBackgroundColor=color("#1d2b53")

    state={
        ["world"]=require("states/world")
    }
    gs.switch(state["world"])
end

function love.update(dt)
    talkies.update(dt)
    input:update()  
end 


function love.draw()
    
end

function love.keypressed(k)
    if k=="p" then
        talkies.say("mystical dev","hello world!")
        talkies.say("mystical dev","this is just a test, I'm working on dialouge things in this game so we can have a story!")
        talkies.say("mystical dev","shoutout to the talkies library, now i don't need to make my own dialog system...")
        talkies.say("mystical dev","hey, whats your favorite ice cream flavor by the way?",{options={{"chocolate",function() talkies.say("mystical dev","ew gross") end},{"vanilla",function() talkies.say("mystical dev","based") end}}})
    end
end
