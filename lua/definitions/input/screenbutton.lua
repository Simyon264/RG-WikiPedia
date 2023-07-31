---@meta _

---A button that can display images on itself, meaning that it works like a `Screen` and a `Button` at the same time.
---The resolution of the screen inside the button is 16x16.
---@class ScreenButton:Module
---@field ButtonState boolean Returns `true` if the button is currently pressed, `false` otherwise. READ ONLY.
---@field ButtonDown boolean A boolean flag which will be true only in the time tick the corresponding button changes its state to pressed. READ ONLY.
---@field ButtonUp boolean A boolean flag which will be true only in the time tick the corresponding button changes its state to released. READ ONLY.
---@field InputSource InputSource An `InputSource` to be used to trigger the button state.
---@field VideoChip VideoChip The `VideoChip` the screen part of this button is bound to.
---@field Offset vec2 The offset of the screen's top-left position in the corresponding VideoChip's overall rendering buffer. READ ONLY.
---@field Width number The width of the screen in pixels. READ ONLY.
---@field Height number The height of the screen in pixels. READ ONLY.
---@field Type "ScreenButton"

---Triggered when the ScreenButton is pressed or released.
---@class ScreenButtonEvent
---@field ButtonDown boolean is `true` if the button was just pressed.
---@field ButtonUp boolean is `true` is the button was just released.
---@field Type "ScreenButtonEvent" is "ScreenButtonEvent".
