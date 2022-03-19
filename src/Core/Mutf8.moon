----
-- Adds UTF-8 functions to string lua table.
-- @module Mutf8

string = string

ONE_BYTE = 1
TWO_BYTE = 2
THREE_BYTE = 3
FOUR_BYTE = 4


with string
  .utf8charbytes = (str, i = 1) ->
    assert type(str) == "string",
      "bad argument #1 to 'utf8charbytes' (string expected, got ".. type(str).. ")"
    
    assert type(i) == "number",
      "bad argument #2 to 'utf8charbytes' (number expected, got ".. type(i).. ")"

    -- Numeric representation
    numRep = str\byte(i)

    --print str, str\byte(i), str\byte(i + 1)

    -- Determine bytes needed for char [ RFC 3629 ]
    -- first Byte
    if numRep > 0 and numRep <= 127 then return ONE_BYTE
    elseif numRep >= 194 and numRep <= 223
      numRepByteTwo = str\byte(i + 1)

      assert numRepByteTwo ~= nil, "UTF-8 string terminated early"
      assert numRepByteTwo >= 128 or numRepByteTwo <= 191, "Invalid UTF-8 character"

      return TWO_BYTE
