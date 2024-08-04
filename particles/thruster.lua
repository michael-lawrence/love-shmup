---@module 'particles.thruster'
Thruster = {}

local image = love.graphics.newImage('assets/particles/scorch_01.png')

--- Creates a new thruster instance.
--- @return Thruster Thruster The new thruster instance.
function Thruster.new()
    local pSystem = love.graphics.newParticleSystem(image, 32)

    ---@class Thruster
    local thruster = {
        position = { x = 0, y = 0 },
    }

    --- Draws the thruster particle system on the screen at the current position.
    function thruster:draw()
        love.graphics.draw(pSystem, self.position.x, self.position.y)
    end

    --- Updates the thruster particle system.
    --- @param dt number The time since the last update, in seconds.
    function thruster:update(dt)
        pSystem:update(dt)
    end

    --- Sets the position of the thruster particle system.
    ---@param x number The new x coordinate of the thruster particle system.
    ---@param y number The new y coordinate of the thruster particle system.
    function thruster:setPosition(x, y)
        self.position.x = x
        self.position.y = y
    end

    return thruster
end

return Thruster