---@meta _

---A screen is what displays the images you generate with a `VideoChip`.
---@class Screen:Module
---@field VideoChip VideoChip The `VideoChip` this screen is bound to.
---@field Offset vec2 The offset of the screen's top-left position in the corresponding VideoChip's overall rendering buffer. READ ONLY.
---@field Width number The width of the screen in pixels. READ ONLY.
---@field Height number The height of the screen in pixels. READ ONLY.
---@field Type "Screen"
