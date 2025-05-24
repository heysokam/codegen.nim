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

func integer *() :SomeInteger=
  {.cast(noSideEffect).}:
    return R.rand(state, int.high)

func integer *[T: SomeInteger](H :T) :T=
  {.cast(noSideEffect).}:
    return R.rand(state, H)

func integer *[T: SomeInteger](S :Slice[T]) :T=
  {.cast(noSideEffect).}:
    return R.rand(state, S)

func bool *() :bool= random.integer(1) == 1

func float *[T: SomeFloat](H :T) :T=
  {.cast(noSideEffect).}:
    return R.rand(state, H)

func float *[T: SomeFloat](S :Slice[T]) :T=
  {.cast(noSideEffect).}:
    return R.rand(state, S)

func sample *[T](container :T) :auto=
  {.cast(noSideEffect).}:
    return R.sample(state, container)

func integer_lit *() :string=
  return random.sample(typetools.Integers_all)

func float_lit *() :string=
  return random.sample(typetools.Floats_all)

func typename *() :string=
  case random.integer(1):
  of 0: return random.integer_lit()
  of 1: return random.float_lit()
  else:discard # unreachable

