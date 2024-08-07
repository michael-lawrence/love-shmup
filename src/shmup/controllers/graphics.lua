local Point = require('shmup.drawing.point')
local Rect = require('shmup.drawing.rect')
local G = love.graphics

--- @class shmup.controllers.GraphicsController
--- @field scale shmup.drawing.Point The scale of the image being rendered.
--- @field position shmup.drawing.Point The position of the image being rendered.
--- @field rotation number The rotation to render the image.
--- @field canvas love.Canvas The canvas to draw the image on.
--- @field image love.Image The image to draw the graphics on.
--- @field imageSize shmup.drawing.Point The size of the image being rendered.
--- @field quad love.Quad|nil The quad to draw the image on.
local P = {};

function P:new(defaults)
    defaults = defaults or {}

    local o = {
        position = defaults.position or Point:new(),
        scale = defaults.scale or Point:new({ x = 1, y = 1 }),
        rotation = defaults.rotation or 0,
        canvas = G.newCanvas(),
        image = G.newImage(defaults.imagePath),
        quad = defaults.quad
    }

    o.image:setFilter('nearest', 'linear')

    local imageW, imageH = o.image:getDimensions()
    o.imageSize = Point:new({ x = imageW, y = imageH })

    setmetatable(o, self)
    self.__index = self

    return o
end

function P:draw()
    local oldCanvas = G.getCanvas()
    G.setCanvas(self.canvas)
    G.clear()

    if (self.quad) then
        G.draw(self.image, self.quad, self.position.x, self.position.y)
    else
        G.draw(self.image, self.position.x, self.position.y, self.rotation, self.scale.x, self.scale.y)
    end

    G.setCanvas(oldCanvas)
    G.draw(self.canvas)
end

--- Sets the scale of the image being rendered.
--- @param scale shmup.drawing.Point The new scale to set for the image.
function P:setScale(scale)
    self.scale:setPoint(scale)
end

--- Sets the position to draw the graphics at.
--- @param position shmup.drawing.Point The position to draw the graphics at.
function P:setPosition(position)
    self.position:setPoint(position)
end

--- Gets the size of the image being rendered, taking into account the scale.
--- @return shmup.drawing.Point The size of the image being rendered.
function P:getSize()
    return self.imageSize * self.scale
end

--- Gets the bounding rectangle of the graphics object, taking into account the position and scale.
--- @return shmup.drawing.Rect The bounding rectangle of the graphics object.
function P:getRect()
    return Rect:new({
        x = self.position.x,
        y = self.position.y,
        w = self.imageSize.x,
        h = self.imageSize.y,
    })
end

return P
