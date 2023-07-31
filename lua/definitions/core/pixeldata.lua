---@meta _

---@class PixelData
---@field Width number Width in pixels of the buffer. READ ONLY.
---@field Height number Height in pixels of the buffer. READ ONLY.
---@field Clear fun(self:PixelData, c:color) Clear with `color`.
---@field GetPixel fun(self:PixelData, x:number, y:number):color Returns the `color` of the pixel at the coordinate specified by `x` and `y`.
---@field SetPixel fun(self:PixelData, x:number, y:number, color:color) Sets the `color` of the pixel at the coordinate specified by `x` and `y`.

PixelData = {
    ---@param width number
    ---@param height number
    ---@param color color
    ---@return PixelData
    ---Constructor used to create a PixelData.
    ---`width` and `height` represent its size while `color` defines the color with which it is initialized.
    new = function (width, height, color) end,
}