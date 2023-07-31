---@meta _

desk = {}

---@return boolean
---Returns `true` if the lamp is on, `false` otherwise.
function desk.GetLampState() end

---@param state boolean
---Passing `true` to `state` will set the lamp on, and `false` will turn it off.
function desk.SetLampState(state) end

---@param color color
---Sets the lamp's color to `color`.
function desk.SetLampColor(color) end

---@param message string
---@param persistent boolean whether to keep the message forever or if it should disappear after a few seconds.
---Displays a message `message` with a blue background.
function desk.ShowMessage(message, persistent) end

---@param message string
---@param persistent boolean whether to keep the message forever or if it should disappear after a few seconds.
---Displays a message `message` with a flashing yellow background.
function desk.ShowWarning(message, persistent) end

---@param message string
---@param persistent boolean whether to keep the message forever or if it should disappear after a few seconds.
---Displays a message `message` with a flashing red background.
function desk.ShowError(message, persistent) end

---If there is currently a persistent message being displayed, this will clear the Minitool.
function desk.HideMessage() end
