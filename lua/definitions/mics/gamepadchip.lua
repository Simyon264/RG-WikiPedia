---@meta _

---@class GamepadInputNameAxis
---@class GamepadInputNameButton
---@alias GamepadInputName GamepadInputNameAxis|GamepadInputNameButton

---The GamepadChip allows you to control your gadgets using your computer's real game controller.
---@class GamepadChip:Module
---@field GamepadIndex number Setting this property allows you to select which one of the gamepads currently connected to your computer the chip will use.
---@field IsActive boolean Returns whether or not the selected gamepad is currently active (plugged in and available) on your computer. READ ONLY.
---@field Type "GamepadChip"
---@field GetButton fun(self:GamepadChip, name:GamepadInputNameButton):InputSource Returns an InputSource for a given button.
---@field GetAxis fun(self:GamepadChip, name:GamepadInputNameAxis):InputSource Returns an InputSource for a given button.
---@field GetButtonAxis fun(self:GamepadChip, negativeName:GamepadInputNameButton, positiveName:GamepadInputNameButton):InputSource Returns an InputSource axis controlled by two given buttons, one for negative and one for positive values.

---Triggered when a gamepad becomes active or inactive.
---@class GamepadChipIsActiveEvent
---@field IsActive boolean returns whether or not the selected gamepad currently became active.
---@field Type "GamepadChipIsActiveEvent" is "GamepadChipIsActiveEvent"

---Triggered when a gamepad control is pressed or released.
---@class GamepadChipButtonEvent
---@field ButtonDown boolean is `true` if a button or axis was pressed at this event.
---@field ButtonUp boolean is `true` if a button or axis was released at this event.
---@field IsAxis boolean is `true` if the input that triggered this event is an axis.
---@field InputName GamepadInputName returns the input name of the key that triggered this event.
---@field Type "GamepadChipButtonEvent" is "GamepadChipButtonEvent"

---@package
---@return GamepadInputNameAxis
function __new_input_name_axis__() end

---@package
---@return GamepadInputNameButton
function __new_input_name_button__() end

GamepadChip = {
    LeftStickX = __new_input_name_axis__(),
    LeftStickY = __new_input_name_axis__(),
    RightStickX = __new_input_name_axis__(),
    RightStickY = __new_input_name_axis__(),
    ActionBottomRow1 = __new_input_name_button__(),
    ActionBottomRow2 = __new_input_name_button__(),
    ActionBottomRow3 = __new_input_name_button__(),
    ActionTopRow1 = __new_input_name_button__(),
    ActionTopRow2 = __new_input_name_button__(),
    ActionTopRow3 = __new_input_name_button__(),
    LeftShoulder1 = __new_input_name_button__(),
    LeftShoulder2 = __new_input_name_button__(),
    RightShoulder1 = __new_input_name_button__(),
    RightShoulder2 = __new_input_name_button__(),
    Center1 = __new_input_name_button__(),
    Center2 = __new_input_name_button__(),
    Center3 = __new_input_name_button__(),
    LeftStickButton = __new_input_name_button__(),
    RightStickButton = __new_input_name_button__(),
    DPadUp = __new_input_name_button__(),
    DPadRight = __new_input_name_button__(),
    DPadDown = __new_input_name_button__(),
    DPadLeft = __new_input_name_button__(),
}
