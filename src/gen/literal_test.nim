#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
# @deps std
import unittest, strutils, strformat, sets, parseUtils, math, os
from std/random as rand import nil
# @deps nim.gen
import ../tests/base
from ./literal import nil


#_______________________________________
# @section Integers: Generation
#_____________________________
suite "Integer Literal Generation Tests":
  test "Decimal":
    let val = literal.int_decimal(10, 10)
    check val == "10"

    let val2 = literal.int_decimal(-5, -5)
    check val2 == "-5"

    # Test range
    for _ in 0..200:
      os.sleep(1)
      rand.randomize()
      let val = parseInt(literal.int_decimal(10, 20))
      check val >= 10 and val <= 20

  test "Binary":
    var parsed :int= int.high
    let val = literal.int_binary(10, 10)
    check val.startsWith("0b") or val.startsWith("0B")
    discard parseBin(val, parsed)
    check parsed == 10

    # Test negative numbers
    let val2 = literal.int_binary(-5, -5)
    check val2.startsWith("0b") or val2.startsWith("0B")
    discard parseBin(val2, parsed)
    check parsed == -5

    # Test range
    for _ in 0..200:
      os.sleep(1)
      rand.randomize()
      let val = literal.int_binary(10, 20)
      check val.startsWith("0b") or val.startsWith("0B")
      discard parseBin(val, parsed)
      check parsed >= 10 and parsed <= 20

  test "Octal":
    var parsed :int= int.high
    let val = literal.int_octal(10, 10)
    check val.startsWith("0o")
    discard parseOct(val, parsed)
    check parsed == 10

    # Test negative numbers
    let val2 = literal.int_octal(-5, -5)
    check val2.startsWith("0o")
    discard parseOct(val2, parsed)
    check parsed == -5

    # Test range
    for _ in 0..200:
      os.sleep(1)
      rand.randomize()
      let val = literal.int_octal(10, 20)
      check val.startsWith("0o")
      discard parseOct(val, parsed)
      check parsed >= 10 and parsed <= 20

  test "Hexadecimal":
    var parsed :int= int.high
    let val = literal.int_hexadecimal(10, 10)
    check val.startsWith("0x") or val.startsWith("0X")
    discard parseHex(val, parsed)
    check parsed == 10

    # Test negative numbers
    let val2 = literal.int_hexadecimal(-5, -5)
    check val2.startsWith("0x") or val.startsWith("0X")
    discard parseHex(val2, parsed)
    check parsed == -5

    # Test range
    for _ in 0..200:
      os.sleep(1)
      rand.randomize()
      let val = literal.int_hexadecimal(10, 20)
      check val.startsWith("0x") or val.startsWith("0X")
      discard parseHex(val, parsed)
      check parsed >= 10 and parsed <= 20

  test "Underscored":
    # Test single digit
    check literal.int_underscored(5, 5) == "5"
    check literal.int_underscored(-5, -5) == "-5"

    # Test multiple digits
    let val = literal.int_underscored(1000, 1000)
    check '_' in val
    check parseInt(val) == 1000

    # Test no consecutive underscores
    for _ in 0..200:
      os.sleep(1)
      rand.randomize()
      let val = literal.int_underscored(10000, 99999)
      check "__" notin val
      check val[^1] != '_'                   # No underscore at end
      if val[0] == '-' : check val[1] != '_' # No underscore after minus
      else             : check val[0] != '_' # No underscore at start

  test "Suffixed":
    # Test fixed values with different suffixes
    check literal.int_suffixed(42, 42).endsWith("'i8")  # 42 fits in i8
    check literal.int_suffixed(200, 200).endsWith("'u8")  # 200 fits in u8 but not i8
    check literal.int_suffixed(-200, -200).endsWith("'i16")  # -200 needs i16 or larger

    # Test range constraints
    check literal.int_suffixed(0, 255).endsWith("'u8")  # Should fit in u8
    check literal.int_suffixed(-128, 127).endsWith("'i8")  # Should fit in i8
    check literal.int_suffixed(256, 256).endsWith("'i16")  # Too big for u8
    check literal.int_suffixed(-32768, -32768).endsWith("'i16")  # Needs i16
    check literal.int_suffixed(0, 65535).endsWith("'u16")  # Needs u16

    # Test very large numbers
    let big = literal.int_suffixed(uint.high, uint.high)
    check big.endsWith("'u")

    # Test very small numbers
    let small = literal.int_suffixed(int.low, int.low)
    check small.endsWith("'i" & $(sizeof(int)*8))

    # Test that generated numbers are within bounds
    for _ in 0..200:
      os.sleep(1)
      rand.randomize()
      let val = literal.int_suffixed(-150, 150)
      let numStr = val[0..<val.find('\'')]
      let num = parseInt(numStr)
      let suffix = val[val.find('\'')..^1]

      # Verify the number fits the type
      case suffix
      of "'i8"  : check num >= int8.low and num <= int8.high
      of "'u8"  : check num.uint >= 0 and num.uint <= uint8.high.uint
      of "'i16" : check num >= int16.low and num <= int16.high.int
      of "'u16" : check num.uint >= 0 and num.uint <= uint16.high.uint
      of "'i32" : check num >= int32.low and num <= int32.high.int
      of "'u32" : check num.uint >= 0 and num.uint <= uint32.high.uint
      of "'i64" : check num >= -150 and num <= 150  # Original range
      of "'u64" : check num.uint >= 0 and num <= 150     # Original range
      of "'i"   : check num >= int.low and num <= int.high.int
      of "'u"   : check num.uint >= 0 and num.uint <= uint.high.uint
      else      : echo("Unknown suffix: " & suffix); fail()

      # Verify number is within requested range
      check num >= -150 and num <= 150

  test "Combined":
    # Test range enforcement
    for _ in 0..200:
      os.sleep(1)
      rand.randomize()
      let val = literal.integer(10, 20)
      var num: int
      if   val.startsWith("0b") or
           val.startsWith("0B") : discard parseBin(val, num)
      elif val.startsWith("0o") : discard parseOct(val, num)
      elif val.startsWith("0x") or
           val.startsWith("0X") : discard parseHex(val, num)
      elif 'i'  in val or
           'u'  in val or
           '\'' in val          : num = parseInt(val[0..<val.find('\'')])
      elif '_'  in val          : num = parseInt(val.replace("_", ""))
      else                      : num = parseInt(val)
      check num >= 10 and num <= 20

    # Test all possible formats are generated
    var formats = initHashSet[string]()
    for _ in 0..200:
      os.sleep(1)
      rand.randomize()
      let val = literal.integer(int.low, uint.high)
      if   val.startsWith("0b") or
           val.startsWith("0B") : formats.incl("binary")
      elif val.startsWith("0o") : formats.incl("octal")
      elif val.startsWith("0x") or
           val.startsWith("0X") : formats.incl("hexadecimal")
      elif 'i'  in val or
           'u'  in val or
           '\'' in val          : formats.incl("suffixed")
      elif '_' in val           : formats.incl("underscored")
      else                      : formats.incl("basic")

    # We should see all formats
    check formats.len >= 4
    check "binary" in formats
    check "octal" in formats
    check "hexadecimal" in formats
    check "basic" in formats
    check "underscored" in formats
    check "suffixed" in formats


#_______________________________________
# @section Integers: Compilation
#_____________________________
const TmplTestCode = """
# Generated test code - testing literal validity
proc testLiterals() =
$1

when isMainModule:
  testLiterals()
"""

suite "Integer Literal Compilation Tests":
  var testID = 0
  proc compileTest(declarations: seq[string]): bool =
    let testCode = TmplTestCode % [declarations.join("\n")]
    result = base.compileTest("literal", &"integers{testID}.nim", testCode)
    testID.inc

  test "Basic decimal literals compile":
    var declarations = newSeq[string]()
    for i in 1..50:
      let lit = literal.int_decimal(i, i)
      declarations.add("  var x" & $i & " = " & lit)
    check compileTest(declarations)

  test "Binary literals compile":
    var declarations = newSeq[string]()
    for i in 1..50:
      let lit = literal.int_binary(i, i)
      declarations.add("  var x" & $i & " = " & lit)
    check compileTest(declarations)

  test "Octal literals compile":
    var declarations = newSeq[string]()
    for num in 1..50:
      let lit = literal.int_octal(num, num)
      declarations.add("  var x" & $num & " = " & lit)
    check compileTest(declarations)

  test "Hexadecimal literals compile":
    var declarations = newSeq[string]()
    for num in 1..50:
      let lit = literal.int_hexadecimal(num, num)
      declarations.add("  var x" & $num & " = " & lit)
    check compileTest(declarations)

  test "Underscored literals compile":
    var declarations = newSeq[string]()
    for num in [100, 1000, 10000, 100000]:
      let lit = literal.int_underscored(num, num)
      declarations.add("  var x" & $num & " = " & lit)
    check compileTest(declarations)

  test "Suffixed literals compile":
    var declarations = newSeq[string]()
    # Test various ranges that should trigger different suffixes
    let ranges = [
      (-128, 127),
      (0, 255),
      (-32768, 32767),
      (0, 65535),
      (-2147483648, 2147483647),
      (0, 4294967295)
    ]
    for id, (min, max) in ranges:
      let lit = literal.int_suffixed(min, max)
      declarations.add("  var x" & $id & " = " & lit)
    check compileTest(declarations)

  test "Combined literals compile":
    var declarations = newSeq[string]()
    # Test a mix of all formats
    for i in 1..50:
      let lit = literal.integer(-100, 100)
      declarations.add("  var x" & $i & " = " & lit)
    check compileTest(declarations)

  test "Edge cases compile":
    var declarations = newSeq[string]()
    # Test extreme values
    declarations.add("  var x1 = " & literal.int_suffixed(int.low, int.low))
    declarations.add("  var x2 = " & literal.int_suffixed(int.high, int.high))
    declarations.add("  var x3 = " & literal.int_suffixed(uint.high, uint.high))
    declarations.add("  var x4 = " & literal.int_binary(-1, -1))
    declarations.add("  var x5 = " & literal.int_octal(-1, -1))
    declarations.add("  var x6 = " & literal.int_hexadecimal(-1, -1))
    check compileTest(declarations)


#_______________________________________
# @section Strings: Generation
#_____________________________
suite "String Literal Generation Tests":
  test "Basic string literals":
    # Test regular quoted strings
    let val = literal.string_basic("hello")
    check val == "\"hello\""

    # Test escaping
    check literal.string_basic("\"quotes\"") == "\"\\\"quotes\\\"\""
    check literal.string_basic("back\\slash") == "\"back\\\\slash\""

    # Test empty string
    check literal.string_basic("") == "\"\""

  test "Raw string literals":
    # Test raw strings
    let val = literal.string_raw("hello")
    check val == "r\"hello\""

    # Test escaping (only quotes need escaping in raw strings)
    check literal.string_raw("\"quotes\"") == "r\"\"\"quotes\"\"\""
    check literal.string_raw("back\\slash") == "r\"back\\slash\""

    # Test empty string
    check literal.string_raw("") == "r\"\""

  test "Triple quoted string literals":
    # Test triple quoted strings
    let val = literal.string_triple("hello")
    check val == "\"\"\"hello\"\"\""

    # Test that triple quotes in content are handled
    check literal.string_triple("\"\"\"dangerous\"\"\"") == "\"\"\" \"\"dangerous\"\" \"\"\""

    # Test empty string
    check literal.string_triple("") == "\"\"\"\"\"\""

  test "Combined string generation":
    # Test that all formats are generated
    var formats = initHashSet[string]()
    for _ in 0..100:
      let val = literal.string(5, 10)
      if   val.startsWith("r\"")    : formats.incl("raw")
      elif val.startsWith("\"\"\"") : formats.incl("triple")
      else                          : formats.incl("basic")

    # We should see all formats
    check formats.len == 3
    check "raw" in formats
    check "triple" in formats
    check "basic" in formats


#_______________________________________
# @section Strings: Compilation
#_____________________________
suite "String Literal Compilation Tests":
  var testID = 0
  proc compileTest(declarations: seq[string]): bool =
    let testCode = TmplTestCode % [declarations.join("\n")]
    result = base.compileTest("literal", &"strings{testID}.nim", testCode)
    testID.inc

  test "Basic string literals compile":
    var declarations = newSeq[string]()
    for id in 1..50:
      let lit = literal.string_basic("test" & $id)
      declarations.add("  var s" & $id & " = " & lit)
    check compileTest(declarations)

  test "Raw string literals compile":
    var declarations = newSeq[string]()
    for id in 1..50:
      let lit = literal.string_raw("test" & $id)
      declarations.add("  var s" & $id & " = " & lit)
    check compileTest(declarations)

  test "Triple quoted string literals compile":
    var declarations = newSeq[string]()
    for id in 1..50:
      let lit = literal.string_triple("test" & $id)
      declarations.add("  var s" & $id & " = " & lit)
    check compileTest(declarations)

  test "Combined string literals compile":
    var declarations = newSeq[string]()
    # Test a mix of all formats
    for id in 1..50:
      let lit = literal.string(0, 20, generalized = false)
      declarations.add("  var s" & $id & " = " & lit)
    check compileTest(declarations)

  test "Edge cases compile":
    var declarations = newSeq[string]()
    # Test empty strings
    declarations.add("  var s1 = " & literal.string(0, 0))
    # Test strings with special characters
    declarations.add("  var s2 = " & literal.string_basic("\"\\\n\t\""))
    declarations.add("  var s3 = " & literal.string_raw("\"\""))
    declarations.add("  var s4 = " & literal.string_triple("\"\"\"\n\t"))
    # Test long strings
    declarations.add("  var s5 = " & literal.string(100, 100, generalized = false))
    check compileTest(declarations)


#_______________________________________
# @section Floats: Generation
#_____________________________
suite "Float Literal Generation Tests":
  test "Basic decimal floats":
    let val = literal.float_basic(-100.0, 100.0)
    check val.len > 0
    let parsed = parseFloat(val)
    check parsed >= -100.0 and parsed <= 100.0

  test "Scientific notation":
    let val = literal.float_scientific(-1e10, 1e10)
    let parsed = parseFloat(val)
    check parsed >= -1e10 and parsed <= 1e10

  test "Hex floats":
    let val = literal.float_hex(-100.0, 100.0)
    check val.len > 2
    check val.startsWith("0x") or val.startsWith("0X")
    var parsed :float
    discard parseFloat(val, parsed)
    check parsed >= -100.0 and parsed <= 100.0

  test "Suffixed floats":
    let val = literal.float_suffixed(-100.0, 100.0)
    let parts = val.split('\'')
    check parts.len == 2
    discard parseFloat(parts[0])
    let suffix = parts[1].toLowerAscii
    check suffix in ["f32", "f64", "f", "d"]

  test "Combined float generation":
    var formats = initHashSet[string]()
    for _ in 0..20:
      let val = literal.float(-1e10, 1e10)
      var parsed :float
      discard parseFloat(val.split('\'')[0].replace("_", ""), parsed) # Handle underscores too
      if   val.contains('\'')                : formats.incl("suffixed")
      elif val.toLowerAscii.startsWith("0x") : formats.incl("hex") # Identify as hex
      elif 'e' in val.toLowerAscii           : formats.incl("scientific")
      elif '_' in val                        : formats.incl("underscored") # Add check for underscored decimal
      else                                   : formats.incl("basic")
    check formats.len >= 2
    check "basic" in formats or "scientific" in formats


#_______________________________________
# @section Floats: Compilation
#_____________________________
suite "Float Literal Compilation Tests":
  var testID = 0
  proc compileTest(declarations: seq[string]): bool =
    let testCode = TmplTestCode % [declarations.join("\n")]
    result = base.compileTest("literal", &"floats{testID}.nim", testCode)
    testID.inc

  test "Basic float literals compile":
    var declarations = newSeq[string]()
    for i in 1..5:
      let val = literal.float_basic(-100.0, 100.0)
      declarations.add(&"  let f{i}: float = {val}")
    check compileTest(declarations)

  test "Scientific notation compiles":
    var declarations = newSeq[string]()
    for i in 1..5:
      let val = literal.float_scientific(-1e10, 1e10)
      declarations.add(&"  let f{i}: float = {val}")
    check compileTest(declarations)

  test "Suffixed floats compile":
    var declarations = newSeq[string]()
    for i in 1..5:
      let val = literal.float_suffixed(-100.0, 100.0)
      declarations.add(&"  let f{i} = {val}")
    check compileTest(declarations)

  test "Combined floats compile":
    var declarations = newSeq[string]()
    for i in 1..5:
      let val = literal.float(-1e10, 1e10)
      declarations.add(&"  let f{i}: float = {val}")
    check compileTest(declarations)

  test "Edge cases compile":
    var declarations = newSeq[string]()
    declarations.add("  var f1 = " & literal.float(-1e308, -1e308))  # Near float64.low
    declarations.add("  var f2 = " & literal.float(1e308, 1e308))    # Near float64.high
    declarations.add("  var f3 = " & literal.float(0.0, 0.0))        # Zero
    declarations.add("  var f4 = " & literal.float(-1e-308, 1e-308)) # Very small numbers
    check compileTest(declarations)

