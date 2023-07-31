---@meta _

---The LcdDisplay is an alphanumerical display consisting of 2 lines, 16 characters per line. It cannot display graphics and doesn't need a `VideoChip` to work.
---@class LcdDisplay:Module
---@field Text string The text to be visualized on the LCD. To display text on the second line, your string must be formatted starting from the 17th character and beyond.
---@field BgColor color Background color for the LCD.
---@field TextColor color Foreground color for the LCD's text.
---@field Type "LcdDisplay"
