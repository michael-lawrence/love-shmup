--- @module 'shmup.shaders.crt'
local CRT = {}

local G = love.graphics

--- Creates a new crt shader instance.
--- @return crt The new crt shader instance.
function CRT.new()
    local width, height = G.getDimensions()
    local shader = G.newShader('assets/shaders/crt.frag')
    --send data to GPU
    shader:send('inputSize', { width, height })
    shader:send('textureSize', { width, height })

    --- @class crt
    local crt = {}

    --- Draws the crt shader.
    --- This function sets the current shader to the crt shader, which can then be used for rendering.
    function crt:draw()
        G.setShader(shader)
    end

    --- Resets the current shader to the default shader.
    function crt:reset()
        G.setShader()
    end

    function crt:update()

    end

    return crt
end

return CRT
