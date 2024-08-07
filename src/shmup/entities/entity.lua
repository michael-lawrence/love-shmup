--- @module 'shmup.entities.entity'
--- @class shmup.entities.Entity
--- @field position shmup.drawing.Point The coordinates where the entity currently is.
--- @field scale shmup.drawing.Point The scale of the image being rendered.
--- @field rotation number The rotation to render the image.
--- @field speed number The speed in pixels that the entity will move each frame.
--- @field canvas love.Canvas The canvas to draw the entity on.
--- @field image love.Image The image to draw the entity on.
--- @field imageSize shmup.drawing.Point The image to draw the entity on.
local Entity = {}

local Point = require('shmup.drawing.point')
local Rect = require('shmup.drawing.rect')
local G, W = love.graphics, love.window
local windowSize = Point:new(W.getMode())

--- Creates a new Entity object.
---
--- @param imagePath string The path to the image file to use for the entity.
--- @param o table An optional table of initial properties for the entity. If not provided, default values will be used.
--- @return shmup.entities.Entity The new Entity object.
function Entity:new(imagePath, o)
    local image = G.newImage(imagePath)
    image:setFilter('nearest', 'linear')

    o = o or {
        position = Point:new(0, 0),
        scale = Point:new(1, 1),
        rotation = 0,
        speed = 1,
    }

    o.canvas = G.newCanvas()
    o.image = image
    o.imageSize = Point:new(o.image:getDimensions())

    setmetatable(o, self)
    self.__index = self

    return o
end

--- Draws the entity on the screen.
--- The entity is first drawn to an internal canvas, which is then drawn to the main screen.
--- This allows the entity to be rotated and scaled without affecting the main screen.
function Entity:draw()
    local oldCanvas = G.getCanvas()

    G.setCanvas(self.canvas)
    G.clear()
    G.draw(self.image, self.position.x, self.position.y, self.rotation, self.scale.x, self.scale.y)
    G.setCanvas(oldCanvas)

    G.draw(self.canvas)
end

--- Updates the entity.
--- @param dt number The time since the last update, in seconds.
function Entity:update(dt)

end

--- Destroys the entity, removing it from the game.
function Entity:destroy()

end

--- Sets the position of the entity.
--- @param position shmup.drawing.Point The new position of the entity.
function Entity:setPosition(position)
    self.position:setPoint(position)
end

---Sets the scale of the entity.
--- @param scale shmup.drawing.Point The new scale of the entity.
function Entity:setScale(scale)
    self.scale:setPoint(scale)
end

--- Sets the rotation of the entity.
--- @param rotation number The new rotation of the entity, in radians.
function Entity:setRotation(rotation)
    self.rotation = rotation
end

---Sets the speed of the entity.
--- @param speed number The new speed of the entity.
function Entity:setSpeed(speed)
    self.speed = speed
end

--- Returns the width and height of the entity's image, scaled by the entity's scale.
--- @return shmup.drawing.Point point The size of the entity's image, scaled.
function Entity:getSize()
    return self.imageSize * self.scale
end

--- Moves the entity left by the entity's speed.
function Entity:moveLeft()
    self.position.x = math.max(0, self.position.x - self.speed)
end

--- Moves the entity right by the entity's speed.
function Entity:moveRight()
    local entitySize = self:getSize()
    self.position.x = math.min(windowSize.x - entitySize.x, self.position.x + self.speed)
end

--- Moves the entity up by the entity's speed.
function Entity:moveUp()
    self.position.y = math.max(0, self.position.y - self.speed)
end

--- Moves the entity down by the entity's speed.
function Entity:moveDown()
    local entitySize = self:getSize()
    self.position.y = math.min(windowSize.y - entitySize.y, self.position.y + self.speed)
end

--- Returns a rectangle representing the entity's position and size.
--- @return shmup.drawing.Rect The rectangle representing the entity's position and size.
function Entity:getRect()
    return Rect:new(self.position.x, self.position.y, self.imageSize.x, self.imageSize.y)
end

return Entity
