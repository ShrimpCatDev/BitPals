local wrld={}

function wrld:enter(prev,args)
    world=bump.newWorld(24)
    local m=args or "test"
    map=sti("assets/tilemap/"..m..".lua",{"bump"})
    map:bump_init(world)

    

    local Base = require("class/player")
    b = Base(10,10)

    cam={x=0,y=0,gx=0,gy=0}

    map.layers["collision"].visible=false
end

function wrld:update(dt)
     if not talkies.isOpen() then
        b:update(dt)
        for k,v in ipairs(map.layers["collision"].objects) do
            if collision(v.x,v.y,b.x,b.y,v.width,v.height,b.w,b.h) then
                if v.properties.kind=="msg" and input:pressed("action") then
                    local title=v.properties.title or ""
                    talkies.say(title,v.properties.msg)
                elseif v.properties.kind=="room" and input:pressed("action") then
                    gs.switch(state["world"],v.properties.room)
                end
            end
        end
    else
        if input:pressed("action") then
            talkies.onAction()
        elseif input:pressed("up") then
            talkies.prevOption()
        elseif input:pressed("down") then
            talkies.nextOption()
        end
    end

    map:update(dt)
    cam.gx,cam.gy=math.floor(b.x+b.w/2-conf.gW/2),math.floor(b.y+b.h/2-conf.gH/2)
    cam.gx=clamp(cam.gx,0,(map.width*map.tilewidth)-conf.gW)
    cam.gy=clamp(cam.gy,0,(map.height*map.tileheight)-conf.gH)
    local s=5
    cam.x,cam.y=lerpDt(cam.x,cam.gx,s,dt),lerpDt(cam.y,cam.gy,s,dt)
    cam.x=clamp(cam.x,0,(map.width*map.tilewidth)-conf.gW)
    cam.y=clamp(cam.y,0,(map.height*map.tileheight)-conf.gH)
end

function wrld:draw()
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

return wrld