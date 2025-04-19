#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
# @deps std
import std/parseutils
# @deps compiler
import "$nim"/compiler/[ ast, idents, lineinfos ]
# @deps nim.gen
import ./ident
import ./shared
import ./literal

proc random *(info :TLineInfo; public :bool= false) :PNode=
  # 1. Name (Postfix node for export)
  let nameNode = ident.random(info)
  # 2. Type (int)
  let typeNode = ident.typ(info, int)
  # 3. Value (random integer literal)
  let valueNode = literal.node_integer(-1000, 1000) # Generate random integer literal

  # 4. Combine into final variable declaration node
  result = newNodeI(nkVarSection, info)
  let identDefs = newNodeI(nkIdentDefs, info)
  identDefs.add(nameNode)  # Child 0: Name (with export)
  identDefs.add(typeNode)  # Child 1: Type
  identDefs.add(valueNode) # Child 2: Value
  result.add(identDefs)

