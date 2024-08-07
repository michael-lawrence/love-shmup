--- @module 'shmup.shaders.crt'
--- @class shmup.shaders.CRT
--- @field shader love.Shader The shader to use for rendering.
local CRT = {}

local G = love.graphics

--- Creates a new crt shader instance.
--- @return shmup.shaders.CRT The new crt shader instance.
function CRT:new()
    local shader = G.newShader('assets/shaders/crt.frag')

    local o = {
        shader = shader
    }

    --send data to GPU
    local width, height = G.getDimensions()
    shader:send('inputSize', { width, height })
    shader:send('textureSize', { width, height })

    setmetatable(o, self)
    self.__index = self

    return o
end

--- Draws the crt shader.
--- This function sets the current shader to the crt shader, which can then be used for rendering.
function CRT:draw()
    G.setShader(self.shader)
end

--- Resets the current shader to the default shader.
function CRT:reset()
    G.setShader()
end

return CRT
