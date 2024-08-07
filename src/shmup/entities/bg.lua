local GraphicsController = require('shmup.controllers.graphics')
local MovementController = require('shmup.controllers.movement')
local Point = require('shmup.drawing.point')
local G, W = love.graphics, love.window

local windowW, windowH = W.getMode()
local windowSize = Point:new({ x = windowW, y = windowH })
local numScreens = 100

--- @class shmup.entities.BG
--- @field controllers table A table of all the controllers that are currently active.
--- @field controllers.graphics shmup.controllers.GraphicsController The graphics controller.
--- @field controllers.movement shmup.controllers.MovementController The movement controller.
local P = {}

--- Creates a new background instance.
--- @return shmup.entities.BG BG The new background instance.
function P:new(defaults)
    defaults = defaults or {}

    local movementController = MovementController:new({
        speed = defaults.speed or 1,
        position = defaults.position or Point:new({ x = 0, y = -windowSize.y * (numScreens - 1) }),
    })

    local graphicsController = GraphicsController:new({
        imagePath = defaults.imagePath,
        scale = defaults.scale or Point:new({ x = 0.35, y = 0.35 }),
        rotation = defaults.rotation or 0,
        position = movementController.position
    })

    graphicsController.image:setWrap('repeat', 'repeat')
    graphicsController.quad = G.newQuad(
        0, 0, windowSize.x, windowSize.y * numScreens, graphicsController.image:getDimensions()
    )

    local o = {
        controllers = {
            graphics = graphicsController,
            movement = movementController
        }
    }

    setmetatable(o, self)
    self.__index = self

    return o
end

function P:update()
    local movement = self.controllers.movement
    local graphics = self.controllers.graphics
    movement:down()
    graphics:setPosition(movement.position)
end

--- Draws the background image on the screen at the current position.
function P:draw()
    self.controllers.graphics:draw()
end

return P
