---@meta _

---A linear component that slides from one end to the other to set numerical values.
---@class Slider:Module
---@field Value number The value returned by the position of the slider, ranging from 0 to 100.
---@field IsMoving boolean Returns `true` if the user is moving the slider. READ ONLY.
---@field Type "Slider"

---Triggered when the slider is moved.
---@class SliderValueChangeEvent
---@field Value number is the respective value given by the slider's position
---@field Type "SliderValueChangeEvent" is "SliderValueChangeEvent". 
