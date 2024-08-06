---@module 'drawing.point'
Point = {}

--- Adds two points together and returns a new point with the sum of their coordinates.
--- @param a Point The first point to add.
--- @param b Point The second point to add.
--- @return Point The new point with the sum of the coordinates of the input points.
function Point.add(a, b)
    return Point.new(a.x + b.x, a.y + b.y)
end

--- Subtracts two points and returns a new point with the difference of their coordinates.
--- @param a Point The first point to subtract.
--- @param b Point The second point to subtract.
--- @return Point The new point with the difference of the coordinates of the input points.
function Point.sub(a, b)
    return Point.new(a.x - b.x, a.y - b.y)
end

--- Multiplies two points and returns a new point with the product of their coordinates.
--- @param a Point The first point to multiply.
--- @param b Point The second point to multiply.
--- @return Point The new point with the product of the coordinates of the input points.
function Point.mul(a, b)
    return Point.new(a.x * b.x, a.y * b.y)
end

--- Divides two points and returns a new point with the quotient of their coordinates.
--- @param a Point The first point to divide.
--- @param b Point The second point to divide.
--- @return Point The new point with the quotient of the coordinates of the input points.
function Point.div(a, b)
    return Point.new(a.x / b.x, a.y / b.y)
end

--- Creates a new point instance.
--- @param x number The x coordinate of the new point. If not provided, defaults to 0.
--- @param y number The y coordinate of the new point. If not provided, defaults to 0.
--- @return Point Point The point instance.
function Point.new(x, y)
    x, y = x or 0, y or 0

    local mt = {
        __add = Point.add,
        __sub = Point.sub,
        __mul = Point.mul,
        __div = Point.div,
    }

    ---@class Point
    ---@field x number The x coordinate of the new point. If not provided, defaults to 0.
    ---@field y number The y coordinate of the new point. If not provided, defaults to 0.
    local point = { x = x, y = y, }

    setmetatable(point, mt);

    --- Sets the x and y coordinates of the point.
    --- @param xValue number The new x coordinate.
    --- @param yValue number The new y coordinate.
    function point:set(xValue, yValue)
        self.x, self.y = xValue, yValue
    end

    --- Sets the coordinates of the point.
    --- @param value Point The new coordinates.
    function point:setPoint(value)
        self.x, self.y = value:get()
    end

    --- Gets the x and y coordinates of the point.
    --- @return number x The x coordinate.
    --- @return number y The y coordinate.
    function point:get()
        return self.x, self.y
    end

    --- Gets the x and y coordinates of the point as a new Point.
    --- @return Point point The coordinates of the point.
    function point:getPoint()
        return Point.new(self.x, self.y)
    end

    --- Checks if the point is inside the given rect.
    ---@param rect Rect The rect to check if the point is inside.
    ---@return boolean
    function point:inside(rect)
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
    ---@param point2 Point The second point to get the distance to.
    ---@return number
    function point:distance(point2)
        return math.sqrt((self.x - point2.x) ^ 2 + (self.y - point2.y) ^ 2)
    end

    return point
end

return Point
