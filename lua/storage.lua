local vars = require "vars"
local storage = {}

function storage:Init()
    if vars.alwaysResetFlashMemory then
        self:Reset("alwaysResetFlashMemory is true")
    end
    self:validate()
    local saveData = gdt.FlashMemory0:Load()
    vars.usingCustomEndpoint = saveData.usingCustomEndpoint
    vars.customEndpoint = saveData.customEndpoint
    vars.endPoint = saveData.endPoint
    vars.completedSetup = saveData.completedSetup
    vars.lastPage = saveData.lastPage
    vars.marked = saveData.marked
    vars.statisticsEnabled = saveData.enableStatistics
    vars.didCompleteImageTutorial = saveData.completedImageSetup
end

---Returns save data
---@return {usingCustomEndpoint: boolean, customEndpoint: string, endPoint: string, completedSetup: boolean, completedImageSetup:boolean, lastPage: string, marked: table, enableStatistics: boolean}
function storage:GetStorage()
    self:validate()
    return gdt.FlashMemory0:Load()
end

function storage:Reset(reason)
    -- Reset save data
    print("Resetting save data...")
    print("Reason: " .. reason)
    return gdt.FlashMemory0:Save({
        usingCustomEndpoint = false,
        customEndpoint = vars.customEndpoint,
        endPoint = vars.endPoint,
        completedSetup = false,
        lastPage = "",
        marked = {},
        enableStatistics = true,
        completedImageSetup = false
    })
end

function storage:Save()
    print("Saving...")
    local didSave = gdt.FlashMemory0:Save({
        usingCustomEndpoint = vars.usingCustomEndpoint,
        customEndpoint = vars.customEndpoint,
        endPoint = vars.endPoint,
        completedSetup = vars.completedSetup,
        lastPage = vars.lastPage,
        marked = vars.marked,
        enableStatistics = vars.statisticsEnabled,
        completedImageSetup = vars.didCompleteImageTutorial
    })
    print("Saved: " .. tostring(didSave))
    return didSave
end

function storage:validate()
    local saveData = gdt.FlashMemory0:Load()
    -- Validate that the save data is valid
    if type(saveData) ~= "table" then
        self:Reset("saveData is not a table")
    end

    if type(saveData.marked) ~= "table" then
        self:Reset("marked is not a table")
    end

    if type(saveData.usingCustomEndpoint) ~= "boolean" then
        self:Reset("usingCustomEndpoint is not a boolean")
    end

    if type(saveData.customEndpoint) ~= "string" then
        self:Reset("customEndpoint is not a string")
    end

    if type(saveData.endPoint) ~= "string" then
        self:Reset("endPoint is not a string")
    end

    if type(saveData.completedSetup) ~= "boolean" then
        self:Reset("completedSetup is not a boolean")
    end

    if type(saveData.lastPage) ~= "string" then
        self:Reset("lastPage is not a string")
    end

    if type(saveData.enableStatistics) ~= "boolean" then
        self:Reset("enableStatistics is not a boolean")
    end

    if type(saveData.completedImageSetup) ~= "boolean" then
        self:Reset("completedImageSetup is not a boolean")
    end
end

return storage;
