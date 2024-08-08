--- @class shmup.controllers.HealthController
--- @field total number The total number of health points.
--- @field current number The current number of health points.
local P = {};

function P:new(defaults)
    defaults = defaults or {}

    local o = {
        total = defaults.total or 100,
        current = defaults.current or 100,
    }

    setmetatable(o, self)
    self.__index = self

    return o
end

function P:reset()
    self.current = self.total
end

function P:heal(amount)
    self.current = math.min(self.current + amount, self.total)
end

function P:damage(amount)
    self.current = math.max(self.current - amount, 0)
end

function P:isDead()
    return self.current <= 0
end

function P:getPercentage()
    return self.current / self.total
end

return P
