---@meta _

---A circular component that rotates from left to right to set numerical values.
---@class Knob:Module
---@field Value number The value returned by the position of the knob, ranging from -100 to 100.
---@field IsMoving boolean Returns `true` if the user is moving the knob. READ ONLY.
---@field Type "Knob"

---Triggered when the knob is moved.
---@class KnobValueChangeEvent
---@field Value number is the respective value given by the knob's position.
---@field Type "KnobValueChangeEvent" is "KnobValueChangeEvent". 
