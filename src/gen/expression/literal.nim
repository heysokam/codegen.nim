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
func integer *(T :string) :PNode=  newIntNode(T.toNodeKind(), R.integer(int.low..int.high))
  ## @descr Generates a random integer literal node of the given type
#___________________
func float *(T :string) :PNode=  newFloatNode(T.toNodeKind(), R.float(system.float.low..system.float.high))
  ## @descr Generates a random integer literal node of the given type
#___________________
func random *() :PNode=
  case R.integer(4)
  of 0: literal.float(R.float_lit())
  # of 1: newStrNode(nkStrLit, literal.string(min, max))  # TODO: Proper String nodes with different kinds
  else: literal.integer(R.integer_lit())

