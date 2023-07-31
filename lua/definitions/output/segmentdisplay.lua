---@meta _

---A collection of different seven-segment displays for showing numbers.
---@class SegmentDisplay:Module
---@field States boolean[][] A table that maps the lit/unlit state of each of the segments in the display.
---@field Colors color[][] A table that maps the color of each of the segments in the display.
---@field ShowDigit fun(self:SegmentDisplay, groupIndex:number, digit:number) A helper function to show a numerical digit in a whole display. `groupIndex` is the digit that you want the number to show on, `digit` is the number you want to show.
---@field SetDigitColor fun(self:SegmentDisplay, groupIndex:number, color:color) A helper function to set the color of a whole numerical digit at once. `groupIndex` is the digit that you want to change the color of, `color` is the color you want to set it to.
---@field Type "SegmentDisplay"
