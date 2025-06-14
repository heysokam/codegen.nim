#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
# @deps compiler
import "$nim"/compiler/[ ast, lineinfos ]
# @deps nim.gen
import ./expression/literal
import ../typetools


func random *(
    info : TLineInfo;
    T    : string = $int;
  ) :PNode=
  # FIX: Choose other random expressions
  if   T.isInteger() : return literal.integer(T)
  elif T.isFloat()   : return literal.float(T)
  else               : return literal.random() # Generate random literal expression

