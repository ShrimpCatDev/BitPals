local wrld={}
ids=require("roomIds")
wrld.targetRoom=nil

function wrld:enter(prev,args)
    
    world=bump.newWorld(24)
    local m=args or "test"
    map=sti("assets/tilemap/"..m..".lua",{"bump"})
    map:bump_init(world)

    local Base = require("class/player")
    pl = Base(10,10)

    print(self.targetRoom)
    for k,v in ipairs(map.layers["collision"].objects) do
        if v.name==self.targetRoom then
            pl.x,pl.y=(v.x+v.width/2)-pl.w/2,pl.y
            world:update(pl,pl.x,pl.y)
        end
    end

    cam={x=math.floor(pl.x+pl.w/2-conf.gW/2),y=math.floor(pl.y+pl.h/2-conf.gH/2),gx=math.floor(pl.x+pl.w/2-conf.gW/2),gy=math.floor(pl.y+pl.h/2-conf.gH/2)}

    map.layers["collision"].visible=false
end

function wrld:update(dt)
     if not talkies.isOpen() then
        pl:update(dt)
        for k,v in ipairs(map.layers["collision"].objects) do
            if collision(v.x,v.y,pl.x,pl.y,v.width,v.height,pl.w,pl.h) then
                if v.properties.kind=="msg" and input:pressed("action") then
                    local title=v.properties.title or ""
                    talkies.say(title,v.properties.msg)
                elseif v.properties.kind=="room" and input:pressed("action") then
                    ids:write(v.name,v.x+v.width/2,v.y)
                    self.targetRoom=v.properties.door
                    print(self.targetRoom)
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
    cam.gx,cam.gy=math.floor(pl.x+pl.w/2-conf.gW/2),math.floor(pl.y+pl.h/2-conf.gH/2)
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
                    deep:queue(math.floor(pl.y)+1,function()
                        map:drawLayer(layer)
                    end)
                else
                    map:drawLayer(layer)
                end
            end
        end

        pl:draw()

        deep:draw()     

        lg.setColor(1,1,1,1)
        lg.translate(0,0)
        lg.pop()
        talkies.draw()
    endDraw()
end

return wrld