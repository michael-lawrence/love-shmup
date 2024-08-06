--- @module 'shaders.shake'
Shake = {}

local G = love.graphics

--- Creates a new shake shader instance.
--- @return shake The new shake shader instance.
function Shake.new()
    local width, height = G.getDimensions()
    local shader = G.newShader('assets/shaders/shake.frag')
    --send data to GPU
    shader:send('screenSize', { width, height })

    --- @class shake
    local shake = {
        shakeIntensity = 0,
        shakeDuration = 0,
    }

    --- Draws the shake shader.
    --- This function sets the current shader to the shake shader, which can then be used for rendering.
    function shake:draw()
        G.setShader(shader)
    end

    --- Resets the current shader to the default shader.
    function shake:reset()
        G.setShader()
    end

    function shake:update(dt)
        if self.shakeDuration > 0 then
            self.shakeDuration = self.shakeDuration - dt
            self.shakeIntensity = self.shakeIntensity - 1

            if self.shakeDuration <= 0 then
                self.shakeDuration = 0
                self.shakeIntensity = 0
            end
        end

        shader:send('shake', self.shakeIntensity)
    end

    function shake:trigger(intensity, duration)
        self.shakeIntensity = intensity
        self.shakeDuration = duration
    end

    return shake
end

return Shake
