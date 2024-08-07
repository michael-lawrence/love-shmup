local Point = require('shmup.drawing.point')
local Projectile = require('shmup.entities.projectile')
local Blur = require('shmup.shaders.blur')
local G = love.graphics

--- @module 'shmup.entities.projectile'
--- @class shmup.controllers.ProjectileController
--- @field position shmup.drawing.Point The coordinates where the projectile currently is.
--- @field scale shmup.drawing.Point The scale of the image being rendered.
--- @field rotation number The rotation to render the image.
--- @field speed number The speed in pixels that the projectile will move each frame.
--- @field canvas love.Canvas The canvas to draw the projectile on.
--- @field blur shmup.shaders.Blur The blur shader to use when drawing the projectile.
--- @field lastProjectileFired number The time in seconds that the last projectile was fired.
--- @field image love.Image The image to draw the projectile on.
--- @field imageSize shmup.drawing.Point The size of the image being rendered.
--- @field projectiles table A table of all the projectiles that are currently in flight.
local P = {}

--- Constructs a new instance of the ProjectileController.
--- @param defaults table|nil An optional table to use as the new instance.
--- @return shmup.controllers.ProjectileController The new instance of the ProjectileController.
function P:new(defaults)
    defaults = defaults or {}

    local o = {
        position = defaults.position or Point:new(),
        scale = defaults.scale or Point:new({ x = 0.35, y = 0.35 }),
        rotation = defaults.rotation or 0,
        speed = defaults.speed or 10,
        blur = Blur:new(),
        lastProjectileFired = os.clock(),
        projectiles = {},
        canvas = G.newCanvas(),
        image = G.newImage(defaults.imagePath),
    }

    o.image:setFilter('nearest', 'linear')

    local imageW, imageH = o.image:getDimensions()
    o.imageSize = Point:new({ x = imageW, y = imageH })

    setmetatable(o, self)
    self.__index = self

    return o
end

--- Updates the projectile's position and applies a blur effect based on the projectile's distance from the center of the screen.
--- This function calculates the distance between the projectile's position and the center of the screen. If the distance is less than the `zeroRadius` value, the blur effect is set to zero. Otherwise, the blur effect is calculated based on the projectile's distance from the center, using the `sensitivity` value to determine the strength of the effect.
--- @param dt number The time since the last update, in seconds.
function P:update(dt)
    self.blur:update(self.position)

    for i, projectile in ipairs(self.projectiles) do
        projectile:update()

        if projectile.isDestroyed then
            self.projectiles[i] = nil
        end
    end
end

--- Draws the projectiles on the screen at their current position, rotation, and scale.
function P:draw()
    local oldCanvas = G.getCanvas()
    G.setCanvas(self.canvas)
    G.clear()

    self.blur:draw()

    for _, projectile in ipairs(self.projectiles) do
        projectile:draw()
    end

    self.blur:reset()

    G.setCanvas(oldCanvas)
    G.draw(self.canvas)
end

--- Sets the position of the projectile.
--- @param position shmup.drawing.Point The new position of the projectile.
function P:setPosition(position)
    self.position:setPoint(position)
end

---Sets the scale of the projectile.
--- @param scale shmup.drawing.Point The new scale of the projectile.
function P:setScale(scale)
    self.scale:setPoint(scale)
end

--- Sets the rotation of the projectile.
--- @param rotation number The new rotation of the projectile, in radians.
function P:setRotation(rotation)
    self.rotation = rotation
end

---Sets the speed of the projectile.
--- @param speed number The new speed of the projectile.
function P:setSpeed(speed)
    self.speed = speed
end

--- Returns the width and height of the projectile's image, scaled by the projectile's scale.
--- @return shmup.drawing.Point point The size of the projectile's image, scaled.
function P:getSize()
    return self.imageSize * self.scale
end

--- Shoots a projectile
function P:shoot()
    local now = os.clock()

    if now - self.lastProjectileFired < 0.01 then return end

    self.lastProjectileFired = now

    local projectileSize = self:getSize()
    local offset = Point:new({ x = projectileSize.x * 0.4, y = -10 })
    local projectilePosition = self.position + offset
    local projectile = Projectile:new({
        image = self.image,
        position = projectilePosition,
    })

    table.insert(self.projectiles, 1, projectile)
end

--- Checks if the projectile's projectiles intersect with the given rectangle.
--- For each projectile in the `projectiles` table, this function checks if the projectile intersects with the given rectangle.
--- If an intersection is detected, the projectile is destroyed.
--- @param rect shmup.drawing.Rect The rectangle to check for intersections with the projectile's projectiles.
--- @return boolean true if an intersection is detected, false otherwise.
function P:destroyCollisions(rect)
    local collisionDetected = false

    for _, projectile in ipairs(self.projectiles) do
        if projectile:intersects(rect) then
            projectile:destroy()
            collisionDetected = true
        end
    end

    return collisionDetected
end

return P
