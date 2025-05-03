#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
from std/random as R import nil
from std/hashes import hash

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

