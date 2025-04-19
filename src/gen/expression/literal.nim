#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
# @deps std
from std/random as rand import nil
# @deps compiler
import "$nim"/compiler/[ ast, idents, options, lineinfos, msgs, pathutils ]

#_______________________________________
# @section Node Generation: Entry Point
#_____________________________
proc integer *() :PNode= newIntNode(nkIntLit, rand.rand(int.low..int.high))
#___________________
proc random *() :PNode=
  case rand.rand(4)
  # of 1: newStrNode(nkStrLit, literal.string(min, max))  # TODO: Propert String nodes with different kinds
  else: literal.integer()

