local MovementController = require('shmup.controllers.movement')
local InputController = require('shmup.controllers.input')
local ProjectileController = require('shmup.controllers.projectile')
local GraphicsController = require('shmup.controllers.graphics')
local Point = require('shmup.drawing.point')
local Thruster = require('shmup.particles.thruster')
local Blur = require('shmup.shaders.blur')
local G, W = love.graphics, love.window
local windowW, windowH = W.getMode()
local windowSize = Point:new({ x = windowW, y = windowH })

--- @class shmup.entities.Player
--- @field canvas love.Canvas The canvas to draw the player on.
--- @field blur shmup.shaders.Blur The blur shader to use when drawing the player.
--- @field thruster shmup.particles.Thruster The thruster particle emitter.
--- @field controllers table A table of all the controllers that are currently active.
--- @field controllers.movement shmup.controllers.MovementController The movement controller.
--- @field controllers.input shmup.controllers.InputController The input controller.
--- @field controllers.projectile shmup.controllers.ProjectileController The projectile controller.
--- @field controllers.graphics shmup.controllers.GraphicsController The graphics controller.
local P = {}

--- Creates a new player instance.
--- @param defaults table The options to use for the player.
--- @return shmup.entities.Player Player The player instance.
function P:new(defaults)
    defaults = defaults or {}

    local movementController = MovementController:new({ speed = 10 })
    local projectileController = ProjectileController:new({ imagePath = 'assets/beam.png' })

    local graphicsController = GraphicsController:new({
        imagePath = defaults.imagePath,
        scale = defaults.scale or Point:new({ x = 0.35, y = 0.35 }),
        rotation = defaults.rotation or 0,
    })

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
            graphics = graphicsController,
        },
        canvas = G.newCanvas(),
        thruster = Thruster:new(),
        blur = Blur:new(),
    }

    setmetatable(o, self)
    self.__index = self

    return o
end

--- Updates the player's position and applies a blur effect based on the player's distance from the center of the screen.
--- This function calculates the distance between the player's position and the center of the screen. If the distance is less than the `zeroRadius` value, the blur effect is set to zero. Otherwise, the blur effect is calculated based on the player's distance from the center, using the `sensitivity` value to determine the strength of the effect.
--- @param dt number The time since the last update, in seconds.
function P:update(dt)
    local input = self.controllers.input
    local projectile = self.controllers.projectile
    local graphics = self.controllers.graphics
    local movement = self.controllers.movement
    local position = movement.position

    input:update()

    graphics:setPosition(position)
    self.blur:update(position)

    local size = graphics:getSize()
    movement:setSize(size)

    local newPosition = position + Point:new({ x = size.x / 2, y = size.y })

    self.thruster:setPosition(newPosition)
    self.thruster:update(dt)

    local projectileOffset = Point:new({ x = size.x * 0.27, y = 0 })

    projectile:setPosition(position + projectileOffset)
    projectile:update(dt)
end

--- Draws the player on the screen at their current position, rotation, and scale.
function P:draw()
    local projectile = self.controllers.projectile
    local graphics = self.controllers.graphics
    local oldCanvas = G.getCanvas()
    G.setCanvas(self.canvas)
    G.clear()

    self.thruster:draw()
    self.blur:draw()
    graphics:draw()
    self.blur:reset()

    projectile:draw()

    G.setCanvas(oldCanvas)
    G.draw(self.canvas)
end

--- Initializes the player's starting position on the screen.
--- This function sets the player's position to be centered horizontally and at the bottom of the screen.
function P:init()
    local movement = self.controllers.movement
    local graphics = self.controllers.graphics
    local playerSize = graphics:getSize()
    local halfWidth = Point:new({ x = 2, y = 1 })
    local offset = Point:new({ x = 0, y = 1 })
    local windowLocation = windowSize / halfWidth
    local playerLocation = (playerSize / halfWidth) + (offset * playerSize)
    local position = windowLocation - playerLocation

    movement:setPosition(position)
end

--- Checks if a projectile intersects with the given rectangle.
--- @param rect shmup.drawing.Rect The rectangle to check for intersection.
--- @return boolean True if the projectile intersects with the rectangle, false otherwise.
function P:destroyCollidingProjectiles(rect)
    return self.controllers.projectile:destroyCollisions(rect)
end

return P
