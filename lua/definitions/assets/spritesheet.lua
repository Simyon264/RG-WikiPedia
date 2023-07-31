---@meta _

---A SpriteSheet asset contains images to be used in a gadget, which can be displayed with the `VideoChip` and `Screen`, or printed as stickers to decorate the shell of the gadget.
---@class SpriteSheet:Asset
---@field Palette Palette Returns the palette used in the sprite sheet, which can be seen in the Sprite Editor. Currently, there's no code that can be used with this. READ ONLY.
---@field Type "SpriteSheet"
---@field GetPixelData fun(self:SpriteSheet):PixelData Returns a PixelData object containing the SpriteSheet data.
---@field GetSpritePixelData fun(self:SpriteSheet, spriteX:number, spriteY:number):PixelData Returns a PixelData object containing the data of a specific sprite. The sprite is identified by `spriteX` and `spriteY` which represent its coordinate on the grid.
