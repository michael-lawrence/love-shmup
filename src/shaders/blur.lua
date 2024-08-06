require('drawing.point')

--- @module 'shaders.blur'
Blur = {}

local G = love.graphics

--- Creates a new blur shader instance.
--- @return Blur The new blur shader instance.
function Blur.new()
    local Offset = { 0, 0 }
    local size = Point.new(G.getDimensions())
    local sensitivity = 0.05
    local zeroRadius = 1000

    local shader = G.newShader('assets/shaders/blur.frag')
    shader:send("CanvasSize", { size:get() })

    --- @class Blur
    local blur = {}

    --- Draws the blur shader.
    --- This function sets the current shader to the blur shader, which can then be used for rendering.
    function blur:draw()
        G.setShader(shader)
    end

    --- Resets the current shader to the default shader.
    function blur:reset()
        G.setShader()
    end

    --- Updates the blur shader based on the given mouse position.
    ---
    --- If the target position is within the `zeroRadius` distance from the center of the canvas, the blur offset is set to 0.
    --- Otherwise, the blur offset is calculated based on the target position and the `sensitivity` value.
    ---
    --- @param position Point The coordinates of the target position.
    function blur:update(position)
        local doubleSize = Point.new(2, 2)
        local m = position - size / doubleSize;
        local m2 = m * m
        local msq = m2.x + m2.y

        if msq < zeroRadius * zeroRadius then
            Offset = { 0, 0 }
            shader:send("Blur", Offset)
        else
            local mult = sensitivity * (1 - zeroRadius / math.sqrt(msq))
            Offset={ mult * m.x, mult * m.y }
            shader:send("Blur", Offset)
        end
    end

    return blur
end

return Blur