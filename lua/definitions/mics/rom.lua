---@meta _

---@class ROMUser
---@field Assets table<string,Asset> Returns a table of all assets regardless of type. READ ONLY.
---@field SpriteSheets table<string,SpriteSheet> Returns a table of only SpriteSheets. READ ONLY.
---@field Codes table<string,Code> Returns a table of only Code assets. READ ONLY.
---@field AudioSamples table<string,AudioSample> Returns a table of only AudioSamples. READ ONLY.

---@class ROMSystem
---@field Assets table<string,Asset> Returns a table of all assets regardless of type. READ ONLY.
---@field SpriteSheets table<string,SpriteSheet> Returns a table of only SpriteSheets. READ ONLY.
---@field Codes table<string,Code> Returns a table of only Code assets. READ ONLY.
---@field AudioSamples table<string,AudioSample> Returns a table of only AudioSamples. READ ONLY.

---The ROM chip gives you access to assets through code. These include some built-in assets such as the StandardFont.
---@class ROM:Module
---@field User ROMUser
---@field System ROMSystem
---@field Type "ROM"
