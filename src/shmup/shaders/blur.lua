--- @module 'shmup.shaders.blur'
--- @class shmup.shaders.Blur
--- @field offset table The offset of the blur.
--- @field size shmup.drawing.Point The size of the canvas.
--- @field sensitivity number The sensitivity of the blur.
--- @field zeroRadius number The radius at which the blur will be zero.
--- @field shader love.Shader The shader to use for rendering.
local P = {}

local Point = require('shmup.drawing.point')
local G = love.graphics

--- Creates a new blur shader instance.
--- @return shmup.shaders.Blur The new blur shader instance.
function P:new()
    local imageW, imageH = G.getDimensions()
    local o = {
        offset = { 0, 0 },
        size = Point:new({ x = imageW, y = imageH }),
        sensitivity = 0.05,
        zeroRadius = 1000,
        shader = G.newShader('assets/shaders/blur.frag'),
    }

    --send data to GPU
    o.shader:send("CanvasSize", { o.size:get() })

    setmetatable(o, self)
    self.__index = self

    return o
end

--- Draws the blur shader.
--- This function sets the current shader to the blur shader, which can then be used for rendering.
function P:draw()
    G.setShader(self.shader)
end

--- Resets the current shader to the default shader.
function P:reset()
    G.setShader()
end

--- Updates the blur shader based on the given mouse position.
--- If the target position is within the `zeroRadius` distance from the center of the canvas, the blur offset is set to 0.
--- Otherwise, the blur offset is calculated based on the target position and the `sensitivity` value.
--- @param position shmup.drawing.Point The coordinates of the target position.
function P:update(position)
    local doubleSize = Point:new({ x = 2, y = 2 })
    local m = position - self.size / doubleSize;
    local m2 = m * m
    local msq = m2.x + m2.y

    if msq < self.zeroRadius * self.zeroRadius then
        self.offset = { 0, 0 }
        self.shader:send("Blur", self.offset)
    else
        local mult = self.sensitivity * (1 - self.zeroRadius / math.sqrt(msq))
        self.offset = { mult * m.x, mult * m.y }
        self.shader:send("Blur", self.offset)
    end
end

return P
