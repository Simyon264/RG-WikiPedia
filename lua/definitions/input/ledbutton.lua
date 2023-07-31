---@meta _

---A button that can tell when it's pressed or released, and can glow with a `LED` embedded in it.
---@class LedButton:Module
---@field ButtonState boolean Returns `true` if the button is currently pressed, `false` otherwise. READ ONLY.
---@field ButtonDown boolean A boolean flag which will be true only in the time tick the corresponding button changes its state to pressed. READ ONLY.
---@field ButtonUp boolean  A boolean flag which will be true only in the time tick the corresponding button changes its state to released. READ ONLY.
---@field InputSource InputSource An `InputSource` to be used to trigger the button state.
---@field LedState boolean The lit/unlit state of the Led of this button.
---@field LedColor color The color of the Led of this button.
---@field Type "LedButton"

---Triggered when the LedButton is pressed or released.
---@class LedButtonEvent
---@field ButtonDown boolean is `true` if the button was just pressed.
---@field ButtonUp boolean is `true` is the button was just released.
---@field Type "LedButtonEvent" is "LedButtonEvent".
