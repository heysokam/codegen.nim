#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
# @deps std
from std/random as R import nil
from std/hashes import hash
# @deps nim.gen
import ./typetools

const seed {.strDefine.}= CompileDate & CompileTime
var state = R.initRand(hash(seed))

#_______________________________________
# @section Containers
#_____________________________
func sample *[T](container :T) :auto=
  {.cast(noSideEffect).}:
    return R.sample(state, container)


#_______________________________________
# @section Integers
#_____________________________
func integer *() :SomeInteger=
  {.cast(noSideEffect).}:
    return R.rand(state, int.high)
#___________________
func integer *[T: SomeInteger](H :T) :T=
  {.cast(noSideEffect).}:
    return R.rand(state, H)
#___________________
func integer *[T: SomeInteger](S :Slice[T]) :T=
  {.cast(noSideEffect).}:
    return R.rand(state, S)
#___________________
func integer_lit *() :string=
  return random.sample(typetools.Integers_all)



#_______________________________________
# @section Booleans
#_____________________________
func bool *() :bool= random.integer(1) == 1


#_______________________________________
# @section Floats
#_____________________________
func float *[T: SomeFloat](H :T) :T=
  {.cast(noSideEffect).}:
    return R.rand(state, H)
#___________________
func float *[T: SomeFloat](S :Slice[T]) :T=
  {.cast(noSideEffect).}:
    return R.rand(state, S)
#___________________
func float_lit *() :string=
  return random.sample(typetools.Floats_all)


#_______________________________________
# @section General Typedef
#_____________________________
func typename *() :string=
  case random.integer(3):
  of 1: return random.float_lit()
  # of 2: return $bool
  # of 3: return $string
  else: return random.integer_lit()

