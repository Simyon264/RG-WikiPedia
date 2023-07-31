local vars             = require("vars")
local textlib          = require("textlib")

--- @type {height: number, width: number, colorRange: number, pixelData: table<table<{r: number, g:number, b:number, a:number}>> } | nil
local image
local isDirty          = true
local isWaitingForData = false
local isTextMode       = false

local waitTime         = 0

local x                = 0
local y                = 0

local backGroundColor  = color.black
local textColor        = color.white

--- Contains the zoom information for the respective zoom level
local zoomInformation  = {
    -- At zoom level 1 the image is not zoomed in at all, meaning that the image is displayed at its original size
    [1] = {
        downloadWidth = 128,
        downloadHeight = 72,
        cropHeight = 72,
        cropWidth = 128,
    },
    -- At zoom level 2 the image is zoomed in by 2x, meaning that the image is displayed at 2x its original size
    [2] = {
        cropWidth = 64,
        cropHeight = 36,
        downloadWidth = 256,
        downloadHeight = 144,
    },
    -- At zoom level 3 the image is zoomed in by 4x, meaning that the image is displayed at 4x its original size
    [3] = {
        cropWidth = 32,
        cropHeight = 18,
        downloadWidth = 512,
        downloadHeight = 288,
    },
    -- At zoom level 4 the image is zoomed in by 8x, meaning that the image is displayed at 8x its original size
    [4] = {
        cropWidth = 16,
        cropHeight = 9,
        downloadWidth = 1024,
        downloadHeight = 576,
    },
}
local currentZoomLevel = 1

local downloadWidth    = zoomInformation[currentZoomLevel].downloadWidth
local downloadHeight   = zoomInformation[currentZoomLevel].downloadHeight
local cropX            = zoomInformation[currentZoomLevel].cropWidth
local cropY            = zoomInformation[currentZoomLevel].cropHeight

function render()
    if isWaitingForData then
        gdt.VideoChip0:DrawText(vec2(20, 10), vars.standartFont, "Waiting for data...", color.yellow, color.black)
        waitTime = waitTime + 1
        if waitTime >= 1000 then
            waitTime = 0
            handleData("P3\n0 0\n255\n")
        end
        return
    end
    if image then
        -- If the tutorial is not completed, display the tutorial
        if not vars.didCompleteImageTutorial then
            gdt.VideoChip0:Clear(color.black)
            gdt.VideoChip0:DrawText(vec2(20, 10), vars.standartFont, "Image Viewer", color.cyan, color.black)
            textlib:drawText(vec2(10, 20),
                "This is the [#4ceb34]image viewer. [#ffffff]It allows you to view any image from WikiPedia.\nYou can view more information about the image by scrolling down.\nTo switch the background color, press the lower side button. \n Press the direction buttons on the screen to move the image.\nYou can also zoom in and out by pressing the + and - buttons on the screen.\n\nPress on the screen to continue.",
                color.white, color.black, vec2(100, 120), vec2(5, 7), 8, vars.scroll, true)

            if gdt.VideoChip0.TouchDown then
                vars.didCompleteImageTutorial = true
            end
            return
        end

        if isTextMode then
            gdt.VideoChip0:Clear(color.black)
            -- Display image information
            if vars.currentPage == "Featured_image" then
                textlib:drawText(vec2(5, 20),
                    vars.frontPage.image.description.text ..
                    "\n\nCredit: " ..
                    vars.frontPage.image.credit.text ..
                    "\n\nArtist: " .. vars.frontPage.image.artist.text ..
                    "\n\nLicense: " .. vars.frontPage.image.license.type,
                    color.white, color.black, vec2(100, 120), vec2(5, 7), 8, vars.scroll, true)
            else
                textlib:drawText(vec2(5, 20),
                    "No information available for this image.",
                    color.white, color.black, vec2(100, 120), vec2(5, 7), 8, vars.scroll, true)
            end


            gdt.VideoChip0:DrawText(vec2(0, 10), vars.standartFont, "Back", textColor, ColorRGBA(0, 0, 0, 100))
            if gdt.VideoChip0.TouchDown then
                local touchPos = gdt.VideoChip0.TouchPosition
                if touchPos.X >= 0 and touchPos.X <= 20 and touchPos.Y >= 10 and touchPos.Y <= 18 then
                    isTextMode = false
                    isDirty = true
                end
            end
            return
        end

        if gdt.LedButton1.ButtonDown then
            if backGroundColor == color.black then
                backGroundColor = color.white
                textColor = color.black
                gdt.LedButton1.LedColor = color.white
                gdt.LedButton1.LedState = true
            else
                backGroundColor = color.black
                textColor = color.white
                gdt.LedButton1.LedState = false
            end
            isDirty = true
        end

        -- Display UI
        -- + and - buttons for zooming
        gdt.VideoChip0:DrawText(vec2(0, 10), vars.standartFont, "+", textColor, ColorRGBA(0, 0, 0, 0))
        gdt.VideoChip0:DrawText(vec2(0, 18), vars.standartFont, "-", textColor, ColorRGBA(0, 0, 0, 0))

        -- Draw the arrow buttons
        gdt.VideoChip0:DrawText(vec2(15, 57), vars.standartFont, "Up", textColor, ColorRGBA(0, 0, 0, 0))
        gdt.VideoChip0:DrawText(vec2(10, 73), vars.standartFont, "Down", textColor, ColorRGBA(0, 0, 0, 0))
        gdt.VideoChip0:DrawText(vec2(0, 65), vars.standartFont, "Left", textColor, ColorRGBA(0, 0, 0, 0))
        gdt.VideoChip0:DrawText(vec2(20, 65), vars.standartFont, "Right", textColor, ColorRGBA(0, 0, 0, 0))

        -- Handle changing x and y by pressing on the screen
        if gdt.VideoChip0.TouchDown then
            local touchPos = gdt.VideoChip0.TouchPosition
            if touchPos.X >= 15 and touchPos.X <= 27 and touchPos.Y >= 57 and touchPos.Y <= 65 then
                -- Up
                if y == 0 then
                    return
                end
                y = y - 1
                isWaitingForData = true
                gdt.Wifi0:WebGet(getURLPath() .. "/image/crop" .. tableToQuery({
                    url = vars.imageUrl,
                    stream = false,
                    downloadWidth = downloadWidth,
                    downloadHeight = downloadHeight,
                    x = x,
                    y = y,
                    width = cropX,
                    height = cropY
                }))
                isDirty = true
            elseif touchPos.X >= 10 and touchPos.X <= 30 and touchPos.Y >= 73 and touchPos.Y <= 81 then
                -- Down
                y = y + 1
                isWaitingForData = true
                gdt.Wifi0:WebGet(getURLPath() .. "/image/crop" .. tableToQuery({
                    url = vars.imageUrl,
                    stream = false,
                    downloadWidth = downloadWidth,
                    downloadHeight = downloadHeight,
                    x = x,
                    y = y,
                    width = cropX,
                    height = cropY
                }))
                isDirty = true
            elseif touchPos.X >= 0 and touchPos.X <= 20 and touchPos.Y >= 65 and touchPos.Y <= 73 then
                -- Left
                if x == 0 then
                    return
                end
                x = x - 1
                isWaitingForData = true
                gdt.Wifi0:WebGet(getURLPath() .. "/image/crop" .. tableToQuery({
                    url = vars.imageUrl,
                    stream = false,
                    downloadWidth = downloadWidth,
                    downloadHeight = downloadHeight,
                    x = x,
                    y = y,
                    width = cropX,
                    height = cropY
                }))
                isDirty = true
            elseif touchPos.X >= 20 and touchPos.X <= 40 and touchPos.Y >= 65 and touchPos.Y <= 73 then
                -- Right
                x = x + 1
                isWaitingForData = true
                gdt.Wifi0:WebGet(getURLPath() .. "/image/crop" .. tableToQuery({
                    url = vars.imageUrl,
                    stream = false,
                    downloadWidth = downloadWidth,
                    downloadHeight = downloadHeight,
                    x = x,
                    y = y,
                    width = cropX,
                    height = cropY
                }))
                isDirty = true
            end
        end

        -- Handle zooming
        if gdt.VideoChip0.TouchDown then
            local touchPos = gdt.VideoChip0.TouchPosition
            if touchPos.X >= 0 and touchPos.X <= 8 and touchPos.Y >= 10 and touchPos.Y <= 18 then
                -- Zoom in
                -- Make sure that we cant zoom in too much
                if currentZoomLevel == 4 then
                    return
                end

                currentZoomLevel = currentZoomLevel + 1
                downloadWidth = zoomInformation[currentZoomLevel].downloadWidth
                downloadHeight = zoomInformation[currentZoomLevel].downloadHeight
                cropX = zoomInformation[currentZoomLevel].cropWidth
                cropY = zoomInformation[currentZoomLevel].cropHeight
                isWaitingForData = true
                gdt.Wifi0:WebGet(getURLPath() .. "/image/crop" .. tableToQuery({
                    url = vars.imageUrl,
                    stream = false,
                    downloadWidth = downloadWidth,
                    downloadHeight = downloadHeight,
                    x = x,
                    y = y,
                    width = cropX,
                    height = cropY
                }))
                isDirty = true
            elseif touchPos.X >= 0 and touchPos.X <= 8 and touchPos.Y >= 18 and touchPos.Y <= 26 then
                -- Zoom out
                -- Make sure that we cant zoom out too much
                if currentZoomLevel == 1 then
                    return
                end
                currentZoomLevel = currentZoomLevel - 1
                downloadWidth = zoomInformation[currentZoomLevel].downloadWidth
                downloadHeight = zoomInformation[currentZoomLevel].downloadHeight
                cropX = zoomInformation[currentZoomLevel].cropWidth
                cropY = zoomInformation[currentZoomLevel].cropHeight
                isWaitingForData = true
                if currentZoomLevel == 1 then
                    x = 0
                    y = 0
                end
                gdt.Wifi0:WebGet(getURLPath() .. "/image/crop" .. tableToQuery({
                    url = vars.imageUrl,
                    stream = false,
                    downloadWidth = downloadWidth,
                    downloadHeight = downloadHeight,
                    x = x,
                    y = y,
                    width = cropX,
                    height = cropY
                }))
                isDirty = true
            end
        end

        gdt.VideoChip0:DrawText(vec2(108, 10), vars.standartFont, "Text", textColor,
            ColorRGBA(0, 0, 0, 0))

        gdt.VideoChip0:DrawText(vec2(108, 20), vars.standartFont, "Back", textColor, ColorRGBA(0, 0, 0, 0))

        if vars.isGallery then
            gdt.VideoChip0:DrawText(vec2(108, 30), vars.standartFont, "Next", textColor,
                ColorRGBA(0, 0, 0, 0))
            gdt.VideoChip0:DrawText(vec2(108, 40), vars.standartFont, "Previous", textColor,
                ColorRGBA(0, 0, 0, 0))

            if gdt.VideoChip0.TouchDown then
                local touchPos = gdt.VideoChip0.TouchPosition
                local newImageUrl = ""
                if touchPos.X >= 108 and touchPos.X <= 128 and touchPos.Y >= 30 and touchPos.Y <= 38 then
                    -- Next
                    if vars.galleryIndex == #vars.page.images then
                        return
                    end
                    vars.galleryIndex = vars.galleryIndex + 1
                    newImageUrl = vars.page.images[vars.galleryIndex]
                elseif touchPos.X >= 108 and touchPos.X <= 128 and touchPos.Y >= 40 and touchPos.Y <= 48 then
                    -- Previous
                    if vars.galleryIndex == 1 then
                        return
                    end
                    vars.galleryIndex = vars.galleryIndex - 1
                    newImageUrl = vars.page.images[vars.galleryIndex]
                end

                if newImageUrl ~= "" and newImageUrl ~= nil then
                    isWaitingForData = true
                    print("Downloading image in Gallery mode: " .. newImageUrl)
                    currentZoomLevel = 1
                    downloadWidth = zoomInformation[currentZoomLevel].downloadWidth
                    downloadHeight = zoomInformation[currentZoomLevel].downloadHeight
                    cropX = zoomInformation[currentZoomLevel].cropWidth
                    cropY = zoomInformation[currentZoomLevel].cropHeight
                    isWaitingForData = true
                    x = 0
                    y = 0
                    gdt.Wifi0:WebGet(getURLPath() .. "/image/crop" .. tableToQuery({
                        url = newImageUrl,
                        stream = false,
                        downloadWidth = downloadWidth,
                        downloadHeight = downloadHeight,
                        x = x,
                        y = y,
                        width = cropX,
                        height = cropY
                    }))
                    isDirty = true
                end
            end
        end

        if gdt.VideoChip0.TouchDown then
            local touchPos = gdt.VideoChip0.TouchPosition
            -- If the user presses the text button, display the text
            if touchPos.X >= 110 and touchPos.X <= 130 and touchPos.Y >= 10 and touchPos.Y <= 18 then
                isTextMode = true
                vars.scroll = 0
            end

            -- If the user presses the back button, pop the stack and go back to the previous page
            if touchPos.X >= 110 and touchPos.X <= 130 and touchPos.Y >= 20 and touchPos.Y <= 28 then
                local stackInfo = table.remove(vars.stack)
                vars.currentPage = stackInfo.currentPage
                vars.page = stackInfo.page
                vars.scroll = stackInfo.scroll
                vars.state = stackInfo.state
                vars.clearScreen = stackInfo.shouldClear
            end
        end

        if gdt.LedButton2.ButtonState or gdt.LedButton3.ButtonState then
            isDirty = true
        end

        if not isDirty then
            return
        end
        gdt.VideoChip0:Clear(backGroundColor)


        if image.width == 0 or image.height == 0 then
            gdt.VideoChip0:DrawText(vec2(8, 50), vars.standartFont, "Error displaying image", color.red, color.black)
        end

        -- Display the image
        local start_x, start_y = 0, 10 -- Adjust these coordinates as needed

        -- The image starts drawing at the top left corner.
        -- However we want to draw the image in the center of the screen. So we need to calculate the start coordinates
        -- of the image.
        -- The image is not always 128 x 72 pixels, so we need to calculate the start coordinates based on the image
        -- size.
        start_x = math.floor((128 - image.width) / 2)
        start_y = math.floor((72 - image.height) / 2) + 10

        -- Assuming you have a function to draw pixels on the screen:
        for y = 1, image.height do
            for x = 1, image.width do
                local pixel = image.pixelData[y][x]
                gdt.VideoChip0:SetPixel(vec2(start_x + x - 1, start_y + y - 1),
                    ColorRGBA(pixel.r, pixel.g, pixel.b, pixel.a))
            end
        end

        isDirty = false
    else -- If there is no image display an error
        gdt.VideoChip0:DrawText(vec2(5, 20), vars.standartFont, "No image loaded.", color.red, color.black)
    end
end

---comment
---@param data string
function handleData(data)
    vars.clearScreen = false
    isDirty = true
    -- Loop through each line in the data
    local lines = {}
    for line in data:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    for _, line in ipairs(lines) do
        -- line 2 is the width and height of the image
        if _ == 2 then
            local width, height = line:match("(%d+) (%d+)")
            image = {
                width = tonumber(width),
                height = tonumber(height),
                pixelData = {}
            }
        end

        -- line 3 is the color range of the image
        if _ == 3 then
            image.colorRange = tonumber(line)
        end

        -- line 4 and onwards is the pixel data
        if _ >= 4 then
            -- Add colors
            local pixelRow = {}
            for r, g, b, a in line:gmatch("(%d+) (%d+) (%d+) (%d+)") do
                table.insert(pixelRow, {
                    r = tonumber(r),
                    g = tonumber(g),
                    b = tonumber(b),
                    a = tonumber(a)
                })
            end
            table.insert(image.pixelData, pixelRow)
        end
    end

    isWaitingForData = false

    print("Image width: " .. image.width)
    print("Image height: " .. image.height)
    print("Image pixel count: " .. image.width * image.height)
    print("Image color range: " .. image.colorRange)
    print("Image pixel data count: " .. #image.pixelData)
    print("Gallery index: " .. vars.galleryIndex)
    print("Gallery image count: " .. #vars.page.images)
end

return {
    handleData = handleData,
    render = render,
    image = image
}
