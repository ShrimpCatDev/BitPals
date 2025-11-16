local base = require("class/base")

local pl=base:extend()

function pl:new(x,y)
    pl.super.new(self,x,y)
    self.img=lg.newImage("assets/player/baseImg.png")

    self.spd=90
end

function pl:update(dt)
    pl.super.update(self,x,y)

    local x,y = input:get("move")
    self.vx=x*self.spd*dt
    self.vy=y*self.spd*dt

    self.x,self.y=self.x+self.vx,self.y+self.vy
end

function pl:draw()
    lg.draw(self.img,self.x,self.y)
end

return pl