--- @module 'shmup.entities.bg'
--- @class shmup.entities.BG
--- @field position shmup.drawing.Point The current position of where the background is being rendered.
--- @field speed number How fast, in pixels, the background scrolls.
local P = {}

local Point = require('shmup.drawing.point')
local G, W = love.graphics, love.window

local windowW, windowH = W.getMode()
local windowSize = Point:new({ x = windowW, y = windowH })
local numScreens = 100

local image = G.newImage('assets/bg.png')
image:setWrap('repeat', 'repeat')
image:setFilter('nearest', 'linear')

local quad = G.newQuad(0, 0, windowSize.x, windowSize.y * numScreens, image:getDimensions())

--- Creates a new background instance.
--- @return shmup.entities.BG BG The new background instance.
function P:new()
    local o = {
        position = Point:new({ x = 0, y = -windowSize.y * (numScreens - 1) }),
        speed = 1,
    }

    setmetatable(o, self)
    self.__index = self

    return o
end

--- Draws the background image on the screen at the current position.
function P:draw()
    G.draw(image, quad, self.position:get())
end

--- Moves the background up by the background's speed.
function P:moveUp()
    self.position.y = self.position.y - self.speed
end

--- Moves the background down by the background's speed.
function P:moveDown()
    self.position.y = self.position.y + self.speed
end

return P
