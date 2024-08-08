local GraphicsController = require('shmup.controllers.graphics')
local HealthController = require('shmup.controllers.health')
local Point = require('shmup.drawing.point')

--- @class shmup.entities.Health
--- @field controllers table A table of all the controllers that are currently active.
--- @field controllers.bgGraphics shmup.controllers.GraphicsController The graphics controller for the background.
--- @field controllers.barGraphics shmup.controllers.GraphicsController The graphics controller for the health bar.
--- @field controllers.health shmup.controllers.HealthController The health controller.
local P = {}

--- Creates a new health instance.
--- @return shmup.entities.Health health The new health instance.
function P:new(defaults)
    defaults = defaults or {}

    local bgGraphicsController = GraphicsController:new({
        imagePath = defaults.bgImagePath,
        scale = defaults.bgScale or Point:new({ x = 1, y = 1 }),
        rotation = defaults.bgRotation or 0,
        position = defaults.bgPosition or Point:new({ x = 0, y = 0 }),
    })

    local barGraphicsController = GraphicsController:new({
        imagePath = defaults.barImagePath,
        scale = defaults.barScale or Point:new({ x = 1, y = 1 }),
        rotation = defaults.barRotation or 0,
        position = defaults.barPosition or Point:new({ x = 0, y = 0 }),
    })

    local healthController = HealthController:new({
        total = defaults.totalHealth,
        current = defaults.currentHealth,
    })

    local o = {
        controllers = {
            bgGraphics = bgGraphicsController,
            barGraphics = barGraphicsController,
            health = healthController,
        }
    }

    setmetatable(o, self)
    self.__index = self

    return o
end

function P:update()
    local percent = self.controllers.health:getPercentage()
    self.controllers.barGraphics:setScale(Point:new({ x = percent, y = 1 }))
end

function P:draw()
    self.controllers.bgGraphics:draw()
    self.controllers.barGraphics:draw()
end

function P:damage(amount)
    self.controllers.health:damage(amount)
end

return P
