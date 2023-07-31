---@meta _

---@class VideoChipMode

---The `VideoChip` controls Screens and ScreenButtons to display graphics on them using `SpriteSheets`.
---@class VideoChip:Module
---@field Mode VideoChipMode The buffering mode for this VideoChip. Defaults to `VideoChipMode.DoubleBuffer`.
---@field Width number Width in pixels of the rendering buffer. The area takes into account all the displays connected to this VideoChip. READ ONLY.
---@field Height number Height in pixels of the rendering buffer. The area takes into account all the displays connected to this VideoChip. READ ONLY.
---@field RenderBuffers RenderBuffer[] List of RenderBuffers on which the VideoChip can render. READ ONLY.
---@field TouchState boolean The pressed/released state of the screen touch interaction. READ ONLY.
---@field TouchDown boolean A boolean flag that will only be set to true during the time tick in which the TouchState changes from released to pressed. READ ONLY.
---@field TouchUp boolean A boolean flag that will only be set to true during the time tick in which the TouchState changes from pressed to released. READ ONLY.
---@field TouchPosition vec2 The position of the touch interaction on the screen area. READ ONLY.
---@field Type "VideoChip"
---@field RenderOnScreen fun(self:VideoChip) This method sets the VideoChip to use screens as render targets.
---@field RenderOnBuffer fun(self:VideoChip, index:number) This method sets the VideoChip to use one of its RenderBuffers as a render target. The `index` parameter identifies the RenderBuffer to use.
---@field SetRenderBufferSize fun(self:VideoChip, index:number, width:number, height:number) Resize one of the VideoChip's RenderBuffers.
---@field Clear fun(self:VideoChip, color:color) Clears all the render area with the specified `color`.
---@field SetPixel fun(self:VideoChip, position:vec2, color:color) Sets the pixel at the specified `position` to the specified `color`.
---@field DrawPointGrid fun(self:VideoChip, gridOffset:vec2, dotsDistance:number, color:color) Draws a dotted grid on the entire display area, with an offset. The `dotsDistance` parameter express the distance in pixels, on both axis, between dots.
---@field DrawLine fun(self:VideoChip, start:vec2, end:vec2, color:color) Draws a line from position `start` to position `end`, using the specified color.
---@field DrawCircle fun(self:VideoChip, position:vec2, radius:number, color:color) Draws an empty circle at the specified `position`, with the specified `radius`, in the specified `color`.
---@field FillCircle fun(self:VideoChip, position:vec2, radius:number, color:color) Draws a filled circle at the specified `position`, with the specified `radius`, in the specified `color`.
---@field DrawRect fun(self:VideoChip, position1:vec2, position2:vec2, color:color) Draws an empty rect from `position1` to `position2`, in the specified `color`.
---@field FillRect fun(self:VideoChip, position1:vec2, position2:vec2, color:color) Draws a filled rect from `position1` to `position2`, in the specified `color`.
---@field DrawTriangle fun(self:VideoChip, position1:vec2, position2:vec2, position3:vec2, color:color) Draws an empty triangle with vertexes in `position1`, `position2` and `position3`, in the specified `color`.
---@field FillTriangle fun(self:VideoChip, position1:vec2, position2:vec2, position3:vec2, color:color) Draws a filled triangle with vertexes in `position1`, `position2` and `position3`, in the specified `color`.
---@field DrawSprite fun(self:VideoChip, position:vec2, spriteSheet:SpriteSheet, spriteX:number, spriteY:number, tintColor:color, backgroundColor:color) Draws a specific sprite frame from the `spriteSheet`.<br/>Position is the on-screen sprite desired `position` starting from the top left corner,<br/>`spriteSheet` is the SpriteSheet asset containing the sprite frame to draw,<br/>`spriteX` and `spriteY` are the coordinates to identify the desired sprite frame starting from the, top left corner, expressed in grid units.<br/>`spriteX`=0 and `spriteY`=0 are the coordinates of the first sprite, top left.<br/>`tintColor` is the color multiplier used to draw the sprite frame. `Color(255,255,255)` or `color.white` will leave the sprite frame unaffected.<br/>`backgroundColor` is the color used to replace the transparent areas of the spriteFrame. Using `ColorRGBA(0,0,0,0)` or `color.clear` will leave the transparency as it is.
---@field DrawCustomSprite fun(self:VideoChip, position:vec2, spriteSheet:SpriteSheet, spriteOffset:vec2, spriteSize:vec2, tintColor:color, backgroundColor:color) Draw a portion of a SpriteSheet (defined by `spriteOffset`, `spriteSize`) without taking into account the grid.
---@field DrawText fun(self:VideoChip, position:vec2, fontSprite:SpriteSheet, text:string, textColor:color, backgroundColor:color) Draws the string contained in the `text` parameter, at the desired `position`, using `textColor` and `backgroundColor`.
---@field RasterSprite fun(self:VideoChip, position1:vec2, position2:vec2, position3:vec2, position4:vec2, spriteSheet:SpriteSheet, spriteX:number, spriteY:number, tintColor:color, backgroundColor:color) Draws a specific sprite frame from the `spriteSheet` mapping it on a quad identified by `position1`, `position2`, `position3`, `position4`.
---@field RasterCustomSprite fun(self:VideoChip, position1:vec2, position2:vec2, position3:vec2, position4:vec2, spriteSheet:SpriteSheet, spriteOffset:vec2, spriteSize:vec2, tintColor:color, backgroundColor:color) Draws a portion of a SpriteSheet (defined by `spriteOffset`, `spriteSize`) without taking into account the grid mapping it on a quad identified by `position1`, `position2`, `position3`, `position4`.
---@field DrawRenderBuffer fun(self:VideoChip, position:vec2, renderBuffer:RenderBuffer, width:number, height:number) Draws a render buffer (supposedly coming from Webcam component) at the desired `position`, `width` and `height`.
---@field SetPixelData fun(self:VideoChip, pixelData:PixelData) Apply `pixelData` content to VideoChip's video buffer, width and height must have the same value as VideoChip's.
---@field BlitPixelData fun(self:VideoChip, position:vec2, pixelData:PixelData) Draw a `pixelData` content to VideoChip's video buffer at the offset of `position`. This way PixelData width and height don't need to match the VideoChip's.

VideoChipMode = {
    ---@type VideoChipMode
    SingleBuffer = nil,
    ---@type VideoChipMode
    DoubleBuffer = nil,
}

---Sent when the touch interaction is pressed or released.
---@class VideoChipTouchEvent
---@field TouchDown boolean A boolean flag that will only be set to true during the time tick in which the TouchState changes from released to pressed.
---@field TouchUp boolean A boolean flag that will only be set to true during the time tick in which the TouchState changes from pressed to released.
---@field Value vec2 The position of the touch interaction on the screen area.
---@field Type "VideoChipTouchEvent" is "VideoChipTouchEvent"

