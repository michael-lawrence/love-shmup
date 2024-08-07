--- @class shmup.controllers.InputController
--- @field keymap table A table of key mappings.
local P = {};

local K = love.keyboard

--- Constructs a new instance of the InputController.
--- @param defaults table|nil An optional table to use as the new instance.
--- @return shmup.controllers.InputController The new instance of the InputController.
function P:new(defaults)
    defaults = defaults or {}

    local o = {
        keymap = defaults.keymap or {},
    }

    setmetatable(o, self)
    self.__index = self

    return o
end

--- Updates the input state based on the current keyboard state.
--- This iterates through the keymap table and calls the corresponding
--- callback function for any keys that are currently pressed.
function P:update()
    for k, v in pairs(self.keymap) do
        if K.isDown(k) then v() end
    end
end

return P
