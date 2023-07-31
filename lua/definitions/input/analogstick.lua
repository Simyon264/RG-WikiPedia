---@meta _

---A little joystick-like input device for your gadget, which has smooth movement in all directions.
---@class AnalogStick:Module
---@field X number The position of the stick along the horizontal axis, ranging from -100 to 100. READ ONLY.
---@field Y number The position of the stick along the vertical axis, ranging from -100 to 100. READ ONLY.
---@field InputSourceX InputSource The module associated with the stick's horizontal axis.
---@field InputSourceY InputSource The module associated with the stick's vertical axis.
---@field Type "AnalogStick"

---Triggered when the stick is moved.
---@class StickValueChangeEvent
---@field X number the respective values of the stick.
---@field Y number the respective values of the stick.
---@field Type "StickValueChangeEvent" is "StickValueChangeEvent".
