require('drawing.point')
require('drawing.rect')
require('entities.gun')
require('particles.thruster')
require('shaders.blur')

---@module 'entities.player'
Player = {}

local G, W = love.graphics, love.window

--- Creates a new player instance.
---@param imagePath string The path to the image to use for the player.
---@return Player Player The player instance.
function Player.new(imagePath)
    local canvas = G.newCanvas()
    local thruster = Thruster.new()
    local blur = Blur.new()
    local gun = Gun.new('assets/beam.png')

    local image = G.newImage(imagePath)
    image:setFilter('nearest', 'linear')

    local windowSize = Point.new(W.getMode())
    local imageSize = Point.new(image:getDimensions())

    ---@class Player
    ---@field position Point The coordinates where the player currently is.
    ---@field scale Point The scale of the image being rendered.
    ---@field rotation number The rotation to render the image.
    ---@field speed number The speed in pixels that the player will move each frame.
    local player = {
        position = Point.new(0, 0),
        scale = Point.new(0.35, 0.35),
        rotation = 0,
        speed = 10,
    }

    --- Draws the player on the screen at their current position, rotation, and scale.
    function player:draw()
        local oldCanvas = G.getCanvas()
        G.setCanvas(canvas)
        G.clear()

        thruster:draw()

        blur:draw()
        G.draw(image, self.position.x, self.position.y, self.rotation, self.scale.x, self.scale.y)
        blur:reset()

        gun:draw()

        G.setCanvas(oldCanvas)
        G.draw(canvas)
    end

    --- Initializes the player's starting position on the screen.
    --- This function sets the player's position to be centered horizontally and at the bottom of the screen.
    function player:init()
        local playerSize = self:getSize()
        local halfWidth = Point.new(2, 1)
        local offset = Point.new(0, 1)
        local windowLocation = windowSize / halfWidth
        local playerLocation = (playerSize / halfWidth) + (offset * playerSize)
        local position = windowLocation - playerLocation

        self:setPosition(position)
    end

    --- Sets the position of the player.
    ---@param position Point The new position of the player.
    function player:setPosition(position)
        self.position:setPoint(position)
    end

    ---Sets the scale of the player.
    ---@param scale Point The new scale of the player.
    function player:setScale(scale)
        self.scale:setPoint(scale)
    end

    --- Sets the rotation of the player.
    ---@param rotation number The new rotation of the player, in radians.
    function player:setRotation(rotation)
        self.rotation = rotation
    end

    ---Sets the speed of the player.
    ---@param speed number The new speed of the player.
    function player:setSpeed(speed)
        self.speed = speed
    end

    --- Returns the width and height of the player's image, scaled by the player's scale.
    ---@return Point point The size of the player's image, scaled.
    function player:getSize()
        return imageSize * self.scale
    end

    --- Returns a rectangle representing the player's position and size.
    ---@return Rect The rectangle representing the player's position and size.
    function player:getRect()
        return Rect.new(self.position.x, self.position.y, imageSize.x, imageSize.y)
    end

    --- Updates the player's position and applies a blur effect based on the player's distance from the center of the screen.
    --- This function calculates the distance between the player's position and the center of the screen. If the distance is less than the `zeroRadius` value, the blur effect is set to zero. Otherwise, the blur effect is calculated based on the player's distance from the center, using the `sensitivity` value to determine the strength of the effect.
    --- @param self Player The player instance.
    --- @param dt number The time since the last update, in seconds.
    function player:update(dt)
        blur:update(self.position)

        local playerSize = self:getSize()
        local newPosition = self.position + Point.new(playerSize.x / 2, playerSize.y)

        thruster:setPosition(newPosition)
        thruster:update(dt)

        local gunOffset = Point.new(playerSize.x * 0.27, 0)
        gun:setPosition(self.position + gunOffset)
        gun:update(dt)
    end

    --- Moves the player left by the player's speed.
    function player:moveLeft()
        self.position.x = math.max(0, self.position.x - self.speed)
    end

    --- Moves the player right by the player's speed.
    function player:moveRight()
        local playerSize = player:getSize()
        self.position.x = math.min(windowSize.x - playerSize.x, self.position.x + self.speed)
    end

    --- Moves the player up by the player's speed.
    function player:moveUp()
        self.position.y = math.max(0, self.position.y - self.speed)
    end

    --- Moves the player down by the player's speed.
    function player:moveDown()
        local playerSize = player:getSize()
        self.position.y = math.min(windowSize.y - playerSize.y, self.position.y + self.speed)
    end

    --- Shoots a projectile
    function player:shoot()
        gun:shoot();
    end

    --- Checks if a bullet intersects with the given rectangle.
    --- @param rect Rect The rectangle to check for intersection.
    function player:destroyCollidingBullets(rect)
        gun:destroyCollidingBullets(rect)
    end

    return player
end

return Player
