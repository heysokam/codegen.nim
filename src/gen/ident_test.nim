#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
import unittest, os, strutils, strformat
import ../tests/base
import ../gen/ident

const TmplTestCode = """
# Generated test code - testing identifier validity
proc testIdentifiers() =
$1

when isMainModule:
  testIdentifiers()
"""

suite "Identifier Generation Tests":
  let testCacheDir = "bin/.tests/nimcache/ident"
  if not dirExists(testCacheDir): createDir(testCacheDir)

  var testID = 0
  proc compileTest(declarations: seq[string]): bool =
    let testCode = TmplTestCode % [declarations.join("\n")]
    result = base.compileTest("ident", &"identifiers{testID}.nim", testCode)
    testID.inc

  test "Basic valid identifiers":
    var declarations = newSeq[string]()
    for i in 1..100:
      let identifier = ident.random(8)
      declarations.add("  var " & identifier & " = " & $i)
    check compileTest(declarations)

  test "Edge case lengths":
    var declarations = newSeq[string]()
    for length in [1, 2, 100, 1000]:
      let identifier = ident.random(length)
      declarations.add("  var " & identifier & " = " & $length)
    check compileTest(declarations)

  test "Underscore handling: Valid":
    var declarations = newSeq[string]()
    # Test without underscore
    for i in 51..100:
      let identifier = ident.random(8, false)
      declarations.add("  var " & identifier & " = " & $(i + 50))
    check compileTest(declarations)

  test "Underscore handling: Invalid":
    var declarations = newSeq[string]()
    # Test with underscore allowed
    for i in 1..50:
      let identifier = ident.random(8, true)
      declarations.add("  var " & identifier & " = " & $i)
    check compileTest(declarations)
    # Add invalid underscore cases
    declarations = newSeq[string]()
    declarations.add("  var " & "_" & " = 1")
    declarations.add("  var " & "__" & " = 2")
    declarations.add("  var " & "___" & " = 3")
    declarations.add("  var " & "_a_" & " = 4")
    declarations.add("  var " & "__b__" & " = 5")
    declarations.add("  var " & "___c___" & " = 6")
    check not compileTest(declarations)

