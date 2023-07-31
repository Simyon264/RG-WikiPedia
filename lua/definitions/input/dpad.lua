---@meta _

---A digital directional input device for your gadget, which returns what directions are being pressed.
---@class DPad:Module
---@field X number The position of the pad along the horizontal axis, only returns -100 or 100 when pressed, 0 when not. READ ONLY.
---@field Y number The position of the pad along the vertical axis, only returns -100 or 100 when pressed, 0 when not. READ ONLY.
---@field InputSourceX InputSource The module associated with the pad's horizontal axis.
---@field InputSourceY InputSource The module associated with the pad's vertical axis.
---@field Type "DPad"

---Triggered when the D-Pad is pressed.
---@class DPadValueChangeEvent
---@field X number the respective values of the pad.
---@field Y number the respective values of the pad.
---@field Type "DPadValueChangeEvent" is "DPadValueChangeEvent".
