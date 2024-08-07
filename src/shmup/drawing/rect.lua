--- @module 'shmup.drawing.rect'
--- @class shmup.drawing.Rect
--- @field x number The x coordinate of the new rect. If not provided, defaults to 0.
--- @field y number The y coordinate of the new rect. If not provided, defaults to 0.
--- @field w number The width of the new rect. If not provided, defaults to 0.
--- @field h number The height of the new rect. If not provided, defaults to 0.
local P = {}

--- Creates a new rect instance.
--- @param defaults table|nil The table to use as the rect's data.
--- @return shmup.drawing.Rect Rect The rect instance.
function P:new(defaults)
    defaults = defaults or {}

    local o = {
        x = defaults.x or 0,
        y = defaults.y or 0,
        w = defaults.w or 0,
        h = defaults.h or 0,
    }

    setmetatable(o, self)
    self.__index = self

    return o
end

--- Adds two rects together and returns a new rect with the sum of their coordinates.
--- @param rect shmup.drawing.Rect The rect to add.
--- @return shmup.drawing.Rect rect The new rect with the sum of the coordinates of the input rects.
function P:add(rect)
    return P:new({
        x = self.x + rect.x,
        y = self.y + rect.y,
        w = self.w + rect.w,
        h = self.h + rect.h,
    })
end

--- Subtracts two rects and returns a new rect with the difference of their coordinates.
--- @param rect shmup.drawing.Rect The rect to subtract.
--- @return shmup.drawing.Rect rect The new rect with the difference of the coordinates of the input rects.
function P:sub(rect)
    return P:new({
        x = self.x - rect.x,
        y = self.y - rect.y,
        w = self.w - rect.w,
        h = self.h - rect.h,
    })
end

--- Multiplies two rects and returns a new rect with the product of their coordinates.
--- @param rect shmup.drawing.Rect The rect to multiply.
--- @return shmup.drawing.Rect rect The new rect with the product of the coordinates of the input rects.
function P:mul(rect)
    return P:new({
        x = self.x * rect.x,
        y = self.y * rect.y,
        w = self.w * rect.w,
        h = self.h * rect.h,
    })
end

--- Divides two rects and returns a new rect with the quotient of their coordinates.
--- @param rect shmup.drawing.Rect The rect to divide.
--- @return shmup.drawing.Rect rect The new rect with the quotient of the coordinates of the input rects.
function P:div(rect)
    return P:new({
        x = self.x / rect.x,
        y = self.y / rect.y,
        w = self.w / rect.w,
        h = self.h / rect.h,
    })
end

--- Sets the x and y coordinates of the rect.
--- @param xValue number The new x coordinate.
--- @param yValue number The new y coordinate.
--- @param wValue number The new width.
--- @param hValue number The new height.
function P:set(xValue, yValue, wValue, hValue)
    self.x, self.y, self.w, self.h = xValue, yValue, wValue, hValue
end

--- Sets the coordinates of the rect.
--- @param value shmup.drawing.Rect The new coordinates.
function P:setRect(value)
    self.x, self.y, self.w, self.h = value:get()
end

--- Gets the x and y coordinates of the rect.
--- @return number x The x coordinate.
--- @return number y The y coordinate.
--- @return number w The width.
--- @return number h The height.
function P:get()
    return self.x, self.y, self.w, self.h
end

--- Gets the x and y coordinates and the width and height of the rect as a new Rect.
--- @return shmup.drawing.Rect rect The coordinates of the rect.
function P:getRect()
    return P:new({
        x = self.x,
        y = self.y,
        w = self.w,
        h = self.h,
    })
end

--- Returns if this rect intersects with the rect supplied.
--- @param rect2 shmup.drawing.Rect The rect to test against.
--- @return boolean intersects Whether this rect intersects with the rect supplied.
function P:intersects(rect2)
    return self.x < rect2.x + rect2.w and
        rect2.x < self.x + self.w and
        self.y < rect2.y + rect2.h and
        rect2.y < self.y + self.h
end

P.__add = function(a, b) return a:add(b) end
P.__sub = function(a, b) return a:sub(b) end
P.__mul = function(a, b) return a:mul(b) end
P.__div = function(a, b) return a:div(b) end

return P
