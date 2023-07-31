---@meta _

---A grid of buttons that can be used in a group.
---@class Keypad:Module
---@field ButtonsState boolean[][] A multi-dimensional table mapping the state of each button to a boolean value. READ ONLY.
---@field ButtonsDown boolean[][] A multi-dimensional table mapping boolean flags which will be true only in the time tick the corresponding button changes its state to pressed. READ ONLY.
---@field ButtonsUp boolean[][] A multi-dimensional table mapping boolean flags which will be true only in the time tick the corresponding button changes its state to released. READ ONLY.
---@field ButtonsInputSource InputSource[][] A multi-dimensional table mapping `InputSources` to each of the buttons in the Keypad.
---@field Type "Keypad"

---Triggered when a button is pressed or released.
---@class KeypadButtonEvent
---@field X number is the column of the button that triggered the event.
---@field Y number is the row of the button that triggered the event.
---@field ButtonDown boolean is `true` if the button was just pressed.
---@field ButtonUp boolean is `true` is the button was just released.
---@field Type "KeypadButtonEvent" is "KeypadButtonEvent".
