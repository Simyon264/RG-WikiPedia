---@meta _

---Webcam
---@class Webcam:Module
---@field RenderTarget VideoChip The `VideoChip` this camera is streaming contents to.
---@field AccessDenied boolean Will return `true` if Camera access is denied. See `Permissions` for more information. READ ONLY.
---@field IsActive boolean Returns `true` if the Webcam is currently being used. READ ONLY.
---@field IsAvailable boolean Returns `true` if the Webcam is available for being used. READ ONLY.
---@field GetRenderBuffer fun(self:Webcam):RenderBuffer Gets the camera `RenderBuffer`. The render buffer obtained can then be fed to the `DrawRenderBuffer` method of the `VideoChip` module.
---@field Type "Webcam"

---Triggered when the Webcam's active state changes.
---@class WebcamIsActiveEvent
---@field IsActive boolean is `true` if the Webcam is being used.
---@field IsAvailable boolean is `true` if the Webcam is available for use.
---@field AccessDenied boolean is `true` if permissions are disabled for Webcams.
---@field Type "WebcamIsActiveEvent" is "WebcamIsActiveEvent".
