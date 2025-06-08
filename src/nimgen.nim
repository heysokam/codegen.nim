#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
# @deps std
from std/os import nil
# @deps nim.gen
import ./gen


#_______________________________________
# @section nim.gen Entry Point
#_____________________________
proc run=
  let args   = os.commandLineParams()
  doAssert args.len in {2,3}
  let choice = args[0]
  let file   = args[1]
  let dir    = os.splitFile(file).dir
  # let seed   = if args.len > 2: args[2] else: random.integer().toHex()
  # Validate Arguments
  doAssert choice in ["all", "variable", "proc"]
  doAssert not os.fileExists(file)
  let code = case choice # FIX: Pass allowBlocks option from cli
  of "variable" : gen.variable()
  of "proc"     : gen.procs()
  else          : gen.nim()
  if not os.dirExists(dir): os.createDir dir
  file.writeFile(code)
  echo code
#___________________
when isMainModule: run()

