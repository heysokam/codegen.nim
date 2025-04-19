#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
# @deps compiler
import "$nim"/compiler/[ ast, idents, lineinfos ]
# @deps nim.gen
import ./expression/literal

func random *(info :TLineInfo) :PNode=
  # FIX: Choose other random expressions
  return literal.random() # Generate random literal expression

