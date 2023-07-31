---@meta _

---@class _RealityChipTime:table
---@field year number
---@field month number
---@field day number
---@field yday number year day
---@field wday number week day
---@field hour number
---@field min number
---@field sec number
---@field isdst boolean is daylight saving time

---@class RealityChipCpu
---@field TotalUsage number The total CPU usage of the system, from 0 to 100. READ ONLY.
---@field CoresUsage number[] An array that contains the CPU usage of each logical CPU core, from 0 to 100. READ ONLY.

---@class RealityChipRam
---@field Available number Available RAM expressed in MB. READ ONLY.
---@field Used number Used RAM expressed in MB. READ ONLY.

---@class RealityChipNetwork
---@field TotalSent number Total sent by network interfaces expressed in Mbps. READ ONLY.
---@field TotalReceived number Total received from network interfaces expressed in Mbps. READ ONLY.

---The RealityChip lets you read some values about real-world usage of your computer from inside Retro Gadgets. All path are related to `Documents/My Games/Retro/UserData` folder.
---@class RealityChip:Module
---@field Cpu RealityChipCpu
---@field Ram RealityChipRam
---@field Network RealityChipNetwork
---@field LoadedAssets Asset[] Array containing all the assets currently loaded from the `Documents/My Games/Retro/UserData` folder. READ ONLY.
---@field Type "RealityChip"
---@field GetDateTime fun(self:RealityChip):_RealityChipTime Returns a table containing the current local date and time.
---@field GetDateTimeUTC fun(self:RealityChip):_RealityChipTime Returns a table containing the current local date and time expressed as the Coordinated Universal Time (UTC).
---@field LoadAudioSample fun(self:RealityChip, filename:string):AudioSample Load an AudioSample asset from an audio file.
---@field LoadSpriteSheet fun(self:RealityChip, filename:string, spritesWidth:number, spritesHeight:number):SpriteSheet Load a SpriteSheet asset from an image file.
---@field UnloadAsset fun(self:RealityChip, filename:string) Unload a previously loaded asset. Remove it from `LoadedAssets` and make it invalid.
---@field ListDirectory fun(self:RealityChip, directory:string):string[] Returns the list of files and folders contained in the specified folder.
---@field GetFileMetadata fun(self:RealityChip, filename:string):table Returns a table containing information about the file without the need to load it.

