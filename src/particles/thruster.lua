require('drawing.point')

---@module 'particles.thruster'
Thruster = {}

local G = love.graphics
local image = G.newImage('assets/particles/lightBlur.png')
image:setFilter("linear", "linear")

--- Creates a new thruster instance.
--- @return Thruster Thruster The new thruster instance.
function Thruster.new()
    local buffer = 47;
    local canvas = G.newCanvas()
    local particles = G.newParticleSystem(image, buffer)
    particles:setColors(0.40625, 0, 1, 1, 0, 0.4140625, 1, 1, 1, 0, 0.890625, 1, 1, 1, 1, 0.171875)
    particles:setDirection(1.6)
    particles:setEmissionArea("none", 0, 0, 0, false)
    particles:setEmissionRate(20)
    particles:setEmitterLifetime(-1)
    particles:setInsertMode("top")
    particles:setLinearAcceleration(0, 0, 0, 0)
    particles:setLinearDamping(0, 0)
    particles:setOffset(60, 60)
    particles:setParticleLifetime(1.8, 2.2)
    particles:setRadialAcceleration(0, 0)
    particles:setRelativeRotation(false)
    particles:setRotation(-3.1415927410126, 0)
    particles:setSizes(0.4)
    particles:setSizeVariation(0)
    particles:setSpeed(90, 100)
    particles:setSpin(0, 0)
    particles:setSpinVariation(0)
    particles:setSpread(0.5684786438942)
    particles:setTangentialAcceleration(0, 0)
    particles:emit(0)
    particles:update(0)

    ---@class Thruster
    ---@field position Point The coordinates the thruster will be rendered at.
    local thruster = {
        position = Point.new(0, 0),
    }

    --- Draws the thruster particle system on the screen at the current position.
    function thruster:draw()
        local oldCanvas = G.getCanvas()
        local oldBlendMode = G.getBlendMode()
        G.setCanvas(canvas)
        G.clear()
        --G.setBlendMode('add')
        G.draw(particles)
        G.setCanvas(oldCanvas)
        G.draw(canvas)
        G.setBlendMode(oldBlendMode)
    end

    --- Updates the thruster particle system.
    --- @param dt number The time since the last update, in seconds.
    function thruster:update(dt)
        particles:setPosition(self.position:get())
        particles:update(dt)
    end

    --- Sets the position of the thruster particle system.
    ---@param position Point The new coordinates of the thruster particle system.
    function thruster:setPosition(position)
        self.position:setPoint(position)
    end

    return thruster
end

return Thruster
