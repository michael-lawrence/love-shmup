---@module 'particles.thruster'
Thruster = {}

local image = love.graphics.newImage('assets/particles/scorch_01.png')

--- Creates a new thruster instance.
--- @return Thruster Thruster The new thruster instance.
function Thruster.new()
    local buffer = 100;
    local width = 10;
    local height = 50;
    local canvas = love.graphics.newCanvas()
    local particles = love.graphics.newParticleSystem(image, buffer)
    particles:setParticleLifetime(0.1, 2)
    particles:setLinearAcceleration(-width, height / 2, width, height)
    particles:setSpeed(-10, 10)
    particles:setRotation(0, 20)
    particles:setSpin(5, 50)
    particles:setSizes(0.01, 0.05)
    particles:setColors(
        1, 1, 1, 1,
        1, 1, 0, 1,
        1, 0, 0, 1
    )

    ---@class Thruster
    local thruster = {
        position = { x = 0, y = 0 },
    }

    --- Draws the thruster particle system on the screen at the current position.
    function thruster:draw()
        local oldCanvas = love.graphics.getCanvas()
        love.graphics.setCanvas(canvas)
        love.graphics.clear()
        love.graphics.setBlendMode('lighten', 'premultiplied')
        love.graphics.draw(particles, self.position.x, self.position.y)
        love.graphics.setCanvas(oldCanvas)
        love.graphics.setBlendMode('alpha')
        love.graphics.draw(canvas)
    end

    --- Updates the thruster particle system.
    --- @param dt number The time since the last update, in seconds.
    function thruster:update(dt)
        particles:update(dt)
        particles:emit(buffer)
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