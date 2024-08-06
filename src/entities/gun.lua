require('drawing.point')
require('drawing.rect')
require('entities.bullet')
require('shaders.blur')

--- @module 'entities.gun'
Gun = {}

local G = love.graphics

--- Creates a new gun instance.
--- @param imagePath string The path to the image to use for the gun.
--- @return Gun Gun The gun instance.
function Gun.new(imagePath)
    local canvas = G.newCanvas()
    local blur = Blur.new()
    local lastBulletFired = os.clock()

    local image = G.newImage(imagePath)
    image:setFilter('nearest', 'linear')

    local imageSize = Point.new(image:getDimensions())
    local bullets = {}

    --- @class Gun
    --- @field position Point The coordinates where the gun currently is.
    --- @field scale Point The scale of the image being rendered.
    --- @field rotation number The rotation to render the image.
    --- @field speed number The speed in pixels that the gun will move each frame.
    local gun = {
        position = Point.new(0, 0),
        scale = Point.new(0.35, 0.35),
        rotation = 0,
        speed = 10,
    }

    --- Draws the bullets on the screen at their current position, rotation, and scale.
    function gun:draw()
        local oldCanvas = G.getCanvas()
        G.setCanvas(canvas)
        G.clear()

        blur:draw()

        for _, bullet in ipairs(bullets) do
            bullet:draw()
        end

        blur:reset()

        G.setCanvas(oldCanvas)
        G.draw(canvas)
    end

    --- Sets the position of the gun.
    --- @param position Point The new position of the gun.
    function gun:setPosition(position)
        self.position:setPoint(position)
    end

    ---Sets the scale of the gun.
    --- @param scale Point The new scale of the gun.
    function gun:setScale(scale)
        self.scale:setPoint(scale)
    end

    --- Sets the rotation of the gun.
    --- @param rotation number The new rotation of the gun, in radians.
    function gun:setRotation(rotation)
        self.rotation = rotation
    end

    ---Sets the speed of the gun.
    --- @param speed number The new speed of the gun.
    function gun:setSpeed(speed)
        self.speed = speed
    end

    --- Returns the width and height of the gun's image, scaled by the gun's scale.
    --- @return Point point The size of the gun's image, scaled.
    function gun:getSize()
        return imageSize * self.scale
    end

    --- Updates the gun's position and applies a blur effect based on the gun's distance from the center of the screen.
    --- This function calculates the distance between the gun's position and the center of the screen. If the distance is less than the `zeroRadius` value, the blur effect is set to zero. Otherwise, the blur effect is calculated based on the gun's distance from the center, using the `sensitivity` value to determine the strength of the effect.
    --- @param self Gun The gun instance.
    --- @param dt number The time since the last update, in seconds.
    function gun:update(dt)
        blur:update(self.position)

        for i, bullet in ipairs(bullets) do
            bullet:update()

            if bullet.isDestroyed then
                bullets[i] = nil
            end
        end
    end

    --- Shoots a projectile
    function gun:shoot()
        local now = os.clock()

        if now - lastBulletFired < 0.01 then return end

        lastBulletFired = now

        local bullet = Bullet.new(image)
        local gunSize = gun:getSize()
        local offset = Point.new(gunSize.x * 0.4, -10)
        local position = self.position + offset

        bullet.position:setPoint(position)
        table.insert(bullets, 1, bullet)
    end

    --- Checks if the gun's bullets intersect with the given rectangle.
    --- For each bullet in the `bullets` table, this function checks if the bullet intersects with the given rectangle.
    --- If an intersection is detected, the bullet is destroyed.
    --- @param rect Rect The rectangle to check for intersections with the gun's bullets.
    --- @return boolean true if an intersection is detected, false otherwise.
    function gun:destroyCollidingBullets(rect)
        local collisionDetected = false

        for _, bullet in ipairs(bullets) do
            if bullet:intersects(rect) then
                bullet:destroy()
                collisionDetected = true
            end
        end

        return collisionDetected
    end

    return gun
end

return Gun
