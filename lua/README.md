# RetroGadgets VSCode Template

## Usage1
* Install VSCode Extension: [sumneko.lua](https://marketplace.visualstudio.com/items?itemName=sumneko.lua)
* [Create a new repository](https://github.com/Dreagonmon/RetroGadgets-VSCode-Template/generate) using this template.
* Define your hardware in `definitions/gdt.lua`
* Enjoy Coding~

## Usage2
* Install VSCode extension: [sumneko.lua](https://marketplace.visualstudio.com/items?itemName=sumneko.lua)
* Clone this template to `/path/to/RetroGadgets-VSCode-Template`.
* Change extension setting: `"Lua.workspace.library": [ "/path/to/RetroGadgets-VSCode-Template" ]`
* Define your hardware in your project `definitions/gdt.lua`
* Enjoy Coding~

## Define the `gdt` Object
```lua
---@meta _

---@class Gadget
----- hardware definition start -----
---@field Motherboards Motherboard[]
---@field PowerButton0 PowerButton
---@field ROM ROM
-----           ......          -----
-----  hardware definition end  -----

---@type Gadget
gdt = {}

```

## Read More
* [Annotations for Lua Extension](https://github.com/LuaLS/lua-language-server/wiki/Annotations)
* [RetroGadgets Documentation](https://docs.retrogadgets.game)

## License
```
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>
```
