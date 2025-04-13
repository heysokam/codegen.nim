#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
# @deps std
import unittest
import os
# @deps nim.gen
from ./gen import nil
import ./tests/base

suite "Compiler Test":
  test "Generated code compiles successfully":
    check compileTest("generator", "generated_code.nim", gen.nim("generated_code.nim"))

