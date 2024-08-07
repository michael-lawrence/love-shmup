--- @module 'shmup.entities.player'
--- @class shmup.entities.Player
--- @field position shmup.drawing.Point The coordinates where the player currently is.
--- @field scale shmup.drawing.Point The scale of the image being rendered.
--- @field rotation number The rotation to render the image.
--- @field speed number The speed in pixels that the player will move each frame.
--- @field canvas love.Canvas The canvas to draw the player on.
--- @field blur shmup.shaders.Blur The blur shader to use when drawing the player.
--- @field gun shmup.entities.Gun The gun to use when shooting.
--- @field thruster shmup.particles.Thruster The gun to use when shooting.
--- @field image love.Image The image to draw the player on.
--- @field imageSize shmup.drawing.Point The size of the image being rendered.
local Player = {}

local Point = require('shmup.drawing.point')
local Rect = require('shmup.drawing.rect')
local Gun = require('shmup.entities.gun')
local Thruster = require('shmup.particles.thruster')
local Blur = require('shmup.shaders.blur')
local G, W = love.graphics, love.window
local windowSize = Point:new(W.getMode())

--- Creates a new player instance.
--- @param imagePath string The path to the image to use for the player.
--- @return shmup.entities.Player Player The player instance.
function Player:new(imagePath)
    local o = {
        position = Point:new(0, 0),
        scale = Point:new(0.35, 0.35),
        rotation = 0,
        speed = 10,
        canvas = G.newCanvas(),
        thruster = Thruster:new(),
        blur = Blur:new(),
        gun = Gun:new('assets/beam.png'),
        image = G.newImage(imagePath),
    }

    o.image:setFilter('nearest', 'linear')
    o.imageSize = Point:new(o.image:getDimensions())

    setmetatable(o, self)
    self.__index = self

    return o
end

--- Draws the player on the screen at their current position, rotation, and scale.
function Player:draw()
    local oldCanvas = G.getCanvas()
    G.setCanvas(self.canvas)
    G.clear()

    self.thruster:draw()

    self.blur:draw()
    G.draw(self.image, self.position.x, self.position.y, self.rotation, self.scale.x, self.scale.y)
    self.blur:reset()

    self.gun:draw()

    G.setCanvas(oldCanvas)
    G.draw(self.canvas)
end

--- Initializes the player's starting position on the screen.
--- This function sets the player's position to be centered horizontally and at the bottom of the screen.
function Player:init()
    local playerSize = self:getSize()
    local halfWidth = Point:new(2, 1)
    local offset = Point:new(0, 1)
    local windowLocation = windowSize / halfWidth
    local playerLocation = (playerSize / halfWidth) + (offset * playerSize)
    local position = windowLocation - playerLocation

    self:setPosition(position)
end

--- Sets the position of the player.
--- @param position shmup.drawing.Point The new position of the player.
function Player:setPosition(position)
    self.position:setPoint(position)
end

---Sets the scale of the player.
--- @param scale shmup.drawing.Point The new scale of the player.
function Player:setScale(scale)
    self.scale:setPoint(scale)
end

--- Sets the rotation of the player.
--- @param rotation number The new rotation of the player, in radians.
function Player:setRotation(rotation)
    self.rotation = rotation
end

---Sets the speed of the player.
--- @param speed number The new speed of the player.
function Player:setSpeed(speed)
    self.speed = speed
end

--- Returns the width and height of the player's image, scaled by the player's scale.
--- @return shmup.drawing.Point point The size of the player's image, scaled.
function Player:getSize()
    return self.imageSize * self.scale
end

--- Returns a rectangle representing the player's position and size.
--- @return shmup.drawing.Rect The rectangle representing the player's position and size.
function Player:getRect()
    return Rect:new(self.position.x, self.position.y, self.imageSize.x, self.imageSize.y)
end

--- Updates the player's position and applies a blur effect based on the player's distance from the center of the screen.
--- This function calculates the distance between the player's position and the center of the screen. If the distance is less than the `zeroRadius` value, the blur effect is set to zero. Otherwise, the blur effect is calculated based on the player's distance from the center, using the `sensitivity` value to determine the strength of the effect.
--- @param dt number The time since the last update, in seconds.
function Player:update(dt)
    self.blur:update(self.position)

    local playerSize = self:getSize()
    local newPosition = self.position + Point:new(playerSize.x / 2, playerSize.y)

    self.thruster:setPosition(newPosition)
    self.thruster:update(dt)

    local gunOffset = Point:new(playerSize.x * 0.27, 0)
    self.gun:setPosition(self.position + gunOffset)
    self.gun:update(dt)
end

--- Moves the player left by the player's speed.
function Player:moveLeft()
    self.position.x = math.max(0, self.position.x - self.speed)
end

--- Moves the player right by the player's speed.
function Player:moveRight()
    local playerSize = self:getSize()
    self.position.x = math.min(windowSize.x - playerSize.x, self.position.x + self.speed)
end

--- Moves the player up by the player's speed.
function Player:moveUp()
    self.position.y = math.max(0, self.position.y - self.speed)
end

--- Moves the player down by the player's speed.
function Player:moveDown()
    local playerSize = self:getSize()
    self.position.y = math.min(windowSize.y - playerSize.y, self.position.y + self.speed)
end

--- Shoots a projectile
function Player:shoot()
    self.gun:shoot();
end

--- Checks if a bullet intersects with the given rectangle.
--- @param rect shmup.drawing.Rect The rectangle to check for intersection.
--- @return boolean True if the bullet intersects with the rectangle, false otherwise.
function Player:destroyCollidingBullets(rect)
    return self.gun:destroyCollidingBullets(rect)
end

return Player
