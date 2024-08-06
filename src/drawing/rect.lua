--- @module 'drawing.rect'
Rect = {}

--- Adds two rects together and returns a new rect with the sum of their coordinates.
--- @param a Rect The first rect to add.
--- @param b Rect The second rect to add.
--- @return Rect The new rect with the sum of the coordinates of the input rects.
function Rect.add(a, b)
    return Rect.new(a.x + b.x, a.y + b.y, a.w + b.w, a.h + b.h)
end

--- Subtracts two rects and returns a new rect with the difference of their coordinates.
--- @param a Rect The first rect to subtract.
--- @param b Rect The second rect to subtract.
--- @return Rect The new rect with the difference of the coordinates of the input rects.
function Rect.sub(a, b)
    return Rect.new(a.x - b.x, a.y - b.y, a.w - b.w, a.h - b.h)
end

--- Multiplies two rects and returns a new rect with the product of their coordinates.
--- @param a Rect The first rect to multiply.
--- @param b Rect The second rect to multiply.
--- @return Rect The new rect with the product of the coordinates of the input rects.
function Rect.mul(a, b)
    return Rect.new(a.x * b.x, a.y * b.y, a.w * b.w, a.h * b.h)
end

--- Divides two rects and returns a new rect with the quotient of their coordinates.
--- @param a Rect The first rect to divide.
--- @param b Rect The second rect to divide.
--- @return Rect The new rect with the quotient of the coordinates of the input rects.
function Rect.div(a, b)
    return Rect.new(a.x / b.x, a.y / b.y, a.w / b.w, a.h / b.h)
end

--- Creates a new rect instance.
--- @param x number The x coordinate of the new rect. If not provided, defaults to 0.
--- @param y number The y coordinate of the new rect. If not provided, defaults to 0.
--- @param w number The width of the new rect. If not provided, defaults to 0.
--- @param h number The height of the new rect. If not provided, defaults to 0.
--- @return Rect Rect The rect instance.
function Rect.new(x, y, w, h)
    x, y, w, h = x or 0, y or 0, w or 0, h or 0

    local mt = {
        __add = Rect.add,
        __sub = Rect.sub,
        __mul = Rect.mul,
        __div = Rect.div,
    }

    --- @class Rect
    --- @field x number The x coordinate of the new rect. If not provided, defaults to 0.
    --- @field y number The y coordinate of the new rect. If not provided, defaults to 0.
    --- @field w number The width of the new rect. If not provided, defaults to 0.
    --- @field h number The height of the new rect. If not provided, defaults to 0.
    local rect = { x = x, y = y, w = w, h = h }

    setmetatable(rect, mt);

    --- Sets the x and y coordinates of the rect.
    --- @param xValue number The new x coordinate.
    --- @param yValue number The new y coordinate.
    --- @param wValue number The new width.
    --- @param hValue number The new height.
    function rect:set(xValue, yValue, wValue, hValue)
        self.x, self.y, self.w, self.h = xValue, yValue, wValue, hValue
    end

    --- Sets the coordinates of the rect.
    --- @param value Rect The new coordinates.
    function rect:setRect(value)
        self.x, self.y, self.w, self.h = value:get()
    end

    --- Gets the x and y coordinates of the rect.
    --- @return number x The x coordinate.
    --- @return number y The y coordinate.
    --- @return number w The width.
    --- @return number h The height.
    function rect:get()
        return self.x, self.y, self.w, self.h
    end

    --- Gets the x and y coordinates and the width and height of the rect as a new Rect.
    --- @return Rect rect The coordinates of the rect.
    function rect:getRect()
        return Rect.new(self.x, self.y, self.w, self.h)
    end

    --- Returns if this rect intersects with the rect supplied.
    --- @param rect2 Rect The rect to test against.
    --- @return boolean intersects Whether this rect intersects with the rect supplied.
    function rect:intersects(rect2)
        return self.x < rect2.x + rect2.w and
            rect2.x < self.x + self.w and
            self.y < rect2.y + rect2.h and
            rect2.y < self.y + self.h
    end

    return rect
end

return Rect
