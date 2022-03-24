----
-- Adds UTF-8 functions to string lua table.
-- @module Mutf8

--- refs
-- https://www.utf8-chartable.de/unicode-utf8-table.pl?number=1024&utf8=dec
-- https://en.wikipedia.org/wiki/UTF-8

string = string

Mutf8Mapping = assert require MeowUI.cwd .. "Core.Mutf8Mapping"

utf8_uc_lc = Mutf8Mapping.utf8_uc_lc
utf8_lc_uc = Mutf8Mapping.utf8_lc_uc



ONE_BYTE = 1
TWO_BYTE = 2
THREE_BYTE = 3
FOUR_BYTE = 4


with string
  -- [(B1), (B2), (B3), (B4)]
  -- 1 BYTE CHARS : [ (0 - 127) ]
  -- 2 BYTE CHARS : [ (194 - 223),  (forEach (B1(*)) -> (128 - 191))]
  -- 3 BYTE CHARS :[ (224 - 239),
                  -- (forEach (B1(224)) -> (160 - 191)) <11100000	10100000	10000000>
                  -- (forEach (B1(237)) -> (128 - 159)) <Skip private Use High Surrogate>
                  -- (forEach (B1(ELSE)) -> (128 - 191)),
                  -- (128 - 191)]
  -- 4 BYTE CHARS : [ (240 - 244),
                  -- (forEach (B1(240)) -> (144 - 191))
                  -- (forEach (B1(244)) -> (128 - 143))
                  -- (forEach (B1(ELSE)) -> (128 - 191)),
                  -- (128 - 191), (128 - 191)]
  .utf8charbytes = (str, i = 1) ->
    assert type(str) == "string",
      "bad argument #1 to 'utf8charbytes' (string expected, got ".. type(str).. ")"

    assert type(i) == "number",
      "bad argument #2 to 'utf8charbytes' (number expected, got ".. type(i).. ")"

    -- Numeric representation
    numRepByteOne = str\byte i

    -- Determine bytes needed for char [ RFC 3629 ]
    -- first Byte
    if numRepByteOne > 0 and numRepByteOne <= 127 then return ONE_BYTE
    elseif numRepByteOne >= 194 and numRepByteOne <= 223
      local numRepByteTwo

      numRepByteTwo = str\byte(i + ONE_BYTE)

      assert numRepByteTwo ~= nil, "UTF-8 string terminated early"

      -- second byte
      if numRepByteTwo < 128 or numRepByteTwo > 191 then error "Invalid UTF-8 character"

      return TWO_BYTE

    elseif numRepByteOne >= 224 and numRepByteOne <= 239
      local numRepByteTwo
      local numRepByteThree

      numRepByteTwo, numRepByteThree = str\byte(i + ONE_BYTE), str\byte(i + TWO_BYTE)

      assert (numRepByteTwo ~= nil and numRepByteThree ~= nil), "UTF-8 string terminated early"

      -- second byte
      if numRepByteOne == 224 and (numRepByteTwo < 160 or numRepByteTwo > 191) then error "Invalid UTF-8 character"
      elseif numRepByteOne == 237 and (numRepByteTwo < 128 or numRepByteTwo > 159) then error "Invalid UTF-8 character"
      elseif numRepByteTwo < 128 or numRepByteTwo > 191 then error "Invalid UTF-8 character"

      -- third byte
      if numRepByteThree < 128 or numRepByteThree > 191 then error "Invalid UTF-8 character"

      return THREE_BYTE

    elseif numRepByteOne >= 240 and numRepByteOne <= 244
      local numRepByteTwo
      local numRepByteThree
      local numRepByteFour

      numRepByteTwo, numRepByteThree, numRepByteFour = str\byte(i + ONE_BYTE), str\byte(i + TWO_BYTE), str\byte(i + THREE_BYTE)

      assert (numRepByteTwo ~= nil and numRepByteThree ~= nil and numRepByteFour ~= nil), "UTF-8 string terminated early"

      -- second byte
      if numRepByteOne == 240 and (numRepByteTwo < 144 or numRepByteTwo > 191) then error "Invalid UTF-8 character"
      elseif numRepByteOne == 244 and (numRepByteTwo < 128 or numRepByteTwo > 143) then error "Invalid UTF-8 character"
      elseif numRepByteTwo < 128 or numRepByteTwo > 191 then error "Invalid UTF-8 character"

      -- third byte
      if numRepByteThree < 128 or numRepByteThree > 191 then error "Invalid UTF-8 character"

      -- fourth byte
      if numRepByteFour < 128 or numRepByteFour > 191 then error "Invalid UTF-8 character"

      return FOUR_BYTE

    else
      error "Invalid UTF-8 character"

  -- the lenght of an UTF-8 string
  .utf8len = (str) ->
    assert type(str) == "string", "bad argument #1 to 'utf8len' (string expected, got ".. type(str) .. ")"

    idx, bytes, len = 1, str\len!, 0

    while idx <= bytes
      len += 1
      idx += str\utf8charbytes idx

    len

  .utf8sub = (str, i, j = -1) ->

    assert type(str) == "string", "bad argument #1 to 'utf8len' (string expected, got ".. type(str) .. ")"
    assert type(i) == "number", "bad argument #2 to 'utf8len' (number expected, got ".. type(i) .. ")"
    assert type(j) == "number", "bad argument #3 to 'utf8len' (number expected, got ".. type(j) .. ")"

    idx, bytes, len = 1, str\len!, 0

    l = (i >= 0 and j >= 0) or str\utf8len!
    startChar = (i >= 0) and i or l + i + 1
    endChar = (j >= 0) and j or l + j + 1

    if startChar > endChar then return ""

    startByte, endByte = 1, bytes

    while idx <= bytes
      len += 1

      if len == startChar then startByte = idx

      idx += str\utf8charbytes idx

      if len == endChar
        endByte = idx - 1
        break

    if startChar > len then startByte = bytes + 1
    if endChar < 1 then endByte = 0

    str\sub startByte, endByte

  .utf8replace = (str, mapping) ->
    assert type(str) == "string", "bad argument #1 to 'utf8len' (string expected, got ".. type(str) .. ")"
    assert type(mapping) == "table", "bad argument #2 to 'utf8len' (table expected, got ".. type(mapping) .. ")"

    local charBytes
    idx, bytes, newStr = 1, str\len!, ""

    while idx <= bytes
      charBytes = str\utf8charbytes idx
      c = str\sub idx, idx + charBytes - 1

      newStr = newStr .. (mapping[c] or c)

      idx += charBytes

    newStr

  .utf8upper = (str) ->
    str\utf8replace utf8_lc_uc

  .utf8lower = (str) ->
    str\utf8replace utf8_uc_lc

  .utf8reverse = (str) ->
    assert type(str) == "string", "bad argument #1 to 'utf8len' (string expected, got ".. type(str) .. ")"

    local charBytes
    newStr = ""
    idx, newStr = str\len!, ""

    while idx > 0
      char = str\byte idx
      -- for chars represented in 2+ Bytes
      while char > 128 and char < 191
        idx -= 1
        char = str\byte idx

      charBytes = str\utf8charbytes idx

      newStr ..= str\sub idx, idx + charBytes - 1

      idx -= 1

    newStr

  .utf8char = (uc) ->
    if uc <= 0x7F then return string.char uc

    if (uc <= 0x7FF)
      B0 = 0xC0 + math.floor(uc / 0x40)
      B1 = 0x80 + math.floor(uc % 0x40)
      return string.char B0, B1

    if (uc <= 0xFFFF)
      B0 = 0xC0 + math.floor(uc / 0x1000)
      B1 = 0x80 + (math.floor(uc / 0x40) % 0x40)
      B2 = 0x80 + (uc % 0x40)
      return string.char B0, B1, B2

    if (uc <= 0x10FFFF)
      code = uc
      B3 = 0x80 + (code % 0x40)
      code = math.floor(code / 0x40)
      B2 = 0x80 + (code % 0x40)
      code = math.floor(code / 0x40)
      B1= 0x80 + (code % 0x40)
      code = math.floor(code / 0x40)
      B0 = 0xF0 + code
      return string.char B0, B1, B2, B3

    error 'Unicode cannot be greater than U+10FFFF!'








