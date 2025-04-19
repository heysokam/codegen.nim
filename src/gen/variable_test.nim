#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
# @deps std
import unittest, os, strutils, strformat
# @deps compiler
import "$nim"/compiler/[ options, lineinfos, msgs, pathutils, ast ]
from   "$nim"/compiler/renderer import renderTree, renderNoComments, renderNoPragmas
# @deps nim.gen
import ../gen/variable
# @deps nim.gen.tests
import ../tests/base

const TmplTestCode = """
# Generated test code - testing variable declarations
proc testVariables()=
$1

when isMainModule:
  testVariables()
"""

suite "Variable Generation Tests":
  let testCacheDir = "bin/.tests/variable"
  if not dirExists(testCacheDir): createDir(testCacheDir)

  var testID = 0
  proc compileTest(declarations: seq[string]): bool =
    let testCode = TmplTestCode % [declarations.join("\n")]
    result = base.compileTest("variable", &"variables{testID}.nim", testCode)
    testID.inc

  test "Variable declarations":
    var declarations = newSeq[string]()
    let config  = newConfigRef()
    let absPath = AbsoluteFile("test.nim")
    for id in 1..100:
      let varNode = variable.random(newLineInfo(config, absPath, 1, id))
      declarations.add("  " & varNode.renderTree({renderNoComments, renderNoPragmas}))  # Add indentation for proper formatting
    check compileTest(declarations)

  # test "Variables with different integer ranges":
  #   var declarations = newSeq[string]()
  #   let config  = newConfigRef()
  #   let absPath = AbsoluteFile("test.nim")
  #   # Test variables with different ranges of values
  #   let ranges = [
  #     (-128, 127),      # int8 range
  #     (0, 255),         # uint8 range
  #     (-32768, 32767),  # int16 range
  #     (0, 65535),       # uint16 range
  #     (-2147483648, 2147483647)  # int32 range
  #   ]
  #   for id,val in ranges.pairs:
  #     let varNode = variable.random(newLineInfo(config, absPath, 1, id))
  #     declarations.add("  " & varNode.renderTree({renderNoComments, renderNoPragmas}))  # Add indentation for proper formatting
  #   check compileTest(declarations)

  # test "Edge cases":
  #   var declarations = newSeq[string]()
  #   # Test extreme values and special cases
  #   for id in 1..10:
  #     let varNode = variable.random(newLineInfo("test.nim", 1, id))
  #     declarations.add("  " & $varNode)
  #   check compileTest(declarations)

  # test "Export syntax":
  #   var declarations = newSeq[string]()
  #   # Verify that export operator (*) is properly handled
  #   for id in 1..20:
  #     let varNode = variable.random(newLineInfo("test.nim", 1, id))
  #     let nodeStr = $varNode
  #     check "*" in nodeStr  # Verify export operator is present
  #     declarations.add("  " & nodeStr)
  #   check compileTest(declarations)

