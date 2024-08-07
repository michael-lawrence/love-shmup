--- @module 'shmup.entities.gun'
--- @class shmup.entities.Gun
--- @field position shmup.drawing.Point The coordinates where the gun currently is.
--- @field scale shmup.drawing.Point The scale of the image being rendered.
--- @field rotation number The rotation to render the image.
--- @field speed number The speed in pixels that the gun will move each frame.
--- @field canvas love.Canvas The canvas to draw the gun on.
--- @field blur shmup.shaders.Blur The blur shader to use when drawing the gun.
--- @field lastBulletFired number The time in seconds that the last bullet was fired.
--- @field image love.Image The image to draw the gun on.
--- @field imageSize shmup.drawing.Point The size of the image being rendered.
--- @field bullets table A table of all the bullets that are currently in flight.
local Gun = {}

local Point = require('shmup.drawing.point')
local Bullet = require('shmup.entities.bullet')
local Blur = require('shmup.shaders.blur')
local G = love.graphics

--- Creates a new gun instance.
--- @param imagePath string The path to the image to use for the gun.
--- @return shmup.entities.Gun Gun The gun instance.
function Gun:new(imagePath)
    local o = {
        position = Point:new(0, 0),
        scale = Point:new(0.35, 0.35),
        rotation = 0,
        speed = 10,
        canvas = G.newCanvas(),
        blur = Blur:new(),
        lastBulletFired = os.clock(),
        image = G.newImage(imagePath),
        bullets = {},
    }
    o.imageSize = Point:new(o.image:getDimensions())
    o.image:setFilter('nearest', 'linear')

    setmetatable(o, self)
    self.__index = self

    return o
end

--- Draws the bullets on the screen at their current position, rotation, and scale.
function Gun:draw()
    local oldCanvas = G.getCanvas()
    G.setCanvas(self.canvas)
    G.clear()

    self.blur:draw()

    for _, bullet in ipairs(self.bullets) do
        bullet:draw()
    end

    self.blur:reset()

    G.setCanvas(oldCanvas)
    G.draw(self.canvas)
end

--- Sets the position of the gun.
--- @param position shmup.drawing.Point The new position of the gun.
function Gun:setPosition(position)
    self.position:setPoint(position)
end

---Sets the scale of the gun.
--- @param scale shmup.drawing.Point The new scale of the gun.
function Gun:setScale(scale)
    self.scale:setPoint(scale)
end

--- Sets the rotation of the gun.
--- @param rotation number The new rotation of the gun, in radians.
function Gun:setRotation(rotation)
    self.rotation = rotation
end

---Sets the speed of the gun.
--- @param speed number The new speed of the gun.
function Gun:setSpeed(speed)
    self.speed = speed
end

--- Returns the width and height of the gun's image, scaled by the gun's scale.
--- @return shmup.drawing.Point point The size of the gun's image, scaled.
function Gun:getSize()
    return self.imageSize * self.scale
end

--- Updates the gun's position and applies a blur effect based on the gun's distance from the center of the screen.
--- This function calculates the distance between the gun's position and the center of the screen. If the distance is less than the `zeroRadius` value, the blur effect is set to zero. Otherwise, the blur effect is calculated based on the gun's distance from the center, using the `sensitivity` value to determine the strength of the effect.
--- @param dt number The time since the last update, in seconds.
function Gun:update(dt)
    self.blur:update(self.position)

    for i, bullet in ipairs(self.bullets) do
        bullet:update()

        if bullet.isDestroyed then
            self.bullets[i] = nil
        end
    end
end

--- Shoots a projectile
function Gun:shoot()
    local now = os.clock()

    if now - self.lastBulletFired < 0.01 then return end

    self.lastBulletFired = now

    local bullet = Bullet:new(self.image)
    local gunSize = self:getSize()
    local offset = Point:new(gunSize.x * 0.4, -10)
    local position = self.position + offset

    bullet.position:setPoint(position)
    table.insert(self.bullets, 1, bullet)
end

--- Checks if the gun's bullets intersect with the given rectangle.
--- For each bullet in the `bullets` table, this function checks if the bullet intersects with the given rectangle.
--- If an intersection is detected, the bullet is destroyed.
--- @param rect shmup.drawing.Rect The rectangle to check for intersections with the gun's bullets.
--- @return boolean true if an intersection is detected, false otherwise.
function Gun:destroyCollidingBullets(rect)
    local collisionDetected = false

    for _, bullet in ipairs(self.bullets) do
        if bullet:intersects(rect) then
            bullet:destroy()
            collisionDetected = true
        end
    end

    return collisionDetected
end

return Gun
