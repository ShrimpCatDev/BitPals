local base = require("class/base")

local pl=base:extend()

function pl:new(x,y)
    pl.super.new(self,x,y)
    
    self.img=lg.newImage("assets/player/anim.png")

    local g=anim8.newGrid(12,16,self.img:getWidth(),self.img:getHeight())

    self.anim={
        walk={
            anim8.newAnimation(g('1-4',2),0.1),
            anim8.newAnimation(g('1-4',1),0.1),
            anim8.newAnimation(g('1-4',3),0.1),
            anim8.newAnimation(g('1-4',4),0.1)
        },
        idle={
            anim8.newAnimation(g('1-1',2),0.1),
            anim8.newAnimation(g('1-1',1),0.1),
            anim8.newAnimation(g('1-1',3),0.1),
            anim8.newAnimation(g('1-1',4),0.1)
        }
    }

    self.anim.current=self.anim.walk[2]

    self.dir=2

    self.spd=90

    for k,v in ipairs(map.layers["collision"].objects) do
        if v.properties.playerSpawn then
            self.x,self.y=v.x-self.w/2,v.y-self.h/2
        end
    end
    local ax,ay,col,len=world:update(self,self.x,self.y)
end

function pl:update(dt)
    pl.super.update(self,x,y)

    local x,y = input:get("move")
    self.vx=x*self.spd*dt
    self.vy=y*self.spd*dt

    
    local ax,ay,col,len=world:move(self,self.x+self.vx,self.y+self.vy)
    self.x,self.y=ax,ay
    self.x=clamp(self.x,0,(map.width*map.tilewidth)-self.w)
    self.y=clamp(self.y,0,(map.height*map.tileheight)-self.h)

    local m=false
    if input:down("up") then
        self.dir=1
        m=true
    elseif input:down("down") then
        self.dir=2
        m=true
    elseif input:down("left") then
        self.dir=4
        m=true
    elseif input:down("right") then
        self.dir=3
        m=true
    end

    if m then
        self.anim.current=self.anim.walk[self.dir]
    else
        self.anim.current=self.anim.idle[self.dir]
    end

    self.anim.current:update(dt)
end

function pl:draw()
    deep:queue(math.floor(self.y),function()
        local x,y=math.floor(self.x),math.floor(self.y)
        lg.setColor(0,0,0,0.4)
        lg.rectangle("fill",x,y,self.w,self.h)
        lg.setColor(1,1,1,1)
        self.anim.current:draw(self.img,x-1,y-8,0,1,1,0,0)
    end)
end

return pl