#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
# @deps std
import unittest, os, strutils, strformat
# @deps compiler
import "$nim"/compiler/[ options, lineinfos, msgs, pathutils, ast ]
from   "$nim"/compiler/renderer import renderTree, renderNoComments, renderNoPragmas
# @deps nim.gen
import ./variable
# @deps nim.gen.tests
import ../../tests/base

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

  test "Var declarations":
    var declarations = newSeq[string]()
    let config  = newConfigRef()
    let absPath = AbsoluteFile("test.nim")
    for id in 1..100:
      let varNode = variable.random(newLineInfo(config, absPath, id, 0), mutable=true, runtime=true, public=false)
      declarations.add("  " & varNode.renderTree({renderNoComments, renderNoPragmas}).replace("\n", "\n  "))  # Add indentation for proper formatting
    check compileTest(declarations)

  test "Let declarations":
    var declarations = newSeq[string]()
    let config  = newConfigRef()
    let absPath = AbsoluteFile("test.nim")
    for id in 1..100:
      let varNode = variable.random(newLineInfo(config, absPath, id, 0), mutable=false, runtime=true, public=false)
      declarations.add("  " & varNode.renderTree({renderNoComments, renderNoPragmas}).replace("\n", "\n  "))  # Add indentation for proper formatting
    check compileTest(declarations)

  test "Const declarations":
    var declarations = newSeq[string]()
    let config  = newConfigRef()
    let absPath = AbsoluteFile("test.nim")
    for id in 1..100:
      let varNode = variable.random(newLineInfo(config, absPath, id, 0), mutable=false, runtime=false, public=false)
      declarations.add("  " & varNode.renderTree({renderNoComments, renderNoPragmas}).replace("\n", "\n  "))  # Add indentation for proper formatting
    check compileTest(declarations)

