local vars = require("vars")
local textlib = {}

---Draws text using the RG functions
---@param position vec2
---@param text string
---@param color color
---@param backgroundColor color
local function draw(position, text, color, backgroundColor)
    textlib.hasDrawnText = true
    if not backgroundColor then
        backgroundColor = Color(0, 0, 0)
    end
    gdt.VideoChip0:DrawText(position, vars.standartFont, text, color, backgroundColor)
end

textlib.hasDrawnText = false

--- Helper function to extract the color tag from a given word
---@param word string
---@param defaultColor color
---@return string, color
local function extractColorTag(word, defaultColor)
    local colorTagPattern = "%[(#%x+)%]"
    local colorTag = word:match(colorTagPattern)
    if colorTag then
        local processedWord = word:gsub(colorTagPattern, "")
        local r = tonumber(colorTag:sub(2, 3), 16)
        local g = tonumber(colorTag:sub(4, 5), 16)
        local b = tonumber(colorTag:sub(6, 7), 16)
        return processedWord, Color(r, g, b)
    else
        return word, defaultColor
    end
end

--- Draws Text on the screen which also supports line breaks, color tags, and image tags
---@param position vec2
---@param text string
---@param defaultColor color
---@param defaultBackgroundColor color
---@param textBoxSize vec2
---@param charSize vec2
---@param lineHeight number
---@param scroll number
---@param invertScroll boolean
function textlib:drawText(position, text, defaultColor, defaultBackgroundColor, textBoxSize, charSize, lineHeight, scroll,
                          invertScroll)
    textlib.hasDrawnText = false


    -- Split the text into words and new lines
    local lines = {}
    for line in text:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    if #lines < 10 and invertScroll == nil then
        scroll = -scroll
    elseif invertScroll then
        scroll = -scroll
    end

    -- Initialize variables for text positioning
    local x = position.X
    local y = position.Y - scroll * (lineHeight * (#lines) - textBoxSize.Y)

    -- Loop through each line in the text
    for _, line in ipairs(lines) do
        local words = {}
        for word in line:gmatch("%S+") do
            table.insert(words, word)
        end

        -- Loop through each word in the line
        local currentColor = defaultColor
        for i, word in ipairs(words) do
            local processedWord, wordColor = extractColorTag(word, currentColor)
            local wordWidth = processedWord:len() * charSize.X

            -- Check if the current word is an image tag
            local imageTagPattern = "%[image:(.-)%]"
            local imageUrl = word:match(imageTagPattern)
            if imageUrl then
                -- Handle image tag (skip drawing)
                -- Check for touch on the image link
                if y >= position.Y and y + lineHeight <= position.Y + textBoxSize.Y then
                    if gdt.VideoChip0.TouchDown and
                        gdt.VideoChip0.TouchPosition.X >= x and
                        gdt.VideoChip0.TouchPosition.X <= x + wordWidth and
                        gdt.VideoChip0.TouchPosition.Y >= y and
                        gdt.VideoChip0.TouchPosition.Y <= y + lineHeight then
                        -- Add the current info to the stack
                        table.insert(vars.stack, {
                            scroll = scroll,
                            page = vars.page,
                            currentPage = vars.currentPage,
                            state = vars.state,
                            shouldClear = vars.clearScreen
                        })

                        vars.scroll = 0
                        vars.state = "imageViewer" -- Change vars.state to "imageViewer" when the link is touched
                        vars.imageUrl = imageUrl
                        vars.isGallery = false
                        gdt.Wifi0:WebGet(getURLPath() .. "/image" .. tableToQuery({
                            url = imageUrl,
                            stream = false
                        }))
                    end
                end
            else
                -- Check if the current word is a wikilink tag
                local linkTagPattern = "%[wikilink:{(.-)}(.-)%]"
                local innerHTML, url = word:match(linkTagPattern)

                -- There are cases where theres an imcomplete wikilink tag
                -- This is because the words are split by spaces and the wikilink tag is split into 2 words
                -- To circumvent this, I converted the innerHTML spaces into underscores
                -- This is a hacky solution but it works
                if innerHTML and url then
                    innerHTML = innerHTML:gsub("_", " ")
                end

                local lastColor = wordColor
                local resetColor = false



                if innerHTML and url then
                    -- Handle wikilink tag
                    wordWidth = innerHTML:len() * charSize.X -- Update wordWidth to match the innerHTML length
                    processedWord = innerHTML                -- Update processedWord to match the innerHTML
                    wordColor = color.cyan                   -- Set the word color to cyan
                    resetColor = true                        -- Set resetColor to true to reset the color after drawing the word
                end

                local function checkLink()
                    -- Check if its a wikilink tag and if its being touched :sus:
                    if gdt.VideoChip0.TouchDown then
                        if innerHTML and url then
                            local touchX = gdt.VideoChip0.TouchPosition.X
                            local touchY = gdt.VideoChip0.TouchPosition.Y
                            if touchX >= x and touchX <= x + wordWidth and touchY >= y and touchY <= y + lineHeight then
                                print("Touched wikilink: " .. url)
                                if url == "internal:goback" then
                                    if #vars.stack == 0 then
                                        vars.scroll = 0
                                        vars.state = "pageView"
                                        vars.page = {}
                                        vars.currentPage = "Main_Page"
                                        vars.clearScreen = true
                                        vars.isPageFetching = false
                                        vars.pageFetched = false
                                        vars.isError = false
                                        return
                                    end

                                    local lastStack = table.remove(vars.stack)
                                    vars.scroll = lastStack.scroll
                                    vars.page = lastStack.page
                                    vars.currentPage = lastStack.currentPage
                                    vars.state = lastStack.state
                                    vars.clearScreen = lastStack.shouldClear
                                    vars.isPageFetching = false
                                    vars.pageFetched = true
                                    vars.isError = false
                                    return
                                elseif url == "internal:imageGallery" then
                                    table.insert(vars.stack, {
                                        scroll = scroll,
                                        page = vars.page,
                                        currentPage = vars.currentPage,
                                        state = vars.state,
                                        shouldClear = vars.clearScreen
                                    })

                                    vars.isGallery = true
                                    vars.state = "imageViewer"
                                    vars.imageUrl = vars.page.mainImage
                                    gdt.Wifi0:WebGet(getURLPath() .. "/image" .. tableToQuery({
                                        url = vars.page.mainImage,
                                        stream = false
                                    }))
                                    return
                                end
                                vars:switchPage(url)
                            end
                            return
                        end
                    end
                end

                -- Regular word
                -- Check if the current word fits in the remaining space of the current line
                if x + wordWidth <= position.X + textBoxSize.X then
                    -- Check if the word is within the vertical bounds of the textBox
                    if y >= position.Y and y + lineHeight <= position.Y + textBoxSize.Y then
                        checkLink()
                        draw(vec2(x, y), processedWord, wordColor, defaultBackgroundColor)
                    end
                    x = x + wordWidth + charSize.X -- Move the x position to the right of the word and add some padding
                else
                    -- Move to the next line
                    x = position.X
                    y = y + lineHeight

                    -- Check if the word is within the vertical bounds of the textBox
                    if y >= position.Y and y + lineHeight <= position.Y + textBoxSize.Y then
                        checkLink()
                        draw(vec2(x, y), processedWord, wordColor, defaultBackgroundColor)
                    end
                    x = x + wordWidth + charSize.X -- Move the x position to the right of the word and add some padding
                end



                if resetColor then
                    wordColor = lastColor -- Reset the word color
                end
            end

            currentColor = wordColor -- Update the current color for the next word
        end

        -- Move to the next line
        x = position.X
        y = y + lineHeight
    end
end

function textlib:handleHTML(html)
    local function replaceAnchorTag(anchor)
        local href = anchor:match('href="(.-)"')
        if href then
            -- Remove relative paths (starting with "./")
            href = href:gsub('^%./', '')

            local innerHTML = anchor:match('>(.-)</a>')
            if not innerHTML then
                innerHTML = "" -- If there's no innerHTML, set it to an empty string
            end

            -- Convert spaces to underscores
            innerHTML = innerHTML:gsub(" ", "_")
            href = href:gsub(" ", "_")

            return "[wikilink:" .. "{" .. innerHTML .. "}" .. href .. "] "
        else
            return ""
        end
    end

    local result = html:gsub('<a%s+.-</a>', replaceAnchorTag)
    result = result:gsub('<[^>]->', '') -- Remove all other tags

    return result
end

return textlib;
