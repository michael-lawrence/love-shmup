require('shaders.blur')
require('drawing.point')

---@module 'entities.player'
Player = {}

--- Creates a new player instance.
---@param imagePath string The path to the image to use for the player.
---@return Player Player The player instance.
function Player.new(imagePath)
    local blur = Blur.new()
    local windowW, windowH = love.window.getMode()
    local image = love.graphics.newImage(imagePath)

    ---@class Player
    local player = {
        position = Point.new(0, 0),
        scale = Point.new(0.35, 0.35),
        rotation = 0,
        speed = 10,
    }

    --- Draws the player on the screen at their current position, rotation, and scale.
    function player:draw()
        blur:draw()
        love.graphics.draw(image, self.position.x, self.position.y, self.rotation, self.scale.x, self.scale.y)
        blur:reset()
    end

    --- Initializes the player's starting position on the screen.
    --- This function sets the player's position to be centered horizontally and at the bottom of the screen.
    function player:init()
        local playerSize = self:getSize()

        local point = Point.new(
            (windowW / 2) - (playerSize.x / 2),
            windowH - playerSize.y
        )

        self:setPosition(point)
    end

    --- Sets the position of the player.
    ---@param point Point The new position of the player.
    function player:setPosition(point)
        self.position.x = point.x
        self.position.y = point.y
    end

    ---Sets the scale of the player.
    ---@param point Point The new scale of the player.
    function player:setScale(point)
        self.scale.x = point.x
        self.scale.y = point.y
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
        return Point.new(
            image:getWidth() * self.scale.x,
            image:getHeight() * self.scale.y
        )
    end

    --- Updates the player's position and applies a blur effect based on the player's distance from the center of the screen.
    --- This function calculates the distance between the player's position and the center of the screen. If the distance is less than the `zeroRadius` value, the blur effect is set to zero. Otherwise, the blur effect is calculated based on the player's distance from the center, using the `sensitivity` value to determine the strength of the effect.
    --- @param self Player The player instance.
    function player:update()
        blur:update(self.position.x, self.position.y)
    end

    --- Moves the player left by the player's speed.
    function player:moveLeft()
        self.position.x = math.max(0, self.position.x - self.speed)
    end

    --- Moves the player right by the player's speed.
    function player:moveRight()
        local playerSize = player:getSize()
        self.position.x = math.min(windowW - playerSize.x, self.position.x + self.speed)
    end

    --- Moves the player up by the player's speed.
    function player:moveUp()
        self.position.y = math.max(0, self.position.y - self.speed)
    end

    --- Moves the player down by the player's speed.
    function player:moveDown()
        local playerSize = player:getSize()
        self.position.y = math.min(windowH - playerSize.y, self.position.y + self.speed)
    end

    return player
end

return Player