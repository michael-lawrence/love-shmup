require('shaders.blur')
require('drawing.point')
require('entities.bullet')

---@module 'entities.enemy'
Enemy = {}

local G, W = love.graphics, love.window

--- Creates a new enemy instance.
---@param imagePath string The path to the image to use for the enemy.
---@return Enemy Enemy The enemy instance.
function Enemy.new(imagePath)
    local canvas = G.newCanvas()
    local blur = Blur.new()
    local lastBulletFired = os.clock()

    local image = G.newImage(imagePath)
    image:setFilter('nearest', 'linear')

    local windowSize = Point.new(W.getMode())
    local imageSize = Point.new(image:getDimensions())
    local bullets = {}

    ---@class Enemy
    ---@field position Point The coordinates where the enemy currently is.
    ---@field scale Point The scale of the image being rendered.
    ---@field rotation number The rotation to render the image.
    ---@field speed number The speed in pixels that the enemy will move each frame.
    local enemy = {
        position = Point.new(0, 0),
        scale = Point.new(1, 1),
        rotation = 0,
        speed = 1,
    }

    --- Draws the enemy on the screen at their current position, rotation, and scale.
    function enemy:draw()
        local oldCanvas = G.getCanvas()
        G.setCanvas(canvas)
        G.clear()

        blur:draw()
        G.draw(image, self.position.x, self.position.y, self.rotation, self.scale.x, self.scale.y)
        blur:reset()

        for _, bullet in ipairs(bullets) do
            bullet:draw()
        end

        G.setCanvas(oldCanvas)
        G.draw(canvas)
    end

    --- Initializes the enemy's starting position on the screen.
    --- This function sets the enemy's position to be centered horizontally and at the bottom of the screen.
    function enemy:init()
        local enemySize = self:getSize()
        local position = Point.new((windowSize.x / 2) - (enemySize.x / 2), -enemySize.y)

        self:setPosition(position)
    end

    --- Sets the position of the enemy.
    ---@param position Point The new position of the enemy.
    function enemy:setPosition(position)
        self.position:setPoint(position)
    end

    ---Sets the scale of the enemy.
    ---@param scale Point The new scale of the enemy.
    function enemy:setScale(scale)
        self.scale:setPoint(scale)
    end

    --- Sets the rotation of the enemy.
    ---@param rotation number The new rotation of the enemy, in radians.
    function enemy:setRotation(rotation)
        self.rotation = rotation
    end

    ---Sets the speed of the enemy.
    ---@param speed number The new speed of the enemy.
    function enemy:setSpeed(speed)
        self.speed = speed
    end

    --- Returns the width and height of the enemy's image, scaled by the enemy's scale.
    ---@return Point point The size of the enemy's image, scaled.
    function enemy:getSize()
        return imageSize * self.scale
    end

    --- Updates the enemy's position and applies a blur effect based on the enemy's distance from the center of the screen.
    --- This function calculates the distance between the enemy's position and the center of the screen. If the distance is less than the `zeroRadius` value, the blur effect is set to zero. Otherwise, the blur effect is calculated based on the enemy's distance from the center, using the `sensitivity` value to determine the strength of the effect.
    --- @param self Enemy The enemy instance.
    --- @param dt number The time since the last update, in seconds.
    function enemy:update(dt)
        blur:update(self.position)

        for i, bullet in ipairs(bullets) do
            bullet:update()

            if bullet.isDestroyed then
                bullets[i] = nil
            end
        end
    end

    --- Moves the enemy left by the enemy's speed.
    function enemy:moveLeft()
        self.position.x = math.max(0, self.position.x - self.speed)
    end

    --- Moves the enemy right by the enemy's speed.
    function enemy:moveRight()
        local enemySize = enemy:getSize()
        self.position.x = math.min(windowSize.x - enemySize.x, self.position.x + self.speed)
    end

    --- Moves the enemy up by the enemy's speed.
    function enemy:moveUp()
        self.position.y = math.max(0, self.position.y - self.speed)
    end

    --- Moves the enemy down by the enemy's speed.
    function enemy:moveDown()
        local enemySize = enemy:getSize()
        self.position.y = math.min(windowSize.y - enemySize.y, self.position.y + self.speed)
    end

    --- Shoots a projectile
    function enemy:shoot()
        local now = os.clock()

        if now - lastBulletFired < 0.01 then return end

        lastBulletFired = now

        local bullet = Bullet.new()
        local enemySize = enemy:getSize()
        local offset = Point.new(enemySize.x * 0.4, -10)
        local position = self.position + offset

        bullet.position:setPoint(position)
        table.insert(bullets, 1, bullet)
    end

    return enemy
end

return Enemy
