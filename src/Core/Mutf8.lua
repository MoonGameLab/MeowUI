local string = string
local Mutf8Mapping = assert(require(MeowUI.cwd .. "Core.Mutf8Mapping"))
local Utf8_uc_lc = Mutf8Mapping.utf8_uc_lc
local Utf8_lc_uc = Mutf8Mapping.utf8_lc_uc
local Shift_6 = 2 ^ 6
local Shift_12 = 2 ^ 12
local Shift_18 = 2 ^ 18
local ONE_BYTE = 1
local TWO_BYTE = 2
local THREE_BYTE = 3
local FOUR_BYTE = 4
do
  string.utf8charbytes = function(str, i)
    if i == nil then
      i = 1
    end
    assert(type(str) == "string", "bad argument #1 to 'utf8charbytes' (string expected, got " .. type(str) .. ")")
    assert(type(i) == "number", "bad argument #2 to 'utf8charbytes' (number expected, got " .. type(i) .. ")")
    local numRepByteOne = str:byte(i)
    if numRepByteOne > 0 and numRepByteOne <= 127 then
      return ONE_BYTE
    elseif numRepByteOne >= 194 and numRepByteOne <= 223 then
      local numRepByteTwo
      numRepByteTwo = str:byte(i + ONE_BYTE)
      assert(numRepByteTwo ~= nil, "UTF-8 string terminated early")
      if numRepByteTwo < 128 or numRepByteTwo > 191 then
        error("Invalid UTF-8 character")
      end
      return TWO_BYTE
    elseif numRepByteOne >= 224 and numRepByteOne <= 239 then
      local numRepByteTwo
      local numRepByteThree
      numRepByteTwo, numRepByteThree = str:byte(i + ONE_BYTE), str:byte(i + TWO_BYTE)
      assert((numRepByteTwo ~= nil and numRepByteThree ~= nil), "UTF-8 string terminated early")
      if numRepByteOne == 224 and (numRepByteTwo < 160 or numRepByteTwo > 191) then
        error("Invalid UTF-8 character")
      elseif numRepByteOne == 237 and (numRepByteTwo < 128 or numRepByteTwo > 159) then
        error("Invalid UTF-8 character")
      elseif numRepByteTwo < 128 or numRepByteTwo > 191 then
        error("Invalid UTF-8 character")
      end
      if numRepByteThree < 128 or numRepByteThree > 191 then
        error("Invalid UTF-8 character")
      end
      return THREE_BYTE
    elseif numRepByteOne >= 240 and numRepByteOne <= 244 then
      local numRepByteTwo
      local numRepByteThree
      local numRepByteFour
      numRepByteTwo, numRepByteThree, numRepByteFour = str:byte(i + ONE_BYTE), str:byte(i + TWO_BYTE), str:byte(i + THREE_BYTE)
      assert((numRepByteTwo ~= nil and numRepByteThree ~= nil and numRepByteFour ~= nil), "UTF-8 string terminated early")
      if numRepByteOne == 240 and (numRepByteTwo < 144 or numRepByteTwo > 191) then
        error("Invalid UTF-8 character")
      elseif numRepByteOne == 244 and (numRepByteTwo < 128 or numRepByteTwo > 143) then
        error("Invalid UTF-8 character")
      elseif numRepByteTwo < 128 or numRepByteTwo > 191 then
        error("Invalid UTF-8 character")
      end
      if numRepByteThree < 128 or numRepByteThree > 191 then
        error("Invalid UTF-8 character")
      end
      if numRepByteFour < 128 or numRepByteFour > 191 then
        error("Invalid UTF-8 character")
      end
      return FOUR_BYTE
    else
      return error("Invalid UTF-8 character")
    end
  end
  string.utf8len = function(str)
    assert(type(str) == "string", "bad argument #1 to 'utf8len' (string expected, got " .. type(str) .. ")")
    local idx, bytes, len = 1, str:len(), 0
    while idx <= bytes do
      len = len + 1
      idx = idx + str:utf8charbytes(idx)
    end
    return len
  end
  string.utf8sub = function(str, i, j)
    if j == nil then
      j = -1
    end
    assert(type(str) == "string", "bad argument #1 to 'utf8len' (string expected, got " .. type(str) .. ")")
    assert(type(i) == "number", "bad argument #2 to 'utf8len' (number expected, got " .. type(i) .. ")")
    assert(type(j) == "number", "bad argument #3 to 'utf8len' (number expected, got " .. type(j) .. ")")
    local idx, bytes, len = 1, str:len(), 0
    local l = (i >= 0 and j >= 0) or str:utf8len()
    local startChar = (i >= 0) and i or l + i + 1
    local endChar = (j >= 0) and j or l + j + 1
    if startChar > endChar then
      return ""
    end
    local startByte, endByte = 1, bytes
    while idx <= bytes do
      len = len + 1
      if len == startChar then
        startByte = idx
      end
      idx = idx + str:utf8charbytes(idx)
      if len == endChar then
        endByte = idx - 1
        break
      end
    end
    if startChar > len then
      startByte = bytes + 1
    end
    if endChar < 1 then
      endByte = 0
    end
    return str:sub(startByte, endByte)
  end
  string.utf8replace = function(str, mapping)
    assert(type(str) == "string", "bad argument #1 to 'utf8len' (string expected, got " .. type(str) .. ")")
    assert(type(mapping) == "table", "bad argument #2 to 'utf8len' (table expected, got " .. type(mapping) .. ")")
    local charBytes
    local idx, bytes, newStr = 1, str:len(), ""
    while idx <= bytes do
      charBytes = str:utf8charbytes(idx)
      local c = str:sub(idx, idx + charBytes - 1)
      newStr = newStr .. (mapping[c] or c)
      idx = idx + charBytes
    end
    return newStr
  end
  string.utf8upper = function(str)
    return str:utf8replace(Utf8_lc_uc)
  end
  string.utf8lower = function(str)
    return str:utf8replace(Utf8_uc_lc)
  end
  string.utf8reverse = function(str)
    assert(type(str) == "string", "bad argument #1 to 'utf8len' (string expected, got " .. type(str) .. ")")
    local charBytes
    local newStr = ""
    local idx
    idx, newStr = str:len(), ""
    while idx > 0 do
      local char = str:byte(idx)
      while char > 128 and char < 191 do
        idx = idx - 1
        char = str:byte(idx)
      end
      charBytes = str:utf8charbytes(idx)
      newStr = newStr .. str:sub(idx, idx + charBytes - 1)
      idx = idx - 1
    end
    return newStr
  end
  string.utf8char = function(uc)
    if uc <= 0x7F then
      return string.char(uc)
    end
    if uc <= 0x7FF then
      local B0 = 0xC0 + math.floor(uc / 0x40)
      local B1 = 0x80 + math.floor(uc % 0x40)
      return string.char(B0, B1)
    end
    if uc <= 0xFFFF then
      local B0 = 0xC0 + math.floor(uc / 0x1000)
      local B1 = 0x80 + (math.floor(uc / 0x40) % 0x40)
      local B2 = 0x80 + (uc % 0x40)
      return string.char(B0, B1, B2)
    end
    if uc <= 0x10FFFF then
      local code = uc
      local B3 = 0x80 + (code % 0x40)
      code = math.floor(code / 0x40)
      local B2 = 0x80 + (code % 0x40)
      code = math.floor(code / 0x40)
      local B1 = 0x80 + (code % 0x40)
      code = math.floor(code / 0x40)
      local B0 = 0xF0 + code
      return string.char(B0, B1, B2, B3)
    end
    return error('Unicode cannot be greater than U+10FFFF!')
  end
  string.utf8unicode = function(str, i, j, bytePos)
    if i == nil then
      i = 1
    end
    if j == nil then
      j = 1
    end
    if i > j then
      return 
    end
    local char, bytes
    if bytePos then
      bytes = str:utf8charbytes(bytePos)
      char = str:sub(bytePos, bytePos - 1 + bytes)
    else
      char, bytePos = str:utf8sub(i, i)
      bytes = #char
    end
    local unicode
    if bytes == 1 then
      unicode = string.byte(char)
    end
    if bytes == 2 then
      local Byte0, Byte1 = string.byte(char, 1, 2)
      local Code0, Code1 = Byte0 - 0xC0, Byte1 - 0x80
      unicode = Code0 * Shift_6 + Code1
    end
    if bytes == 3 then
      local Byte0, Byte1, Byte2 = string.byte(char, 1, 3)
      local Code0, Code1, Code2 = Byte0 - 0xE0, Byte1 - 0x80, Byte2 - 0x80
      unicode = Code0 * Shift_12 + Code1 * Shift_6 + Code2
    end
    if bytes == 4 then
      local Byte0, Byte1, Byte2, Byte3 = string.byte(char, 1, 4)
      local Code0, Code1, Code2, Code3 = Byte0 - 0xF0, Byte1 - 0x80, Byte2 - 0x80, Byte3 - 0x80
      unicode = Code0 * Shift_18 + Code1 * Shift_12 + Code2 * Shift_6 + Code3
    end
    return unicode, str:utf8unicode(i + 1, j, bytePos + bytes)
  end
  string.utf8gensub = function(str, subLen)
    if subLen == nil then
      subLen = 1
    end
    local bytePos = 1
    local len = #str
    return function()
      local charCount = 0
      local start = bytePos
      while charCount ~= subLen do
        if bytePos > len then
          return 
        end
        charCount = charCount + 1
        local bytes = str:utf8charbytes(bytePos)
        bytePos = bytePos + bytes
      end
      local last = bytePos - 1
      local sub = str:sub(start, last)
      return sub, start, last
    end
  end
  return string
end
