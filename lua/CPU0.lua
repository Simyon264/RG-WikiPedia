local vars        = require("vars")
local storage     = require("storage")
local textlib     = require("textlib")
local json        = require("json")
local vChip       = gdt.VideoChip0
local imageViewer = require("image_viewer")

storage:Init()

function handleHeartbeat()
    if vars.statisticsEnabled then
        if vars.lastHeartbeat > vars.heartbeatInterval then
            vars.lastHeartbeat = 0
            gdt.Wifi0:WebGet(getURLPath() .. "/statistics/heartbeat" .. tableToQuery({
                id = vars.uuid,
                timestamp = getTimestamp()
            }))
        else
            vars.lastHeartbeat = vars.lastHeartbeat + 1
        end
    end
end

local upHeldFor = 0
local downHeldFor = 0

function handleScroll()
    gdt.LedButton2.LedState = gdt.LedButton2.ButtonState
    if gdt.LedButton2.ButtonState then
        upHeldFor = upHeldFor + 1
        if upHeldFor > 600 then
            gdt.LedButton2.LedColor = color.blue
            vars.scroll = vars.scroll - 0.08
        elseif upHeldFor > 80 then
            gdt.LedButton2.LedColor = color.cyan
            vars.scroll = vars.scroll - 0.02
        else
            gdt.LedButton2.LedColor = color.yellow
            vars.scroll = vars.scroll - 0.01
        end
    else
        upHeldFor = 0
    end

    gdt.LedButton3.LedState = gdt.LedButton3.ButtonState
    if gdt.LedButton3.ButtonState and textlib.hasDrawnText == true then
        downHeldFor = downHeldFor + 1
        if downHeldFor > 600 then
            gdt.LedButton3.LedColor = color.blue
            vars.scroll = vars.scroll + 0.08
        elseif downHeldFor > 80 then
            vars.scroll = vars.scroll + 0.02
            gdt.LedButton3.LedColor = color.cyan
        else
            gdt.LedButton3.LedColor = color.yellow
            vars.scroll = vars.scroll + 0.01
        end
    else
        if textlib.hasDrawnText == false then
            gdt.LedButton3.LedColor = color.red
        end
        downHeldFor = 0
    end

    if gdt.LedButton2.ButtonState and gdt.LedButton3.ButtonState then
        vars.scroll = 0
    end

    if vars.scroll < 0 then
        vars.scroll = 0
    end
end

function handleMarked()
    if vars.state == "pageView" then
        -- Check if the page is marked
        if vars.marked[vars.currentPage] ~= nil then
            gdt.LedButton0.LedState = true
            if gdt.LedButton0.ButtonDown then
                vars.marked[vars.currentPage] = nil
                storage:Save()
            end
        else
            gdt.LedButton0.LedState = false
            if gdt.LedButton0.ButtonDown then
                vars.marked[vars.currentPage] = true
                storage:Save()
            end
        end
    end
end

function update()
    handleScroll()
    handleMarked()

    if vars.clearScreen then
        vChip:Clear(color.black)
    end

    if gdt.Wifi0.AccessDenied then
        vChip:DrawText(vec2(30, 30), vars.standartFont, "Access denied", color.red, color.black)
        return
    end

    if vars.isError then
        vChip:Clear(color.black)
        vChip:DrawText(vec2(5, 2), vars.standartFont, "Something went wrong!", color.red, color.black)
        textlib:drawText(vec2(10, 12),
            vars.errorMessage,
            color.white, color.black, vec2(100, 120), vec2(5, 7), 8, vars.scroll, true)
        return
    end

    if not vars.completedSetup then
        vChip:Clear(color.black)
        vChip:DrawText(vec2(30, 2), vars.standartFont, "Hold on!", color.green, color.black)
        textlib:drawText(vec2(10, 12),
            "You need to confirm some things before you can start using MiniWiki. You only need to do this once.\nMiniWiki does [#ff0000]not support all features from WikiPedia [#ffffff]. For example you cannot view Tables. These features will be added in the future. You can mark articles by pressing the upper side button. To scroll use the arrow buttons at the bottom of the gadget. \n \n By using MiniWiki you agree that a random UUID will be generated and sent to the server. \nThis UUID is used to track the amount of users using MiniWiki.\nYou can disable this in the settings. \n Neither the Gadget nor the Backend store any Information permanently. You can verify this by looking at the source code, the link for which you can find in the settings menu. \n \n [#00ff00]Happy reading! [#ffffff] Tap the screen to continue...",
            color.white, color.black, vec2(100, 120), vec2(5, 7), 8, vars.scroll, true)
        if vChip.TouchDown then
            vars.completedSetup = true
            storage:Save()
        end
        return
    end

    -- Update the user count
    if vars.statisticsEnabled then
        if vars.userCountLastUpdate > vars.userCountUpdateInterval then
            vars.userCountLastUpdate = 0
            gdt.Wifi0:WebGet(getURLPath() .. "/statistics/count")
        else
            vars.userCountLastUpdate = vars.userCountLastUpdate + 1
        end
    end

    if vars.state == "connecting" then
        vChip:DrawText(vec2(30, 2), vars.standartFont, "Connecting...", color.green, color.black)
        if not vars.isAttemptingConnection then
            vars.isAttemptingConnection = true
            gdt.Wifi0:WebGet(getURLPath() .. "/statistics/connection" .. tableToQuery({
                timestamp = getTimestamp()
            }))
        end
        return
    end
    vChip:FillRect(vec2(84, 0), vec2(84, 10), color.cyan)
    vChip:DrawText(vec2(85, 2), vars.standartFont, vars.userCount .. " Users", color.cyan, color.black)
    vChip:DrawLine(vec2(0, 10), vec2(128, 10), color.cyan)
    vChip:DrawText(vec2(2, 2), vars.standartFont, "MiniWiki", color.cyan, color.black)
    vChip:FillRect(vec2(45, 0), vec2(45, 10), color.cyan)
    vChip:FillRect(vec2(46, 0), vec2(83, 10), Color(89, 153, 255))
    vChip:DrawText(vec2(49, 2), vars.standartFont, "Search", color.cyan, Color(89, 153, 255))
    if vChip.TouchDown then
        if isPointInBoundingBox(vChip.TouchPosition.X, vChip.TouchPosition.Y, 49, 0, 83, 10) then
            vars.clearScreen = true
            vars.state = "search"
            vars.scroll = 0
            imageViewer.image = nil
            return
        elseif isPointInBoundingBox(vChip.TouchPosition.X, vChip.TouchPosition.Y, 0, 0, 45, 10) then
            vars.clearScreen = true
            vars.state = "pageView"
            vars.currentPage = "Main_Page"
            vars.scroll = 0
            vars.stack = {} -- Clear the stack when returning to the main page
            imageViewer.image = nil
            return
        end
    end

    if vars.state == "pageView" then
        if vars.currentPage == "" then
            vars.currentPage = "Main_Page"
        end

        if vars.currentPage == "Main_Page" then
            if not vars.isPageFetching and not vars.pageFetched then
                gdt.Wifi0:WebGet(getURLPath() .. "/page/front" .. tableToQuery({
                    year = gdt.RealityChip:GetDateTime().year,
                    month = gdt.RealityChip:GetDateTime().month,
                    day = gdt.RealityChip:GetDateTime().day
                }))
                vars.isPageFetching = true
            end
            if vars.isPageFetching then
                vChip:DrawText(vec2(14, 12), vars.standartFont, "Fetching front page...", color.green, color.black)
                return
            end

            vChip:DrawText(vec2(2, 12), vars.standartFont, "What do you want to see?", color.cyan, color.black)
            vChip:DrawText(vec2(2, 32), vars.standartFont, "Today's featured article", color.cyan, color.black)
            vChip:DrawText(vec2(2, 42), vars.standartFont, "On this day", color.cyan, color.black)
            vChip:DrawText(vec2(2, 52), vars.standartFont, "News", color.cyan, color.black)
            vChip:DrawText(vec2(2, 62), vars.standartFont, "Today's featured image", color.cyan, color.black)
            vChip:DrawText(vec2(2, 72), vars.standartFont, "Random article", color.cyan, color.black)
            vChip:DrawText(vec2(2, 82), vars.standartFont, "Marked pages", color.cyan, color.black)
            vChip:DrawText(vec2(2, 92), vars.standartFont, "Settings", color.cyan, color.black)

            local time = gdt.RealityChip:GetDateTime()
            vChip:DrawText(vec2(80, 92), vars.standartFont, time.day .. "/" .. time.month .. "/" .. time.year, color
                .cyan,
                color.black)

            if vChip.TouchDown then
                if isPointInBoundingBox(vChip.TouchPosition.X, vChip.TouchPosition.Y, 2, 32, 128, 42) then
                    vars.currentPage = "Featured_article"
                    vars.pageFetched = false
                    vars:switchPage(vars.frontPage.tfa.title)
                    vars.scroll = 0
                    return
                elseif isPointInBoundingBox(vChip.TouchPosition.X, vChip.TouchPosition.Y, 2, 42, 128, 52) then
                    vars.currentPage = "On_this_day"
                    vars.scroll = 0
                    return
                elseif isPointInBoundingBox(vChip.TouchPosition.X, vChip.TouchPosition.Y, 2, 52, 128, 62) then
                    vars.currentPage = "News"
                    vars.scroll = 0
                    return
                elseif isPointInBoundingBox(vChip.TouchPosition.X, vChip.TouchPosition.Y, 2, 62, 128, 72) then
                    table.insert(vars.stack, {
                        scroll = vars.scroll,
                        page = vars.page,
                        currentPage = vars.currentPage,
                        state = vars.state,
                        shouldClear = vars.clearScreen
                    })
                    vars.currentPage = "Featured_image"
                    vars.state = "imageViewer"
                    vars.imageUrl = vars.frontPage.image.image.source
                    gdt.Wifi0:WebGet(getURLPath() .. "/image" .. tableToQuery({
                        url = vars.frontPage.image.image.source,
                        stream = false
                    }))
                    vars.scroll = 0
                    return
                elseif isPointInBoundingBox(vChip.TouchPosition.X, vChip.TouchPosition.Y, 2, 72, 128, 82) then
                    vars.currentPage = "internal:wait"
                    -- Internal wait just means to display a loading screen
                    vars.state = "pageView"
                    vars.isPageFetching = true
                    gdt.Wifi0:WebGet(getURLPath() .. "/page/random")
                    vars.scroll = 0
                    return
                elseif isPointInBoundingBox(vChip.TouchPosition.X, vChip.TouchPosition.Y, 2, 82, 128, 92) then
                    vars.state = "marked"
                    vars.scroll = 0
                    return
                elseif isPointInBoundingBox(vChip.TouchPosition.X, vChip.TouchPosition.Y, 2, 92, 128, 102) then
                    vars.state = "settings"
                    vars.scroll = 0
                    return
                end
            end
        elseif vars.currentPage == "News" then
            vChip:DrawText(vec2(2, 12), vars.standartFont, "News", color.cyan, color.black)
            local text = ""
            for i = 1, #vars.frontPage.news do
                local entry = vars.frontPage.news[i]
                text = text .. textlib:handleHTML(entry.story)

                if entry.links[1] ~= nil and entry.links[1].originalimage ~= nil then
                    text = text .. "\n[#00e1ff][image:" .. entry.links[1].originalimage.source .. "] Image?"
                end

                text = text .. "\n \n"
            end
            textlib:drawText(vec2(2, 22), text, color.white, color.black, vec2(100, 120), vec2(5, 7), 8, vars.scroll,
                true)
        elseif vars.currentPage == "On_this_day" then
            vChip:DrawText(vec2(2, 12), vars.standartFont, "On this day", color.cyan, color.black)
            local text = ""
            for i = 1, #vars.frontPage.onthisday do
                local entry = vars.frontPage.onthisday[i]
                -- If the entry has a page associated with it, display the pages title
                if entry.pages[1] ~= nil then
                    text = text ..
                        "[#7a34eb]" .. entry.year .. ":\n[#ffffff]" .. entry.pages[1].titles.normalized .. "\n" ..
                        entry.text

                    -- If the entry has a image associated with it, add a redirect to the image
                    if entry.pages[1].originalimage ~= nil then
                        text = text .. "\n[#00e1ff][image:" .. entry.pages[1].originalimage.source .. "] Image?"
                    end

                    text = text .. "\n \n"
                else
                    text = text .. entry.year .. ":\n" .. entry.text .. "\n \n"
                end
            end
            textlib:drawText(vec2(2, 22), text, color.white, color.black, vec2(100, 120), vec2(5, 7), 8, vars.scroll,
                false)
        else
            if vars.isPageFetching then
                vChip:DrawText(vec2(14, 12), vars.standartFont, "Fetching page...", color.green, color.black)
                vars.fetchCount = vars.fetchCount + 1
                if vars.fetchCount > 200 then
                    vars.scroll = 0
                    textlib:drawText(vec2(2, 22), "Taking too long? Why not [wikilink:{Go_back!}internal:goback]",
                        color.white,
                        color.black, vec2(100, 120), vec2(5, 7), 8, vars.scroll, false)
                    return
                end
                return
            end

            if vars.page.page == nil or vars.page.page.title == nil then
                return
            end
            vars.fetchCount = 0

            vChip:DrawText(vec2(2, 12), vars.standartFont, vars.page.page.title, color.cyan, color.black)
            -- Draw a fancy underline by drawing a line under the text
            vChip:DrawLine(vec2(2, 20), vec2(2 + vars.page.page.title:len() * 5, 20), color.cyan)

            local text = ""
            if vars.page.mainImage ~= "" then
                text = text .. "Display main [#00e1ff][image:" .. vars.page.mainImage .. "] image?\n"
            end

            text = text .. "[wikilink:{View_all_images?}internal:imageGallery]" .. "\n \n"

            vChip:DrawText(vec2(2, 22), vars.standartFont, "Go back", color.white, color.black)

            if vChip.TouchDown then
                local x = vChip.TouchPosition.X
                local y = vChip.TouchPosition.Y

                -- Check if the user touched the "Go back" button
                if isPointInBoundingBox(x, y, 2, 22, 2 + ("Go back"):len() * 5, 32) then
                    local previousState = vars.stack[#vars.stack]
                    vars.scroll = previousState.scroll
                    vars.page = previousState.page
                    vars.currentPage = previousState.currentPage
                    vars.state = previousState.state
                    vars.clearScreen = previousState.shouldClear
                    table.remove(vars.stack, #vars.stack)
                    return
                end
            end

            -- Content returned by the API contains the title of the page, content and if there is even more child content
            -- It contains an array called items which then also contains the title, content and if there is even more child content
            -- This is why we need to loop through the items array and check if there is even more child content
            -- To display this we need to generate the text recursively

            local function generateContent(item)
                local text = ""

                if item.title then
                    text = text .. "[#b342f5]" .. textlib:handleHTML(item.title) .. " [#ffffff]\n"
                end

                if item.content then
                    text = text .. textlib:handleHTML(item.content) .. "\n"
                end

                if item.items and #item.items > 0 then
                    text = text .. "\n"
                    for _, subitem in ipairs(item.items) do
                        text = text .. generateContent(subitem)
                    end
                end

                return text
            end

            for _, item in ipairs(vars.page.content) do
                text = text .. generateContent(item) .. "\n \n"
            end

            textlib:drawText(vec2(2, 32), text, color.white, color.black, vec2(100, 120), vec2(5, 7), 8, vars.scroll)
        end
    elseif vars.state == "imageViewer" then
        imageViewer.render()
    elseif vars.state == "search" then
        -- Draw the search bar
        -- First a box around the area where the search bar is
        vChip:DrawRect(vec2(2, 12), vec2(126, 22), color.cyan)
        -- Then the text
        -- if the search query is empty, display a placeholder
        local text = vars.searchQuery == "" and "Search..." or vars.searchQuery
        vChip:DrawText(vec2(4, 14), vars.standartFont, text, color.cyan, color.black)

        text = ""
        for index, value in ipairs(vars.searchResults) do
            text = text .. "[wikilink:{" .. value:gsub(" ", "_") .. "}" .. value:gsub(" ", "_") .. "] \n"
        end

        if #vars.searchResults == 0 then
            text = "No results found :("
        end

        textlib:drawText(vec2(2, 32), text, color.white, color.black, vec2(100, 120), vec2(5, 7), 8, vars.scroll)
    elseif vars.state == "marked" then
        gdt.VideoChip0:DrawText(vec2(2, 12), vars.standartFont, "Marked pages", color.cyan, color.black)
        local text = ""
        for key, value in pairs(vars.marked) do
            text = text .. "[wikilink:{" .. key:gsub(" ", "_") .. "}" .. key:gsub(" ", "_") .. "] \n"
        end

        -- If there are no marked pages, display a message
        if text == "" then
            text =
            "You have no marked pages. Use the left side button to mark a page. \n \n[wikilink:{Go_back?}internal:goback] "
        else
            text = text .. "\n \n[wikilink:{Go_back?}internal:goback] "
        end

        textlib:drawText(vec2(2, 22), text, color.white, color.black, vec2(100, 120), vec2(5, 7), 8, vars.scroll,
            false)
    elseif vars.state == "settings" then
        local text = ""
        if vars.statisticsEnabled then
            text = text .. "[#00ff00]Statistics are enabled\n"
            text = text .. "[#ffffff]Disable statistics [1]? \n \n"
        else
            text = text .. "[#ff0000]Statistics are disabled\n"
            text = text .. "[#ffffff]Enable statistics [1]? \n \n"
        end

        if vars.usingCustomEndpoint then
            text = text .. "[#00ff00]Using custom endpoint\n"
        else
            text = text .. "[#ff0000]Using default endpoint\n"
        end

        if vars.sourceCodeUrl == "" then
            text = text .. "[#ffffff]View source code [2]? \n \n"
        else
            text = text .. "[#00ffff]" .. vars.sourceCodeUrl .. "\n \n"
        end

        text = text .. "MiniWiki " .. vars.version .. "\n " .. "JSON: " .. json._version .. "\n " .. "Lua: " ..
            _VERSION .. "\n " .. "\n \n"

        text = text .. "[wikilink:{Go_back?}internal:goback] "

        textlib:drawText(vec2(2, 12), text, color.white, color.black, vec2(100, 120), vec2(5, 7), 8, vars.scroll,
            true)
    else
        vChip:DrawText(vec2(2, 12), vars.standartFont, "Unknown state: " .. vars.state, color.red, color.black)
    end

    handleHeartbeat()
end

function isPointInBoundingBox(x, y, xMin, yMin, xMax, yMax)
    return x >= xMin and x <= xMax and y >= yMin and y <= yMax
end

function getTimestamp()
    local date = gdt.RealityChip:GetDateTimeUTC()
    return string.format("%04d-%02d-%02dT%02d:%02d:%02d.%03dZ", date.year, date.month, date.day, date.hour, date.min,
        date.sec, 0)
end

function tableToQuery(table)
    local query = ""
    local isFirst = true

    for key, value in pairs(table) do
        if isFirst then
            query = query .. "?" -- Add the question mark for the first parameter
            isFirst = false
        else
            query = query .. "&" -- Add an ampersand for subsequent parameters
        end

        -- URL-encode the key and value before appending to the query string
        local encodedKey = encodeURIComponent(tostring(key))
        local encodedValue = encodeURIComponent(tostring(value))

        query = query .. encodedKey .. "=" .. encodedValue
    end

    return query
end

-- URL-encode function to handle special characters in the query string
function encodeURIComponent(str)
    str = string.gsub(str, "([^0-9a-zA-Z !'()*._~-])", -- locale independent
        function(c) return string.format("%%%02X", string.byte(c)) end)
    str = string.gsub(str, " ", "+")
    return str
end

---returns the current API endpoint
---@return string
function getURLPath()
    if vars.usingCustomEndpoint then
        return vars.customEndpoint
    else
        return vars.endPoint
    end
end

---@param sender Wifi
---@param event WifiWebResponseEvent
function eventChannel1(sender, event)
    if event.IsError then
        print("Error")
        if vars.connectionAttempts < 3 and not vars.isConnected then
            vars.connectionAttempts = vars.connectionAttempts + 1
            vars.isAttemptingConnection = false
            return
        else
            if vars.state ~= "connecting" then
                vars.canRetry = true
            end

            local ok, res = pcall(function()
                return json.decode(event.Text)
            end)

            if ok and res.error:find("Invalid id") then
                print("Connection has been lost (Client timed out)")
                print("Attempting to reconnect...")
                gdt.Wifi0:WebGet(getURLPath() .. "/statistics/connection" .. tableToQuery({
                    timestamp = getTimestamp()
                }))
                vars.isError = false
                return
            end

            if ok and (res.error:find("gm") or res.error:find("ENOENT")) then
                if vars.isGallery then
                    print("Image in Gallery mode failed to load. Displaying emtpy.")
                    vars.isError = false
                    imageViewer.handleData("P3\n0 0\n255\n")
                    return
                end
                vars.errorMessage = "It seems like we cannot display this image. Please try again later."
                vars.errorMessage = vars.errorMessage .. "\n \n[wikilink:{Go_back?}internal:goback] "
                vars.isError = true
                return
            end

            vars.scroll = 0
            vars.isError = true
            vars.errorMessage = "Cannot connect" ..
                (vars.connectionAttempts > 0 and " to server" or "") ..
                "!" ..
                "\nStatus code: " ..
                event.ResponseCode .. "\nError message: " .. event.ErrorMessage .. "\n URL path: " .. getURLPath()

            if vars.canRetry then
                --vars.errorMessage = vars.errorMessage .. "\n \n[wikilink:{Retry?}./retry] "
                vars.errorMessage = vars.errorMessage .. "\n \n[wikilink:{Go_back?}internal:goback] "
            else
                vars.errorMessage = vars.errorMessage .. "\n \nPlease restart the gadget..."
            end

            if ok then
                vars.errorMessage = vars.errorMessage .. "\nResponse: " .. res.error
            end
            return
        end
        vars.isError = true
        vars.errorMessage = "Error: " .. event.ErrorMessage
        return
    end

    if event.ContentType:match("ppm") then
        imageViewer.handleData(event.Text)
        return
    end

    local data = json.decode(event.Text)
    local type = data.type
    if type == nil then
        vars.isError = true
        vars.errorMessage = "Error: type is nil"
        vars.canRetry = true
        return
    end

    if type == "connection" then
        vars.isConnected = true
        vars.isAttemptingConnection = false
        vars.state = "pageView"
        vars.uuid = data.uuid

        -- Conection successful, reset connection attempts and fetch the front page
        vars.connectionAttempts = 0
        vars.isPageFetching = false
        print("Connected using UUID " .. vars.uuid .. ". Using API endpoint " .. getURLPath())
        --gdt.Wifi0:WebGet(getURLPath() .. "/page/front")
        return
    elseif type == "heartbeat" then
        --print("Heartbeat received")
        vars.ping = data.ping
        return
    elseif type == "count" then
        vars.userCount = data.count
        return
    elseif type == "front" then
        vars.isPageFetching = false
        vars.pageFetched = true
        vars.frontPage = data.page
        return
    elseif type == "random" then
        vars:switchPage(data.page.title)
        return
    elseif type == "page" then
        print("Page fetched")
        vars.isPageFetching = false
        vars.pageFetched = true
        vars.page.page = data.page
        vars.page.images = data.images
        vars.page.mainImage = data.mainImage
        vars.page.summary = data.summary
        vars.page.content = data.content
        return
    elseif type == "search" then
        vars.searchResults = data.results.results
        return
    elseif type == "source" then
        vars.sourceCodeUrl = data.source
        return
    elseif type == "image" then
        imageViewer.handleData(data.image)
        return
    end

    vars.isError = true
    vars.errorMessage = "Error: unknown type " .. type
    print("Unknown type " .. type)
    print("Data: " .. event.Text)
end

---@param sender KeyboardChip
---@param event KeyboardChipEvent
function eventChannel2(sender, event)
    if vars.state == "settings" and event.ButtonDown then
        if event.InputName == "Alpha1" then
            vars.statisticsEnabled = not vars.statisticsEnabled
            storage:Save()
        elseif event.InputName == "Alpha2" then
            gdt.Wifi0:WebGet(getURLPath() .. "/source")
        end
    end

    if vars.state == "search" and event.ButtonDown then
        if event.InputName == "Return" then
            gdt.Wifi0:WebGet(getURLPath() .. "/search" .. tableToQuery({
                query = vars.searchQuery
            }))
            return
        elseif event.InputName == "Backspace" then
            vars.searchQuery = vars.searchQuery:sub(1, -2)
        else
            -- Max length of the search query is 20
            if vars.searchQuery:len() >= 22 then
                return
            end

            local test = event.InputName
            local translateList = {
                -- This list contains keys which need to get translated. For example Alpha1 gets converted to 1
                ["Alpha1"] = "1",
                ["Alpha2"] = "2",
                ["Alpha3"] = "3",
                ["Alpha4"] = "4",
                ["Alpha5"] = "5",
                ["Alpha6"] = "6",
                ["Alpha7"] = "7",
                ["Alpha8"] = "8",
                ["Alpha9"] = "9",
                ["Alpha0"] = "0",
                ["Space"] = " "
            }

            if translateList[event.InputName] ~= nil then
                vars.searchQuery = vars.searchQuery .. translateList[event.InputName]
                return
            end

            local allowedCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-"
            if not allowedCharacters:find(event.InputName) then
                return
            end

            vars.searchQuery = vars.searchQuery .. event.InputName
        end
    end
end
