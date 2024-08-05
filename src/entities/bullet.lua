require('drawing.point')

---@module 'entities.bullet'
Bullet = {}

local G = love.graphics

--- Creates a new bullet instance.
---@return Bullet Bullet The bullet instance.
function Bullet.new()
    local canvas = G.newCanvas()
    local image = G.newImage('assets/beam.png')
    image:setFilter('nearest', 'linear')

    ---@class Bullet
    ---@field position Point The coordinates where the bullet currently is.
    ---@field scale Point The scale of the image being rendered.
    ---@field rotation number The rotation to render the image.
    ---@field speed number The speed in pixels that the bullet will move each frame.
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

    --- Moves the player up by the player's speed.
    function bullet:moveUp()
        self.position.y = math.max(0, self.position.y - self.speed)
    end

    function bullet:update()
        if self.isDestroyed then return end

        local oldY = self.position.y
        self:moveUp()

        if oldY == self.position.y then
            self:destroy()
        end
    end

    function bullet:destroy()
        self.isDestroyed = true
    end

    return bullet
end

return Bullet
