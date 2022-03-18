string = string

with string
  .utf8charbytes = (str, i = 1) ->
    assert type(str) == "string",
      "bad argument #1 to 'utf8charbytes' (string expected, got ".. type(str).. ")"
    
    assert type(i) == "number",
      "bad argument #2 to 'utf8charbytes' (number expected, got ".. type(i).. ")"

    -- Numeric representation
    numRep, l = str\byte(i), str\byte(i + 1)

    print numRep, l

    -- Determine bytes needed for char [ RFC 3629 ]
    -- first Byte
    if numRep > 0 and numRep <= 127 then return 1