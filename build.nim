#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
import confy
import std/os
import std/strutils


#_______________________________________
# @section Run all UnitTest files
#_____________________________
if dirExists("./bin/.tests"): removeDir("./bin/.tests")
for testFile in os.walkDirRec("./src", yieldFilter= {pcFile}, relative= true):
  if not testFile.endsWith("_test.nim"): continue
  Program.new(testFile, sub="tests").build.run

