---@meta _

---@class Asset
---@field Name string The name of the asset. READ ONLY.
---@field Type string READ ONLY.
---@field IsValid fun(self:Asset):boolean Returns true if the asset reference is still valid. References can become invalid if the asset is unloaded.
