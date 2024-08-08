local MovementController = require('shmup.controllers.movement')
local GraphicsController = require('shmup.controllers.graphics')
local Point = require('shmup.drawing.point')

--- @class shmup.entities.Projectile
--- @field isDestroyed boolean Whether or not the projectile is destroyed.
--- @field controllers table A table of all the controllers that are currently active.
--- @field controllers.movement shmup.controllers.MovementController The movement controller.
--- @field controllers.graphics shmup.controllers.GraphicsController The graphics controller.
local P = {}

--- Creates a new projectile instance.
--- @return shmup.entities.Projectile Projectile The projectile instance.
--- @param defaults table A table of initial properties for the projectile. If not provided, default values will be used.
function P:new(defaults)
    defaults = defaults or {}

    local movementController = MovementController:new({ speed = defaults.speed or 10 })

    local graphicsController = GraphicsController:new({
        imagePath = defaults.imagePath,
        scale = defaults.scale or Point:new({ x = 0.25, y = 0.25 }),
        rotation = defaults.rotation or 0,
        position = defaults.position or Point:new(),
    })

    local o = {
        controllers = defaults.controllers or {
            movement = movementController,
            graphics = graphicsController,
        },
        isDestroyed = false,
    }

    setmetatable(o, self)
    self.__index = self

    return o
end

--- Updates the projectile's position and destroys the projectile if it has reached the top of the screen.
function P:update()
    local movement = self.controllers.movement;
    local graphics = self.controllers.graphics;
    if self.isDestroyed then return end

    local oldY = movement.position.y
    movement:up()

    graphics:setPosition(movement.position)

    if oldY == movement.position.y then
        self:destroy()
    end
end

--- Draws the projectile on the screen at their current position, rotation, and scale.
function P:draw()
    if self.isDestroyed then return end
    self.controllers.graphics:draw()
end

--- Returns the width and height of the player's image, scaled by the player's scale.
--- @return shmup.drawing.Point point The size of the player's image, scaled.
function P:getSize()
    return self.controllers.graphics:getSize()
end

--- Returns a rectangle representing the projectile's position and size.
--- @return shmup.drawing.Rect The rectangle representing the projectile's position and size.
function P:getRect()
    return self.controllers.graphics:getRect()
end

--- Sets the position to draw the projectile at.
--- @param position shmup.drawing.Point The position to draw the projectile at.
function P:setPosition(position)
    self.controllers.graphics:setPosition(position)
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
