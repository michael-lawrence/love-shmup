--- @module 'shmup.drawing.point'
--- @class shmup.drawing.Point
--- @field x number The x coordinate of the point.
--- @field y number The y coordinate of the point.
local Point = {}

--- Creates a new point instance.
--- @param x number The x coordinate of the new point. If not provided, defaults to 0.
--- @param y number The y coordinate of the new point. If not provided, defaults to 0.
--- @return shmup.drawing.Point Point The point instance.
function Point:new(x, y)
    local o = {
        x = x or 0,
        y = y or 0,
    }

    setmetatable(o, self)
    self.__index = self

    return o
end

--- Adds two points together and returns a new point with the sum of their coordinates.
--- @param point shmup.drawing.Point The point to add to this point.
--- @return shmup.drawing.Point The new point with the sum of the coordinates of the input points.
function Point:add(point)
    return Point:new(self.x + point.x, self.y + point.y)
end

--- Subtracts two points and returns a new point with the difference of their coordinates.
--- @param point shmup.drawing.Point The point to subtract from this point.
--- @return shmup.drawing.Point The new point with the difference of the coordinates of the input points.
function Point:sub(point)
    return Point:new(self.x - point.x, self.y - point.y)
end

--- Multiplies two points and returns a new point with the product of their coordinates.
--- @param point shmup.drawing.Point The point to multiply with this point.
--- @return shmup.drawing.Point The new point with the product of the coordinates of the input points.
function Point:mul(point)
    return Point:new(self.x * point.x, self.y * point.y)
end

--- Divides two points and returns a new point with the quotient of their coordinates.
--- @param point shmup.drawing.Point The point to divide this point by.
--- @return shmup.drawing.Point The new point with the quotient of the coordinates of the input points.
function Point:div(point)
    return Point:new(self.x / point.x, self.y / point.y)
end

--- Sets the x and y coordinates of the point.
--- @param xValue number The new x coordinate.
--- @param yValue number The new y coordinate.
function Point:set(xValue, yValue)
    self.x, self.y = xValue, yValue
end

--- Sets the coordinates of the point.
--- @param value shmup.drawing.Point The new coordinates.
function Point:setPoint(value)
    self.x, self.y = value:get()
end

--- Gets the x and y coordinates of the point.
--- @return number x The x coordinate.
--- @return number y The y coordinate.
function Point:get()
    return self.x, self.y
end

--- Gets the x and y coordinates of the point as a new Point.
--- @return shmup.drawing.Point point The coordinates of the point.
function Point:getPoint()
    return Point:new(self.x, self.y)
end

--- Checks if the point is inside the given rect.
--- @param rect shmup.drawing.Rect The rect to check if the point is inside.
--- @return boolean
function Point:inside(rect)
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
function Point:distance(point2)
    return math.sqrt((self.x - point2.x) ^ 2 + (self.y - point2.y) ^ 2)
end

Point.__add = function(a, b) return a:add(b) end
Point.__sub = function(a, b) return a:sub(b) end
Point.__mul = function(a, b) return a:mul(b) end
Point.__div = function(a, b) return a:div(b) end

return Point
