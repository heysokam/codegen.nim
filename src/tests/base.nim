#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
# @deps std
import os

proc compileTest *(
    subDir   : string;
    fileName : string;
    code     : string;
  ) :bool=
  let testsDir = "bin/.tests"/subDir # Explicit tests dir for this test
  let cacheDir = testsDir/"nimcache" # Explicit cache dir for this test
  let filePath = os.joinPath(testsDir, fileName) # Path inside tests dir
  # Cleanup previous run artifacts before the test
  if not dirExists(cacheDir) : createDir(cacheDir)
  if fileExists(filePath)    : removeFile(filePath)
  # Compile the generated code
  writeFile(filePath, code)
  let command  = "./bin/.nim/bin/nim check --hints:off --warnings:off --nimcache:" & cacheDir & " " & filePath
  return os.execShellCmd(command) == 0

