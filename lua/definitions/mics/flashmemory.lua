---@meta _

---The FlashMemory module allows you to store persistent data while your gadget is powered off or even put away while you're not playing Retro Gadgets.
---@class FlashMemory:Module
---@field Size number Returns the overall capacity of the memory in bytes. READ ONLY.
---@field Usage number Returns the amount of data in bytes currently stored. READ ONLY.
---@field Type "FlashMemory"
---@field Save fun(self:FlashMemory, table:table):boolean Saves `table` into the flash memory. Returns `true` if saving was successful, `false` otherwise.
---@field Load fun(self:FlashMemory):table Returns the table stored in the memory.
