#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
# @deps compiler
import "$nim"/compiler/[ ast, idents, options, lineinfos, msgs, pathutils ]
# @deps nim.gen
import ../../random as R

#_______________________________________
# @section Node Generation: Entry Point
#_____________________________
func integer *() :PNode= newIntNode(nkIntLit, R.integer(int.low..int.high))
#___________________
func random *() :PNode=
  case R.integer(4)
  # of 1: newStrNode(nkStrLit, literal.string(min, max))  # TODO: Propert String nodes with different kinds
  else: literal.integer()

