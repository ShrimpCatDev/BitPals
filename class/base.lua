local base = object:extend()

function base:new(x,y,w,h)
    self.x=x or 0
    self.y=y or 0
    self.w=w or 14
    self.h=h or 14
    self.vx=0
    self.vy=0
end

function base:update(dt)

end

function base:draw()
    lg.rectangle("fill",self.x,self.y,self.w,self.h)
end

return base