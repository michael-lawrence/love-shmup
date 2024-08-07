--- @module 'shmup.entities.enemy'
--- @class shmup.entities.Enemy
--- @field scale shmup.drawing.Point The scale of the image being rendered.
--- @field rotation number The rotation to render the image.
--- @field canvas love.Canvas The canvas to draw the enemy on.
--- @field blur shmup.shaders.Blur The blur shader to use when drawing the enemy.
--- @field image love.Image The image to draw the enemy on.
--- @field imageSize shmup.drawing.Point The size of the image being rendered.
--- @field controllers table A table of all the controllers that are currently active.
--- @field controllers.movement shmup.controllers.MovementController The movement controller.
--- @field controllers.projectile shmup.controllers.ProjectileController The projectile controller.
local P = {}

local Point = require('shmup.drawing.point')
local Rect = require('shmup.drawing.rect')
local MovementController = require('shmup.controllers.movement')
local ProjectileController = require('shmup.controllers.projectile')
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

    local o = {
        controllers = {
            movement = movementController,
            projectile = projectileController,
        },
        scale = Point:new({ x = 1, y = 1 }),
        rotation = 0,
        canvas = G.newCanvas(),
        blur = Blur:new(),
        image = G.newImage(defaults.imagePath),
    }

    local imageW, imageH = o.image:getDimensions()
    o.imageSize = Point:new({ x = imageW, y = imageH })
    o.image:setFilter('nearest', 'linear')

    setmetatable(o, self)
    self.__index = self

    return o
end

--- Updates the enemy's position and applies a blur effect based on the enemy's distance from the center of the screen.
--- This function calculates the distance between the enemy's position and the center of the screen. If the distance is less than the `zeroRadius` value, the blur effect is set to zero. Otherwise, the blur effect is calculated based on the enemy's distance from the center, using the `sensitivity` value to determine the strength of the effect.
--- @param self shmup.entities.Enemy The enemy instance.
--- @param dt number The time since the last update, in seconds.
function P:update(dt)
    local movement = self.controllers.movement
    local enemySize = self:getSize()
    movement:setSize(enemySize)

    local position = movement.position
    self.blur:update(position)

    local projectileOffset = Point:new({ x = enemySize.x * 0.27, y = 0 })
    local projectile = self.controllers.projectile
    projectile:setPosition(position + projectileOffset)
    projectile:update(dt)
end

--- Draws the enemy on the screen at their current position, rotation, and scale.
function P:draw()
    local position = self.controllers.movement.position
    local oldCanvas = G.getCanvas()
    G.setCanvas(self.canvas)
    G.clear()

    self.blur:draw()
    G.draw(self.image, position.x, position.y, self.rotation, self.scale.x, self.scale.y)
    self.blur:reset()

    self.controllers.projectile:draw()

    G.setCanvas(oldCanvas)
    G.draw(self.canvas)
end

--- Initializes the enemy's starting position on the screen.
--- This function sets the enemy's position to be centered horizontally and at the bottom of the screen.
function P:init()
    local enemySize = self:getSize()
    local position = Point:new({
        x = (windowSize.x / 2) - (enemySize.x / 2),
        y = -enemySize.y
    })

    self:setPosition(position)
end

--- Sets the position of the enemy.
--- @param position shmup.drawing.Point The new position of the enemy.
function P:setPosition(position)
    self.controllers.movement:setPosition(position)
end

---Sets the scale of the enemy.
--- @param scale shmup.drawing.Point The new scale of the enemy.
function P:setScale(scale)
    self.scale:setPoint(scale)
end

--- Sets the rotation of the enemy.
--- @param rotation number The new rotation of the enemy, in radians.
function P:setRotation(rotation)
    self.rotation = rotation
end

---Sets the speed of the enemy.
--- @param speed number The new speed of the enemy.
function P:setSpeed(speed)
    self.controllers.movement:setSpeed(speed)
end

--- Returns the width and height of the enemy's image, scaled by the enemy's scale.
--- @return shmup.drawing.Point point The size of the enemy's image, scaled.
function P:getSize()
    return self.imageSize * self.scale
end

--- Returns a rectangle representing the enemy's position and size.
--- @return shmup.drawing.Rect The rectangle representing the enemy's position and size.
function P:getRect()
    local position = self.controllers.movement.position

    return Rect:new({
        x = position.x,
        y = position.y,
        w = self.imageSize.x,
        h = self.imageSize.y,
    })
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

return P
