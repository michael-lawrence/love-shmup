--- @class shmup.entities.Enemy
--- @field canvas love.Canvas The canvas to draw the enemy on.
--- @field blur shmup.shaders.Blur The blur shader to use when drawing the enemy.
--- @field controllers table A table of all the controllers that are currently active.
--- @field controllers.movement shmup.controllers.MovementController The movement controller.
--- @field controllers.projectile shmup.controllers.ProjectileController The projectile controller.
--- @field controllers.graphics shmup.controllers.GraphicsController The graphics controller.
local P = {}

local Point = require('shmup.drawing.point')
local MovementController = require('shmup.controllers.movement')
local ProjectileController = require('shmup.controllers.projectile')
local GraphicsController = require('shmup.controllers.graphics')
local Blur = require('shmup.shaders.blur')
local G, W = love.graphics, love.window
local windowW, windowH = W.getMode()
local windowSize = Point:new({ x = windowW, y = windowH })

--- Creates a new enemy instance.
--- @param defaults table The options to use for the enemy.
--- @return shmup.entities.Enemy Enemy The enemy instance.
function P:new(defaults)
    defaults = defaults or {}

    local movementController = MovementController:new({ speed = 1 })
    local projectileController = ProjectileController:new({ imagePath = 'assets/beam.png' })
    local graphicsController = GraphicsController:new({
        imagePath = defaults.imagePath,
        scale = defaults.scale or Point:new({ x = 1, y = 1 }),
        rotation = defaults.rotation or 0,
    })

    local o = {
        controllers = {
            movement = movementController,
            projectile = projectileController,
            graphics = graphicsController,
        },
        canvas = G.newCanvas(),
        blur = Blur:new(),
    }

    setmetatable(o, self)
    self.__index = self

    return o
end

--- Updates the enemy's position and applies a blur effect based on the enemy's distance from the center of the screen.
--- This function calculates the distance between the enemy's position and the center of the screen. If the distance is less than the `zeroRadius` value, the blur effect is set to zero. Otherwise, the blur effect is calculated based on the enemy's distance from the center, using the `sensitivity` value to determine the strength of the effect.
--- @param self shmup.entities.Enemy The enemy instance.
--- @param dt number The time since the last update, in seconds.
function P:update(dt)
    local graphics = self.controllers.graphics
    local movement = self.controllers.movement
    local size = graphics:getSize()
    movement:setSize(size)

    local position = movement.position
    graphics:setPosition(position)
    self.blur:update(position)

    local projectileOffset = Point:new({ x = size.x * 0.27, y = 0 })
    local projectile = self.controllers.projectile
    projectile:setPosition(position + projectileOffset)
    projectile:update(dt)
end

--- Draws the enemy on the screen at their current position, rotation, and scale.
function P:draw()
    local graphics = self.controllers.graphics
    local oldCanvas = G.getCanvas()
    G.setCanvas(self.canvas)
    G.clear()

    self.blur:draw()
    graphics:draw()
    self.blur:reset()

    self.controllers.projectile:draw()

    G.setCanvas(oldCanvas)
    G.draw(self.canvas)
end

--- Initializes the enemy's starting position on the screen.
--- This function sets the enemy's position to be centered horizontally and at the bottom of the screen.
function P:init()
    local size = self.controllers.graphics:getSize()
    local position = Point:new({
        x = (windowSize.x / 2) - (size.x / 2),
        y = -size.y
    })

    self:setPosition(position)
end

--- Sets the position of the enemy.
--- @param position shmup.drawing.Point The new position of the enemy.
function P:setPosition(position)
    self.controllers.movement:setPosition(position)
end

--- Moves the enemy left by the enemy's speed.
function P:moveLeft()
    self.controllers.movement:left()
end

--- Moves the enemy right by the enemy's speed.
function P:moveRight()
    self.controllers.movement:right()
end

--- Moves the enemy up by the enemy's speed.
function P:moveUp()
    self.controllers.movement:up()
end

--- Moves the enemy down by the enemy's speed.
function P:moveDown()
    self.controllers.movement:down()
end

function P:getRect()
    return self.controllers.graphics:getRect()
end

return P
