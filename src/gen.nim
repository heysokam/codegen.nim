#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
# @deps compiler
import "$nim"/compiler/[ ast, parser, idents, options, lineinfos, msgs, pathutils, syntaxes ]
from   "$nim"/compiler/renderer import renderTree, renderNoComments, renderNoPragmas

# Import the modules
import gen/procs

proc root *(path :string) :tuple[node: PNode, info: TLineInfo]=
  let config  = newConfigRef()
  let absPath = AbsoluteFile(path)
  let info    = newLineInfo(config, absPath, 0, 0)
  let node    = newNodeI(nkStmtList, info)
  return (node:node, info:info)

proc nim *(path: string = "generated.nim"): string =
  ## Main function to generate random Nim code
  let root = gen.root(path)

  # Generate a random procedure
  root.node.add procs.random(root.info)

  # Convert the AST to a string
  return renderTree(root.node, {renderNoComments, renderNoPragmas})

