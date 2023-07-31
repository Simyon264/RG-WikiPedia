---@meta _

---@package
---@alias ANSI_COLORS_FOREGROUND
---|30 # Black (0, 0, 0)
---|31 # Red (255, 0, 0)
---|32 # Green (0, 255, 0)
---|33 # Yellow (255, 255, 0)
---|34 # Blue (0, 0, 255)
---|35 # Magenta (255, 0, 255)
---|36 # Cyan (0, 255, 255)
---|37 # White (176, 174, 165)
---|90 # Bright Black, Gray (24, 22, 13)
---|91 # Bright Red (255, 158, 144)
---|92 # Bright Green (193, 255, 177)
---|93 # Bright Yellow (255, 255, 177)
---|94 # Bright Blue (0, 40, 255)
---|95 # Bright Magenta (255, 159, 255)
---|96 # Bright Cyan (194, 255, 255)
---|97 # Bright White (255, 255, 255)

---@package
---@alias ANSI_COLORS_BACKGROUND
---|40 # Black (0, 0, 0)
---|41 # Red (255, 0, 0)
---|42 # Green (0, 255, 0)
---|43 # Yellow (255, 255, 0)
---|44 # Blue (0, 0, 255)
---|45 # Magenta (255, 0, 255)
---|46 # Cyan (0, 255, 255)
---|47 # White (176, 174, 165)
---|100 # Bright Black, Gray (24, 22, 13)
---|101 # Bright Red (255, 158, 144)
---|102 # Bright Green (193, 255, 177)
---|103 # Bright Yellow (255, 255, 177)
---|104 # Bright Blue (0, 40, 255)
---|105 # Bright Magenta (255, 159, 255)
---|106 # Bright Cyan (194, 255, 255)
---|107 # Bright White (255, 255, 255)

---@param message string
---This will print a message on the screen using the current settings.
function print(message) end

---@param message string
---This will print a message on the screen using the current settings.
function log(message) end

---@param message string
---This will print a message on the screen, automatically colored yellow.
function logWarning(message) end

---@param message string
---This will print a message on the screen, automatically colored red.
function logError(message) end

---@param text string
---This will print a message on the screen without automatically adding a line break.
---Calling this method repeatedly will always print on the same line.
function write(text) end

---@param text string
---This will print a message on the screen adding a line break at the end.
---Functionally the same as `log(message)`.
function writeln(text) end

---@param colorId ANSI_COLORS_FOREGROUND
---Sets the background color of the text to be printed.
---Uses the numbers on the ANSI colors table for Background.
function setFgColor(colorId) end

---@param colorId ANSI_COLORS_BACKGROUND
---Sets the foreground color of the text to be printed.
---Uses the numbers on the ANSI colors table for Foreground.
function setBgColor(colorId) end

---Resets the text foreground color to the default bright white.
function resetFgColor() end

---Resets the text background color to the default black.
function resetBgColor() end

---Resets both background and foreground colors for the text to their defaults.
function resetColors() end

---@param column number
---@param line number
---Sets the absolute position of the cursor, that is, where text is going to be printed.
---Takes both `column` and `line` at once.
function setCursorPos(column, line) end

---@param column number
---Sets only the absolute horizontal position of the cursor to `column`.
function setCursorX(column) end

---@param line number
---Sets only the absolute vertical position of the cursor to `line`.
function setCursorY(line) end

---@param deltaColumn number
---Moves the cursor relative to its current position, horizontally by an amount of `deltaColumn` characters.
function moveCursorX(deltaColumn) end

---@param deltaLine number
---Moves the cursor relative to its current position, vertically by an amount of `deltaLine` characters.
function moveCursorY(deltaLine) end

---Saves the current position of the cursor to memory.
function saveCursorPos() end

---Moves the cursor to the position previously saved with `saveCursorPos()`.
function restoreCursorPos() end

---Clears the entire screen.
function clear() end

---Clears only the line where the cursor currently is.
function clearToEndLine() end
