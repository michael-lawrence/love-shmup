--- @module 'shmup.drawing.point'
--- @class shmup.drawing.Point
--- @field x number The x coordinate of the point.
--- @field y number The y coordinate of the point.
local P = {}

--- Creates a new point instance.
--- @param defaults table|nil The table to use as the point's data.
--- @return shmup.drawing.Point Point The point instance.
function P:new(defaults)
    defaults = defaults or {}

    local o = {
        x = defaults.x or 0,
        y = defaults.y or 0,
    }

    setmetatable(o, self)
    self.__index = self

    return o
end

--- Adds two points together and returns a new point with the sum of their coordinates.
--- @param point shmup.drawing.Point The point to add to this point.
--- @return shmup.drawing.Point The new point with the sum of the coordinates of the input points.
function P:add(point)
    return P:new({
        x = self.x + point.x,
        y = self.y + point.y,
    })
end

--- Subtracts two points and returns a new point with the difference of their coordinates.
--- @param point shmup.drawing.Point The point to subtract from this point.
--- @return shmup.drawing.Point The new point with the difference of the coordinates of the input points.
function P:sub(point)
    return P:new({
        x = self.x - point.x,
        y = self.y - point.y,
    })
end

--- Multiplies two points and returns a new point with the product of their coordinates.
--- @param point shmup.drawing.Point The point to multiply with this point.
--- @return shmup.drawing.Point The new point with the product of the coordinates of the input points.
function P:mul(point)
    return P:new({
        x = self.x * point.x,
        y = self.y * point.y,
    })
end

--- Divides two points and returns a new point with the quotient of their coordinates.
--- @param point shmup.drawing.Point The point to divide this point by.
--- @return shmup.drawing.Point The new point with the quotient of the coordinates of the input points.
function P:div(point)
    return P:new({
        x = self.x / point.x,
        y = self.y / point.y,
    })
end

--- Sets the x and y coordinates of the point.
--- @param xValue number The new x coordinate.
--- @param yValue number The new y coordinate.
function P:set(xValue, yValue)
    self.x, self.y = xValue, yValue
end

--- Sets the coordinates of the point.
--- @param value shmup.drawing.Point The new coordinates.
function P:setPoint(value)
    self.x, self.y = value:get()
end

--- Gets the x and y coordinates of the point.
--- @return number x The x coordinate.
--- @return number y The y coordinate.
function P:get()
    return self.x, self.y
end

--- Gets the x and y coordinates of the point as a new Point.
--- @return shmup.drawing.Point point The coordinates of the point.
function P:getPoint()
    return P:new({
        x = self.x,
        y = self.y,
    })
end

--- Checks if the point is inside the given rect.
--- @param rect shmup.drawing.Rect The rect to check if the point is inside.
--- @return boolean
function P:inside(rect)
    if self.x < rect.x
        or self.y < rect.y
        or self.x > rect.x + rect.w
        or self.y > rect.y + rect.h
    then
        return false
    end

    return true
end

--- Gets the distance between two points.
--- @param point2 shmup.drawing.Point The second point to get the distance to.
--- @return number
function P:distance(point2)
    return math.sqrt((self.x - point2.x) ^ 2 + (self.y - point2.y) ^ 2)
end

P.__add = function(a, b) return a:add(b) end
P.__sub = function(a, b) return a:sub(b) end
P.__mul = function(a, b) return a:mul(b) end
P.__div = function(a, b) return a:div(b) end

return P
