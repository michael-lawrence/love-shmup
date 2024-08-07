--- @module 'shmup.entities.bullet'
local Bullet = {}

local Point = require('shmup.drawing.point')
local Rect = require('shmup.drawing.rect')
local G = love.graphics

--- Creates a new bullet instance.
--- @return Bullet Bullet The bullet instance.
--- @param image love.Image The image to use for the bullet
function Bullet.new(image)
    local canvas = G.newCanvas()
    local imageSize = Point.new(image:getDimensions())

    --- @class Bullet
    --- @field position Point The coordinates where the bullet currently is.
    --- @field scale Point The scale of the image being rendered.
    --- @field rotation number The rotation to render the image.
    --- @field speed number The speed in pixels that the bullet will move each frame.
    local bullet = {
        position = Point.new(0, 0),
        scale = Point.new(0.25, 0.25),
        rotation = 0,
        speed = 10,
        isDestroyed = false
    }

    --- Draws the bullet on the screen at their current position, rotation, and scale.
    function bullet:draw()
        if self.isDestroyed then return end

        local oldCanvas = G.getCanvas()
        G.setCanvas(canvas)
        G.clear()
        G.draw(image, self.position.x, self.position.y, self.rotation, self.scale.x, self.scale.y)
        G.setCanvas(oldCanvas)
        G.draw(canvas)
    end

    --- Returns the width and height of the player's image, scaled by the player's scale.
    --- @return Point point The size of the player's image, scaled.
    function bullet:getSize()
        return imageSize * self.scale
    end

    --- Returns a rectangle representing the bullet's position and size.
    --- @return Rect The rectangle representing the bullet's position and size.
    function bullet:getRect()
        return Rect.new(self.position.x, self.position.y, imageSize.x, imageSize.y)
    end

    --- Moves the player up by the player's speed.
    function bullet:moveUp()
        self.position.y = math.max(0, self.position.y - self.speed)
    end

    --- Updates the bullet's position and destroys the bullet if it has reached the top of the screen.
    function bullet:update()
        if self.isDestroyed then return end

        local oldY = self.position.y
        self:moveUp()

        if oldY == self.position.y then
            self:destroy()
        end
    end

    --- Marks the bullet as destroyed, indicating it should no longer be drawn or updated.
    function bullet:destroy()
        self.isDestroyed = true
    end

    --- Checks if the bullet's rectangular area intersects with the given rectangle.
    --- @param rect Rect The rectangle to check for intersection.
    --- @return boolean true if the bullet's area intersects with the given rectangle, false otherwise.
    function bullet:intersects(rect)
        local bulletRect = self:getRect()
        return bulletRect:intersects(rect)
    end

    return bullet
end

return Bullet
