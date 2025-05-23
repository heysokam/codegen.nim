#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
import confy
import std/os
import std/strutils

#_______________________________________
# @section CLI Arguments
#_____________________________
# TODO: Change to confy helpers when implemented
let cli = os.commandLineParams()
let all_build    = cli.len == 0
let tests_run    = all_build or (cli.len != 0 and cli[0] == "tests")
let nimgen_build = all_build or (cli.len != 0 and cli[0] == "nimgen")


#_______________________________________
# @section Run all UnitTest files
#_____________________________
if tests_run:
  if dirExists("./bin/.tests"): removeDir("./bin/.tests")
  for testFile in os.walkDirRec("./src", yieldFilter= {pcFile}, relative= true):
    if not testFile.endsWith("_test.nim"): continue
    Program.new(testFile, sub=".tests").build.run

#_______________________________________
# @section Build the nim.gen CLI helper
#_____________________________
if nimgen_build:
  Program.new("nimgen.nim").build

