import unittest, strutils, strformat, sets, parseUtils, math, os
from std/random as rand import nil
import ../tests/base
import ./literal

suite "Integer Literal Generation Tests":
  test "Decimal":
    let val = basic(10, 10)
    check val == "10"

    let val2 = basic(-5, -5)
    check val2 == "-5"

    # Test range
    for _ in 0..200:
      os.sleep(1)
      rand.randomize()
      let val = parseInt(basic(10, 20))
      check val >= 10 and val <= 20

  test "Binary":
    var parsed :int= int.high
    let val = binary(10, 10)
    check val.startsWith("0b")
    discard parseBin(val, parsed)
    check parsed == 10

    # Test negative numbers
    let val2 = binary(-5, -5)
    check val2.startsWith("0b")
    discard parseBin(val2, parsed)
    check parsed == -5

    # Test range
    for _ in 0..200:
      os.sleep(1)
      rand.randomize()
      let val = binary(10, 20)
      check val.startsWith("0b")
      discard parseBin(val, parsed)
      check parsed >= 10 and parsed <= 20

  test "Octal":
    var parsed :int= int.high
    let val = octal(10, 10)
    check val.startsWith("0o")
    discard parseOct(val, parsed)
    check parsed == 10

    # Test negative numbers
    let val2 = octal(-5, -5)
    check val2.startsWith("0o")
    discard parseOct(val2, parsed)
    check parsed == -5

    # Test range
    for _ in 0..200:
      os.sleep(1)
      rand.randomize()
      let val = octal(10, 20)
      check val.startsWith("0o")
      discard parseOct(val, parsed)
      check parsed >= 10 and parsed <= 20

  test "Hexadecimal":
    var parsed :int= int.high
    let val = hexadecimal(10, 10)
    check val.startsWith("0x")
    discard parseHex(val, parsed)
    check parsed == 10

    # Test negative numbers
    let val2 = hexadecimal(-5, -5)
    check val2.startsWith("0x")
    discard parseHex(val2, parsed)
    check parsed == -5

    # Test range
    for _ in 0..200:
      os.sleep(1)
      rand.randomize()
      let val = hexadecimal(10, 20)
      check val.startsWith("0x")
      discard parseHex(val, parsed)
      check parsed >= 10 and parsed <= 20

  test "Underscored":
    # Test single digit
    check underscored(5, 5) == "5"
    check underscored(-5, -5) == "-5"

    # Test multiple digits
    let val = underscored(1000, 1000, 1.0)
    check '_' in val
    check parseInt(val) == 1000

    # Test no consecutive underscores
    for _ in 0..200:
      os.sleep(1)
      rand.randomize()
      let val = underscored(10000, 99999, 1.0)
      check "__" notin val
      check val[^1] != '_'                   # No underscore at end
      if val[0] == '-' : check val[1] != '_' # No underscore after minus
      else             : check val[0] != '_' # No underscore at start

  test "Suffixed":
    # Test fixed values with different suffixes
    check suffixed(42, 42).endsWith("'i8")  # 42 fits in i8
    check suffixed(200, 200).endsWith("'u8")  # 200 fits in u8 but not i8
    check suffixed(-200, -200).endsWith("'i16")  # -200 needs i16 or larger

    # Test range constraints
    check suffixed(0, 255).endsWith("'u8")  # Should fit in u8
    check suffixed(-128, 127).endsWith("'i8")  # Should fit in i8
    check suffixed(256, 256).endsWith("'i16")  # Too big for u8
    check suffixed(-32768, -32768).endsWith("'i16")  # Needs i16
    check suffixed(0, 65535).endsWith("'u16")  # Needs u16

    # Test very large numbers
    let big = suffixed(uint.high, uint.high)
    check big.endsWith("'u")

    # Test very small numbers
    let small = suffixed(int.low, int.low)
    check small.endsWith("'i" & $(sizeof(int)*8))

    # Test that generated numbers are within bounds
    for _ in 0..200:
      os.sleep(1)
      rand.randomize()
      let val = suffixed(-150, 150)
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
      let val = integer(10, 20)
      var num: int
      if   val.startsWith("0b") : discard parseBin(val, num)
      elif val.startsWith("0o") : discard parseOct(val, num)
      elif val.startsWith("0x") : discard parseHex(val, num)
      elif '_' in val           : num = parseInt(val.replace("_", ""))
      elif '\'' in val          : num = parseInt(val[0..<val.find('\'')])
      else                      : num = parseInt(val)
      check num >= 10 and num <= 20

    # Test all possible formats are generated
    var formats = initHashSet[string]()
    for _ in 0..200:
      os.sleep(1)
      rand.randomize()
      let val = integer(int.low, uint.high)
      if   val.startsWith("0b") : formats.incl("binary")
      elif val.startsWith("0o") : formats.incl("octal")
      elif val.startsWith("0x") : formats.incl("hexadecimal")
      elif '_' in val           : formats.incl("underscored")
      elif '\'' in val          : formats.incl("suffixed")
      else                      : formats.incl("basic")

    # We should see all formats
    check formats.len >= 4
    check "binary" in formats
    check "octal" in formats
    check "hexadecimal" in formats
    check "basic" in formats
    check "underscored" in formats
    check "suffixed" in formats


const TmplTestCode = """
# Generated test code - testing integer literal validity
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
      let lit = basic(i, i)
      declarations.add("  var x" & $i & " = " & lit)
    check compileTest(declarations)

  test "Binary literals compile":
    var declarations = newSeq[string]()
    for i in 1..50:
      let lit = binary(i, i)
      declarations.add("  var x" & $i & " = " & lit)
    check compileTest(declarations)

  test "Octal literals compile":
    var declarations = newSeq[string]()
    for i in 1..50:
      let lit = octal(i, i)
      declarations.add("  var x" & $i & " = " & lit)
    check compileTest(declarations)

  test "Hexadecimal literals compile":
    var declarations = newSeq[string]()
    for i in 1..50:
      let lit = hexadecimal(i, i)
      declarations.add("  var x" & $i & " = " & lit)
    check compileTest(declarations)

  test "Underscored literals compile":
    var declarations = newSeq[string]()
    for i in [100, 1000, 10000, 100000]:
      let lit = underscored(i, i, 1.0)
      declarations.add("  var x" & $i & " = " & lit)
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
    for i, (min, max) in ranges:
      let lit = suffixed(min, max)
      declarations.add("  var x" & $i & " = " & lit)
    check compileTest(declarations)

  test "Combined literals compile":
    var declarations = newSeq[string]()
    # Test a mix of all formats
    for i in 1..50:
      let lit = integer(-100, 100)
      declarations.add("  var x" & $i & " = " & lit)
    check compileTest(declarations)

  test "Edge cases compile":
    var declarations = newSeq[string]()
    # Test extreme values
    declarations.add("  var x1 = " & suffixed(int.low, int.low))
    declarations.add("  var x2 = " & suffixed(int.high, int.high))
    declarations.add("  var x3 = " & suffixed(uint.high, uint.high))
    declarations.add("  var x4 = " & binary(-1, -1))
    declarations.add("  var x5 = " & octal(-1, -1))
    declarations.add("  var x6 = " & hexadecimal(-1, -1))
    check compileTest(declarations)


suite "String Literal Generation Tests":
  test "Basic string literals":
    # Test regular quoted strings
    let val = string_basic("hello")
    check val == "\"hello\""

    # Test escaping
    check string_basic("\"quotes\"") == "\"\\\"quotes\\\"\""
    check string_basic("back\\slash") == "\"back\\\\slash\""

    # Test empty string
    check string_basic("") == "\"\""

  test "Raw string literals":
    # Test raw strings
    let val = string_raw("hello")
    check val == "r\"hello\""

    # Test escaping (only quotes need escaping in raw strings)
    check string_raw("\"quotes\"") == "r\"\"\"quotes\"\"\""
    check string_raw("back\\slash") == "r\"back\\slash\""

    # Test empty string
    check string_raw("") == "r\"\""

  test "Triple quoted string literals":
    # Test triple quoted strings
    let val = string_triple("hello")
    check val == "\"\"\"hello\"\"\""

    # Test that triple quotes in content are handled
    check string_triple("\"\"\"dangerous\"\"\"") == "\"\"\" \"\"dangerous\"\" \"\"\""

    # Test empty string
    check string_triple("") == "\"\"\"\"\"\""

  test "Combined string generation":
    # Test that all formats are generated
    var formats = initHashSet[string]()
    for _ in 0..100:
      let val = strings(5, 10)
      if   val.startsWith("r\"")    : formats.incl("raw")
      elif val.startsWith("\"\"\"") : formats.incl("triple")
      else                          : formats.incl("basic")

    # We should see all formats
    check formats.len == 3
    check "raw" in formats
    check "triple" in formats
    check "basic" in formats


suite "String Literal Compilation Tests":
  var testID = 0
  proc compileTest(declarations: seq[string]): bool =
    let testCode = TmplTestCode % [declarations.join("\n")]
    result = base.compileTest("literal", &"strings{testID}.nim", testCode)
    testID.inc

  test "Basic string literals compile":
    var declarations = newSeq[string]()
    for i in 1..50:
      let lit = string_basic("test" & $i)
      declarations.add("  var s" & $i & " = " & lit)
    check compileTest(declarations)

  test "Raw string literals compile":
    var declarations = newSeq[string]()
    for i in 1..50:
      let lit = string_raw("test" & $i)
      declarations.add("  var s" & $i & " = " & lit)
    check compileTest(declarations)

  test "Triple quoted string literals compile":
    var declarations = newSeq[string]()
    for i in 1..50:
      let lit = string_triple("test" & $i)
      declarations.add("  var s" & $i & " = " & lit)
    check compileTest(declarations)

  test "Combined string literals compile":
    var declarations = newSeq[string]()
    # Test a mix of all formats
    for i in 1..50:
      let lit = strings(0, 20)
      declarations.add("  var s" & $i & " = " & lit)
    check compileTest(declarations)

  test "Edge cases compile":
    var declarations = newSeq[string]()
    # Test empty strings
    declarations.add("  var s1 = " & strings(0, 0))
    # Test strings with special characters
    declarations.add("  var s2 = " & string_basic("\"\\\n\t\""))
    declarations.add("  var s3 = " & string_raw("\"\""))
    declarations.add("  var s4 = " & string_triple("\"\"\"\n\t"))
    # Test long strings
    declarations.add("  var s5 = " & strings(100, 100))
    check compileTest(declarations)

