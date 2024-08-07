--- @module 'shmup.entities.enemy'
--- @class shmup.entities.Enemy
--- @field position shmup.drawing.Point The coordinates where the enemy currently is.
--- @field scale shmup.drawing.Point The scale of the image being rendered.
--- @field rotation number The rotation to render the image.
--- @field speed number The speed in pixels that the enemy will move each frame.
--- @field canvas love.Canvas The canvas to draw the enemy on.
--- @field blur shmup.shaders.Blur The blur shader to use when drawing the enemy.
--- @field gun shmup.entities.Gun The gun to use when shooting.
--- @field image love.Image The image to draw the enemy on.
--- @field imageSize shmup.drawing.Point The size of the image being rendered.
local Enemy = {}

local Point = require('shmup.drawing.point')
local Rect = require('shmup.drawing.rect')
local Gun = require('shmup.entities.gun')
local Blur = require('shmup.shaders.blur')
local G, W = love.graphics, love.window
local windowSize = Point:new(W.getMode())

--- Creates a new enemy instance.
--- @param imagePath string The path to the image to use for the enemy.
--- @return shmup.entities.Enemy Enemy The enemy instance.
function Enemy:new(imagePath)
    local o = {
        position = Point:new(0, 0),
        scale = Point:new(1, 1),
        rotation = 0,
        speed = 1,
        canvas = G.newCanvas(),
        blur = Blur:new(),
        gun = Gun:new('assets/beam.png'),
        image = G.newImage(imagePath),
    }

    o.imageSize = Point:new(o.image:getDimensions())
    o.image:setFilter('nearest', 'linear')

    setmetatable(o, self)
    self.__index = self

    return o
end

--- Draws the enemy on the screen at their current position, rotation, and scale.
function Enemy:draw()
    local oldCanvas = G.getCanvas()
    G.setCanvas(self.canvas)
    G.clear()

    self.blur:draw()
    G.draw(self.image, self.position.x, self.position.y, self.rotation, self.scale.x, self.scale.y)
    self.blur:reset()

    self.gun:draw()

    G.setCanvas(oldCanvas)
    G.draw(self.canvas)
end

--- Initializes the enemy's starting position on the screen.
--- This function sets the enemy's position to be centered horizontally and at the bottom of the screen.
function Enemy:init()
    local enemySize = self:getSize()
    local position = Point:new((windowSize.x / 2) - (enemySize.x / 2), -enemySize.y)

    self:setPosition(position)
end

--- Sets the position of the enemy.
--- @param position shmup.drawing.Point The new position of the enemy.
function Enemy:setPosition(position)
    self.position:setPoint(position)
end

---Sets the scale of the enemy.
--- @param scale shmup.drawing.Point The new scale of the enemy.
function Enemy:setScale(scale)
    self.scale:setPoint(scale)
end

--- Sets the rotation of the enemy.
--- @param rotation number The new rotation of the enemy, in radians.
function Enemy:setRotation(rotation)
    self.rotation = rotation
end

---Sets the speed of the enemy.
--- @param speed number The new speed of the enemy.
function Enemy:setSpeed(speed)
    self.speed = speed
end

--- Returns the width and height of the enemy's image, scaled by the enemy's scale.
--- @return shmup.drawing.Point point The size of the enemy's image, scaled.
function Enemy:getSize()
    return self.imageSize * self.scale
end

--- Returns a rectangle representing the enemy's position and size.
--- @return shmup.drawing.Rect The rectangle representing the enemy's position and size.
function Enemy:getRect()
    return Rect:new(self.position.x, self.position.y, self.imageSize.x, self.imageSize.y)
end

--- Updates the enemy's position and applies a blur effect based on the enemy's distance from the center of the screen.
--- This function calculates the distance between the enemy's position and the center of the screen. If the distance is less than the `zeroRadius` value, the blur effect is set to zero. Otherwise, the blur effect is calculated based on the enemy's distance from the center, using the `sensitivity` value to determine the strength of the effect.
--- @param self shmup.entities.Enemy The enemy instance.
--- @param dt number The time since the last update, in seconds.
function Enemy:update(dt)
    self.blur:update(self.position)

    local enemySize = self:getSize()
    local gunOffset = Point:new(enemySize.x * 0.27, 0)
    self.gun:setPosition(self.position + gunOffset)
    self.gun:update(dt)
end

--- Moves the enemy left by the enemy's speed.
function Enemy:moveLeft()
    self.position.x = math.max(0, self.position.x - self.speed)
end

--- Moves the enemy right by the enemy's speed.
function Enemy:moveRight()
    local enemySize = self:getSize()
    self.position.x = math.min(windowSize.x - enemySize.x, self.position.x + self.speed)
end

--- Moves the enemy up by the enemy's speed.
function Enemy:moveUp()
    self.position.y = math.max(0, self.position.y - self.speed)
end

--- Moves the enemy down by the enemy's speed.
function Enemy:moveDown()
    local enemySize = self:getSize()
    self.position.y = math.min(windowSize.y - enemySize.y, self.position.y + self.speed)
end

--- Shoots a projectile
function Enemy:shoot()
    self.gun:shoot();
end

return Enemy
