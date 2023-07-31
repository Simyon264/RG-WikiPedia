---@meta _

---@class SerialParity
---@class SerialStopBits
---@class SerialReceiveMode

---@class Serial:Module
---@field ReceiveMode SerialReceiveMode Determines the type of data received by the SerialReceiveEvent event.
---@field Port number Serial COM port number.
---@field IsActive boolean Indicates if the serial connection on the specified port is active. READ ONLY.
---@field BaudRate number The serial connection baud rate.
---@field DataBits number The standard length of data bits per byte. The value must be between 5 and 8 inclusive.
---@field Parity SerialParity The serial connection parity-checking protocol.
---@field StopBits SerialStopBits The number of stopbits per byte.
---@field Type "Serial"
---@field WriteInt8 fun(self:Serial, data:number) Writes an 8-bit integer to the serial port.
---@field WriteUInt8 fun(self:Serial, data:number) Writes an 8-bit unsigned integer to the serial port.
---@field WriteInt16 fun(self:Serial, data:number) Writes an 16-bit integer to the serial port.
---@field WriteUInt16 fun(self:Serial, data:number) Writes a 16-bit unsigned integer to the serial port.
---@field WriteInt32 fun(self:Serial, data:number) Writes an 32-bit integer to the serial port.
---@field WriteUInt32 fun(self:Serial, data:number) Writes an 32-bit unsigned integer to the serial port.
---@field WriteFloat32 fun(self:Serial, data:number) Writes a 32-bit float to the serial port.
---@field WriteFloat64 fun(self:Serial, data:number) Writes a 64-bit float to the serial port.
---@field Write fun(self:Serial, data:string) Writes a byte array to the serial port.
---@field Print fun(self:Serial, data:string) Write a utf8 string to the serial port.
---@field Println fun(self:Serial, data:string) Writes a string with a \n (new line) added at the end to the serial port.
---@field GetAvailablePorts fun(self:Serial):number[] Returns an array containing the available serial COM port numbers.

---Sent when the serial IsActive state change.
---@class SerialIsActiveEvent
---@field IsActive boolean indicates if the serial connection on the specified port is active.
---@field Type "SerialIsActiveEvent" is "SerialIsActiveEvent"

---Sent when data is received from a Serial module.
---@class SerialReceiveEvent
---@field Data string `BinaryData` mode data
---@field Lines string[] `Lines` mode data
---@field Type "SerialReceiveEvent" is "SerialReceiveEvent"

SerialParity = {
    ---No parity check occurs
    ---@type SerialParity
    None = nil,
    ---Sets the parity bit so that the count of bits set is an odd number.
    ---@type SerialParity
    Odd = nil,
    ---Sets the parity bit so that the count of bits set is an even number.
    ---@type SerialParity
    Even = nil,
    ---Leaves the parity bit set to 1.
    ---@type SerialParity
    Mark = nil,
    ---Leaves the parity bit set to 0.
    ---@type SerialParity
    Space = nil,
}

SerialStopBits = {
    ---One stop bit is used.
    ---@type SerialStopBits
    One = nil,
    ---1.5 stop bits are used.
    ---@type SerialStopBits
    OnePointFive = nil,
    ---Two stop bits are used.
    ---@type SerialStopBits
    Two = nil,
}

SerialReceiveMode = {
    ---The `BinaryData` option passes binary data into the event's Data property.
    ---@type SerialReceiveMode
    BinaryData = nil,
    ---The `Lines` option splits the received data into lines using the \n character as a separator, writing the result inside the event's Lines property.
    ---@type SerialReceiveMode
    Lines = nil,
}
