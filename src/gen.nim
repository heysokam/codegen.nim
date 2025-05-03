#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
# @deps compiler
import "$nim"/compiler/[ ast, options, lineinfos, msgs, pathutils ]
from   "$nim"/compiler/renderer import renderTree, renderNoComments, renderNoPragmas
# @deps generator
import ./random
import ./gen/procs
import ./gen/statement/variable

type RootData * = tuple[node :PNode, info :TLineInfo]
proc render *(
    root        : RootData;
    allowBlocks : bool = true;
  ) :string=
  # FIX: Remove const blocks
  renderTree(root.node, {renderNoComments, renderNoPragmas})

proc root *(path :string) :RootData=
  let config  = newConfigRef()
  let absPath = AbsoluteFile(path)
  let info    = newLineInfo(config, absPath, 0, 0)
  let node    = newNodeI(nkStmtList, info)
  return (node:node, info:info)

proc nim *(
    path        : string = "generated.nim";
    allowBlocks : bool   = false;
  ) :string=
  ## @descr Generates random Nim code
  ## @arg allowBlocks (default: false) Will allow generating let/var/const/etc blocks when true.
  let root = gen.root(path)

  # Generate a random amount of TopLevel statements
  for _ in 0..<random.integer(128):
    case random.integer(1):
    of 0: root.node.add variable.random(root.info)
    of 1: root.node.add procs.random(root.info)
    else:discard

  # Convert the AST to a string
  return gen.render(root, allowBlocks)

