---@meta _

---The MagneticConnector can be used to attach different parts of your gadget together. Once two connectors are attached, you can press the button in the middle of them to detach them.
---@class MagneticConnector:Module
---@field ButtonState boolean Reflect the pressed/released state of the connector's button. READ ONLY.
---@field IsConnected boolean Returns `true` if the connector is connected to another one, `false` otherwise. READ ONLY.
---@field AttachedConnector MagneticConnector Returns the other MagneticConnector module that this one is attached to, if any. READ ONLY.
---@field Type "MagneticConnector"

---Triggered once another MagneticConnector attaches or detaches from this one.
---@class MagneticConnectorEvent
---@field IsConnected boolean is `true` if another connector is attached.
---@field Type "MagneticConnectorEvent" is "MagneticConnectorEvent"
