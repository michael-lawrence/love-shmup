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

    --- Updates the shake effect.
    --- This function is called each frame to update the shake effect.
    --- It decreases the shake intensity and duration over time, and sends the current shake intensity to the shader.
    --- @param dt number The time since the last frame, in seconds.
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

    --- Triggers the shake effect with the specified intensity and duration.
    --- @param intensity number The intensity of the shake effect.
    --- @param duration number The duration of the shake effect in seconds.
    function shake:trigger(intensity, duration)
        self.shakeIntensity = intensity
        self.shakeDuration = duration
    end

    return shake
end

return Shake
