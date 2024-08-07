local Point = require('shmup.drawing.point')
local Rect = require('shmup.drawing.rect')
local G = love.graphics

--- @class shmup.entities.Projectile
--- @field position shmup.drawing.Point The coordinates where the projectile currently is.
--- @field scale shmup.drawing.Point The scale of the image being rendered.
--- @field rotation number The rotation to render the image.
--- @field speed number The speed in pixels that the projectile will move each frame.
--- @field image love.Image The image to use for the projectile
--- @field imageSize shmup.drawing.Point The size of the image being rendered.
--- @field canvas love.Canvas The canvas to render the projectile to.
local P = {}

--- Creates a new projectile instance.
--- @return shmup.entities.Projectile Projectile The projectile instance.
--- @param defaults table A table of initial properties for the projectile. If not provided, default values will be used.
function P:new(defaults)
    defaults = defaults or {}

    local o = {
        position = defaults.position or Point:new(),
        scale = defaults.scale or Point:new({ x = 0.25, y = 0.25 }),
        rotation = defaults.rotation or 0,
        speed = defaults.speed or 10,
        isDestroyed = false,
        canvas = G.newCanvas(),
        image = defaults.image,
    }

    local imageW, imageH = o.image:getDimensions()
    o.imageSize = Point:new({ x = imageW, y = imageH })

    setmetatable(o, self)
    self.__index = self

    return o
end

--- Draws the projectile on the screen at their current position, rotation, and scale.
function P:draw()
    if self.isDestroyed then return end

    local oldCanvas = G.getCanvas()
    G.setCanvas(self.canvas)
    G.clear()
    G.draw(self.image, self.position.x, self.position.y, self.rotation, self.scale.x, self.scale.y)
    G.setCanvas(oldCanvas)
    G.draw(self.canvas)
end

--- Returns the width and height of the player's image, scaled by the player's scale.
--- @return shmup.drawing.Point point The size of the player's image, scaled.
function P:getSize()
    return self.imageSize * self.scale
end

--- Returns a rectangle representing the projectile's position and size.
--- @return shmup.drawing.Rect The rectangle representing the projectile's position and size.
function P:getRect()
    return Rect:new({
        x = self.position.x,
        y = self.position.y,
        w = self.imageSize.x,
        h = self.imageSize.y,
    })
end

--- Moves the player up by the player's speed.
function P:moveUp()
    self.position.y = math.max(0, self.position.y - self.speed)
end

--- Updates the projectile's position and destroys the projectile if it has reached the top of the screen.
function P:update()
    if self.isDestroyed then return end

    local oldY = self.position.y
    self:moveUp()

    if oldY == self.position.y then
        self:destroy()
    end
end

--- Marks the projectile as destroyed, indicating it should no longer be drawn or updated.
function P:destroy()
    self.isDestroyed = true
end

--- Checks if the projectile's rectangular area intersects with the given rectangle.
--- @param rect shmup.drawing.Rect The rectangle to check for intersection.
--- @return boolean true if the projectile's area intersects with the given rectangle, false otherwise.
function P:intersects(rect)
    local projectileRect = self:getRect()
    return projectileRect:intersects(rect)
end

return P
