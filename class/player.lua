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
    lg.setColor(0,0,0,0.4)
    lg.rectangle("fill",self.x,self.y,self.w,self.h-2)
    lg.setColor(1,1,1,1)
    lg.draw(self.img,self.x,self.y,0,1,1,0,self.img:getHeight()/2)
end

return pl