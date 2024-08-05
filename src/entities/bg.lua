require('drawing.point')

---@module 'entities.bg'
BG = {}

local numScreens = 100
local image = love.graphics.newImage('assets/bg.png')
image:setWrap('repeat', 'repeat')

--- Creates a new background instance.
--- @return BG BG The new background instance.
function BG.new()
    local windowSize = Point.new(love.window.getMode())

    ---@class BG
    ---@field position Point The current position of where the background is being rendered.
    ---@field speed number How fast, in pixels, the background scrolls.
    local bg = {
        position = Point.new(0, -windowSize.y * (numScreens - 1)),
        speed = 1,
    }

    local quad = love.graphics.newQuad(0, 0, windowSize.x, windowSize.y * numScreens, image:getDimensions())

    --- Draws the background image on the screen at the current position.
    function bg:draw()
        love.graphics.draw(image, quad, self.position:get())
    end

    --- Moves the background up by the background's speed.
    function bg:moveUp()
        self.position.y = self.position.y - self.speed
    end

    --- Moves the background down by the background's speed.
    function bg:moveDown()
        self.position.y = self.position.y + self.speed
    end

    return bg
end

return BG