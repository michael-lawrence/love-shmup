local Point = require('shmup.drawing.point')
local windowW, windowH = love.window.getMode()
local windowSize = Point:new({ x = windowW, y = windowH })

--- @class shmup.controllers.MovementController
--- @field position shmup.drawing.Point The coordinates where the entity currently is.
--- @field speed number The speed in pixels that the entity will move each frame.
--- @field size shmup.drawing.Point The size of the entity.
local P = {};

--- Constructs a new instance of the MovementController.
--- @param defaults table|nil An optional table to use as the new instance.
--- @return shmup.controllers.MovementController The new instance of the MovementController.
function P:new(defaults)
    defaults = defaults or {}

    local o = {
        speed = defaults.speed or 1,
        position = defaults.position or Point:new(),
        size = defaults.size or Point:new(),
    }

    setmetatable(o, self)
    self.__index = self

    return o
end

--- Moves the entity left by the entity's speed.
function P:left()
    self.position.x = math.max(0, self.position.x - self.speed)
end

--- Moves the entity right by the entity's speed.
function P:right()
    self.position.x = math.min(windowSize.x - self.size.x, self.position.x + self.speed)
end

--- Moves the entity up by the entity's speed.
function P:up()
    self.position.y = math.max(0, self.position.y - self.speed)
end

--- Moves the entity down by the entity's speed.
function P:down()
    self.position.y = math.min(windowSize.y - self.size.y, self.position.y + self.speed)
end

--- Sets the position of the entity.
--- @param position shmup.drawing.Point The new position of the entity.
function P:setPosition(position)
    self.position:setPoint(position)
end

---Sets the speed of the entity.
--- @param speed number The new speed of the entity.
function P:setSpeed(speed)
    self.speed = speed
end

---Sets the size of the entity.
--- @param size shmup.drawing.Point The new size of the entity.
function P:setSize(size)
    self.size = size
end

return P
