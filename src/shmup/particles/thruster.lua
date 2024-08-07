--- @module 'shmup.particles.thruster'
--- @class shmup.particles.Thruster
--- @field position shmup.drawing.Point The coordinates the thruster will be rendered at.
--- @field buffer number The buffer size of the particles.
--- @field canvas love.Canvas The canvas to draw the particles on.
--- @field particles love.ParticleSystem The particle system to use for the thruster.
local Thruster = {}

local Point = require('shmup.drawing.point')
local G = love.graphics
local image = G.newImage('assets/particles/lightBlur.png')
image:setFilter("linear", "linear")

--- Creates a new thruster instance.
--- @return shmup.particles.Thruster Thruster The new thruster instance.
function Thruster:new()
    local buffer = 10
    local particles = G.newParticleSystem(image, buffer)
    local o = {
        position = Point:new(0, 0),
        buffer = buffer,
        canvas = G.newCanvas(),
        particles = particles,
    }

    particles:setColors(
        1, 0, 0, 0.75,
        1, 0.5, 0, 0.75,
        1, 1, 1, 0.75
    )
    particles:setDirection(1.6)
    particles:setEmissionArea("none", 0, 0, 0, false)
    particles:setEmissionRate(20)
    particles:setEmitterLifetime(-1)
    particles:setInsertMode("top")
    particles:setLinearAcceleration(0, 0, 0, 0)
    particles:setLinearDamping(0, 0)
    particles:setOffset(60, 60)
    particles:setParticleLifetime(0.1, 0.2)
    particles:setRadialAcceleration(0, 0)
    particles:setRelativeRotation(false)
    particles:setRotation(-3, 0)
    particles:setSizes(0.1, 0)
    particles:setSizeVariation(0)
    particles:setSpeed(90, 100)
    particles:setSpin(0, 0)
    particles:setSpinVariation(0)
    particles:setSpread(0)
    particles:setTangentialAcceleration(0, 0)
    particles:emit(0)
    particles:update(0)

    setmetatable(o, self)
    self.__index = self

    return o
end

--- Draws the thruster particle system on the screen at the current position.
function Thruster:draw()
    local oldCanvas = G.getCanvas()
    local oldBlendMode = G.getBlendMode()
    G.setCanvas(self.canvas)
    G.clear()
    G.setBlendMode('lighten', 'premultiplied')
    G.draw(self.particles)
    G.setCanvas(oldCanvas)
    G.draw(self.canvas)
    G.setBlendMode(oldBlendMode)
end

--- Updates the thruster particle system.
--- @param dt number The time since the last update, in seconds.
function Thruster:update(dt)
    self.particles:setPosition(self.position:get())
    self.particles:update(dt)
end

--- Sets the position of the thruster particle system.
--- @param position shmup.drawing.Point The new coordinates of the thruster particle system.
function Thruster:setPosition(position)
    self.position:setPoint(position)
end

return Thruster
