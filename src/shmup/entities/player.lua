local MovementController = require('shmup.controllers.movement')
local InputController = require('shmup.controllers.input')
local ProjectileController = require('shmup.controllers.projectile')
local Point = require('shmup.drawing.point')
local Rect = require('shmup.drawing.rect')
local Thruster = require('shmup.particles.thruster')
local Blur = require('shmup.shaders.blur')
local G, W = love.graphics, love.window
local windowW, windowH = W.getMode()
local windowSize = Point:new({ x = windowW, y = windowH })

--- @module 'shmup.entities.player'
--- @class shmup.entities.Player
--- @field scale shmup.drawing.Point The scale of the image being rendered.
--- @field rotation number The rotation to render the image.
--- @field canvas love.Canvas The canvas to draw the player on.
--- @field blur shmup.shaders.Blur The blur shader to use when drawing the player.
--- @field thruster shmup.particles.Thruster The thruster particle emitter.
--- @field image love.Image The image to draw the player on.
--- @field imageSize shmup.drawing.Point The size of the image being rendered.
--- @field controllers table A table of all the controllers that are currently active.
--- @field controllers.movement shmup.controllers.MovementController The movement controller.
--- @field controllers.input shmup.controllers.InputController The input controller.
--- @field controllers.projectile shmup.controllers.ProjectileController The projectile controller.
local P = {}

--- Creates a new player instance.
--- @param defaults table The options to use for the player.
--- @return shmup.entities.Player Player The player instance.
function P:new(defaults)
    defaults = defaults or {}

    local movementController = MovementController:new({ speed = 10 })
    local projectileController = ProjectileController:new({ imagePath = 'assets/beam.png' })
    local inputController = InputController:new({
        keymap = {
            left = function() movementController:left() end,
            a = function() movementController:left() end,
            right = function() movementController:right() end,
            d = function() movementController:right() end,
            up = function() movementController:up() end,
            w = function() movementController:up() end,
            down = function() movementController:down() end,
            s = function() movementController:down() end,
            space = function() projectileController:shoot(); end,
        }
    })

    local o = {
        controllers = defaults.controllers or {
            movement = movementController,
            input = inputController,
            projectile = projectileController,
        },
        scale = defaults.scale or Point:new({ x = 0.35, y = 0.35 }),
        rotation = defaults.rotation or 0,
        canvas = G.newCanvas(),
        thruster = Thruster:new(),
        blur = Blur:new(),
        image = G.newImage(defaults.imagePath),
    }

    o.image:setFilter('nearest', 'linear')

    local imageW, imageH = o.image:getDimensions()
    o.imageSize = Point:new({ x = imageW, y = imageH })

    setmetatable(o, self)
    self.__index = self

    return o
end

--- Updates the player's position and applies a blur effect based on the player's distance from the center of the screen.
--- This function calculates the distance between the player's position and the center of the screen. If the distance is less than the `zeroRadius` value, the blur effect is set to zero. Otherwise, the blur effect is calculated based on the player's distance from the center, using the `sensitivity` value to determine the strength of the effect.
--- @param dt number The time since the last update, in seconds.
function P:update(dt)
    self.controllers.input:update()

    local position = self.controllers.movement.position
    self.blur:update(position)

    local playerSize = self:getSize()
    self.controllers.movement:setSize(playerSize)

    local newPosition = position + Point:new({ x = playerSize.x / 2, y = playerSize.y })

    self.thruster:setPosition(newPosition)
    self.thruster:update(dt)

    local projectileOffset = Point:new({ x = playerSize.x * 0.27, y = 0 })
    local projectile = self.controllers.projectile
    projectile:setPosition(position + projectileOffset)
    projectile:update(dt)
end

--- Draws the player on the screen at their current position, rotation, and scale.
function P:draw()
    local position = self.controllers.movement.position
    local projectile = self.controllers.projectile
    local oldCanvas = G.getCanvas()
    G.setCanvas(self.canvas)
    G.clear()

    self.thruster:draw()
    self.blur:draw()
    G.draw(self.image, position.x, position.y, self.rotation, self.scale.x, self.scale.y)
    self.blur:reset()

    projectile:draw()

    G.setCanvas(oldCanvas)
    G.draw(self.canvas)
end

--- Initializes the player's starting position on the screen.
--- This function sets the player's position to be centered horizontally and at the bottom of the screen.
function P:init()
    local playerSize = self:getSize()
    local halfWidth = Point:new({ x = 2, y = 1 })
    local offset = Point:new({ x = 0, y = 1 })
    local windowLocation = windowSize / halfWidth
    local playerLocation = (playerSize / halfWidth) + (offset * playerSize)
    local position = windowLocation - playerLocation

    self.controllers.movement:setPosition(position)
end

---Sets the scale of the player.
--- @param scale shmup.drawing.Point The new scale of the player.
function P:setScale(scale)
    self.scale:setPoint(scale)
end

--- Returns the width and height of the player's image, scaled by the player's scale.
--- @return shmup.drawing.Point point The size of the player's image, scaled.
function P:getSize()
    return self.imageSize * self.scale
end

--- Returns a rectangle representing the player's position and size.
--- @return shmup.drawing.Rect The rectangle representing the player's position and size.
function P:getRect()
    local position = self.controllers.movement.position
    return Rect:new({
        x = position.x,
        y = position.y,
        w = self.imageSize.x,
        h = self.imageSize.y,
    })
end

--- Checks if a projectile intersects with the given rectangle.
--- @param rect shmup.drawing.Rect The rectangle to check for intersection.
--- @return boolean True if the projectile intersects with the rectangle, false otherwise.
function P:destroyCollidingProjectiles(rect)
    return self.controllers.projectile:destroyCollisions(rect)
end

return P
