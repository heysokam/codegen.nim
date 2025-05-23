#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
# @deps compiler
import "$nim"/compiler/[ ast ]
# @deps nim.gen
import ../../random as R
import ../../typetools


#_______________________________________
# @section Node Generation: Entry Point
#_____________________________
func integer *(T :string) :PNode=
  ## @descr Generates a random integer literal node of the given type
  let kind = T.toNodeKind()
  if   T.isInteger_signed()   : return newIntNode(kind, R.integer(int.low..int.high))
  elif T.isInteger_unsigned() : return newIntNode(kind, R.integer(uint.low..uint.high).BiggestInt)
#___________________
func random *() :PNode=
  case R.integer(4)
  # of 1: newStrNode(nkStrLit, literal.string(min, max))  # TODO: Propert String nodes with different kinds
  else: literal.integer(R.integer_lit())

