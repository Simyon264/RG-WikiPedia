---@meta _

---@class color

---@param r number
---@param g number
---@param b number
---@return color
---Compose and returns a RGB Color object.
---Values for the 3 channels are always expressed in the range 0-255.
function Color(r, g, b) end

---@param r number
---@param g number
---@param b number
---@param a number
---@return color
---Compose and returns a RGB Color object, with Alpha.
---Values for the 4 channels are always expressed in the range 0-255.
---Alpha 0 is transparent.
function ColorRGBA(r, g, b, a) end

---@param h number
---@param s number
---@param v number
---@return color
---Compose and returns a RGB Color Object, expressing it in HSV values.
---Hue [0-360].
---Saturation [0-100].
---Value [0-100].
function ColorHSV(h, s, v) end

color = {
    black = Color(0, 0, 0),
    blue = Color(0, 0, 255),
    clear = ColorRGBA(0, 0, 0, 0),
    cyan = Color(0, 255, 255),
    gray = Color(24, 22, 13),
    green = Color(0, 255, 0),
    magenta = Color(255, 0, 255),
    red = Color(255, 0, 0),
    white = Color(255, 255, 255),
    yellow = Color(255, 255, 0),
}