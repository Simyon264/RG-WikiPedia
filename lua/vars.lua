local vars = {}

---@type "noAccess" | "connecting" | "pageView" | "imageViewer" | "marked" | "settings" | "search"
vars.state = "connecting"

--#region Connection
vars.usingCustomEndpoint = false
vars.customEndpoint = "http://45.93.249.136:42069"
vars.endPoint = "http://45.93.249.136:42069"
vars.connectionAttempts = 0
vars.isConnected = false
vars.isAttemptingConnection = false
vars.ping = 0
vars.userCount = 0
vars.userCountLastUpdate = 0
-- Update user count every 5 seconds
vars.userCountUpdateInterval = 60 * 5
--#endregion

--#region Statistics tracking
-- Statistics tracking only consists of the following:
-- - Online status
-- So it's not really a privacy concern
-- But if you still don't want to be tracked, you can disable it
vars.statisticsEnabled = true
vars.uuid = ""
vars.lastHeartbeat = 0
-- Update heartbeat every 18 seconds
vars.heartbeatInterval = 60 * 18
--#endregion

--#region Debug
vars.alwaysResetFlashMemory = false
--#endregion

--#region Setup
vars.completedSetup = false
vars.didCompleteImageTutorial = false
--#endregion

--#region Page view
vars.currentPage = "Main_Page"
vars.scroll = 0
vars.pageFetched = false
vars.isPageFetching = false
vars.fetchCount = 0
vars.frontPage = {}
vars.page = {
    page = {},
    images = {},
    mainImage = "",
    summary = "",
    content = {}
}

vars.imageUrl = ""
vars.isGallery = false
vars.galleryIndex = 1

--- @type table<table<{scroll: number, page: table, currentPage: string, state: string, shouldClear: boolean}>>
vars.stack = {}

--#endregion

vars.clearScreen = true

vars.marked = {}
vars.lastPage = ""

vars.searchQuery = ""
vars.searchResults = {}

vars.isError = false
vars.errorMessage = ""
vars.canRetry = false

vars.sourceCodeUrl = ""
vars.version = "v1.0.0"

vars.standartFont = gdt.ROM.System.SpriteSheets["StandardFont"]

function vars:switchPage(name)
    table.insert(vars.stack, {
        scroll = vars.scroll,
        page = vars.page,
        currentPage = vars.currentPage,
        state = vars.state,
        shouldClear = vars.clearScreen
    })

    vars.pageFetched = false
    vars.isPageFetching = true
    vars.page = {
        page = {},
        images = {},
        mainImage = "",
        summary = "",
        content = {}
    }
    vars.currentPage = name
    vars.state = "pageView"
    vars.scroll = 0
    vars.imageUrl = ""
    vars.clearScreen = true
    gdt.Wifi0:WebGet(getURLPath() .. "/page" .. tableToQuery({
        query = name
    }))
end

function vars:dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. vars.dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

return vars;
