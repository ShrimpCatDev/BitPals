local ids={
    rooms={}
}

function ids:write(roomName,x,y)
    self.rooms[roomName]={x=x,y=y}
end

function ids.read(roomName)
    return self.rooms[roomName]
end

return ids