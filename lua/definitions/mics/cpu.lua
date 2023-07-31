---@meta _

---The CPU is what runs the `Code` assets in your gadget to control all your gadget's modules.
---@class CPU:Module
---@field Source Code The code asset uploaded to the CPU. READ ONLY.
---@field Time number The time since the gadget is turned on, expressed in seconds. READ ONLY.
---@field DeltaTime number The time elapsed since the last tick, expressed in seconds. READ ONLY.
---@field EventChannels Module[] A table which is used to connect each Event Channel with a module in your gadget that can trigger that channel with its events.
---@field Type "CPU"
