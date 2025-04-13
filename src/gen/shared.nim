#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
# @deps compiler
import "$nim"/compiler/[ idents ]

# Shared resources for the generator
var gIdentCache *{.threadvar.}: IdentCache
gIdentCache = newIdentCache()

  # Define the list of type names for Nim
const basicTypes * = [
  # Integers
  "int", "int8", "int16", "int32", "int64",
  "uint", "uint8", "uint16", "uint32", "uint64",
  # Floats
  "float", "float32", "float64",
  # Other primitives
  "bool", "char", "string", "cstring", "pointer", "void",
  # C-compatible types
  "cint", "cuint", "clong", "culong", "clonglong", "culonglong",
  "cchar", "cschar", "cshort", "cushort",
  "cfloat", "cdouble", "clongdouble",
  # Additional basic types
  "byte", "Natural", "Positive"
]

# Complex types that need type parameters - not used yet
const complexTypes * = [
  "seq", "array", "openArray",
  "tuple", "set", "ref", "ptr"
]

# Constants for identifier generation
const Letters         * = {'a'..'z', 'A'..'Z'}
const Digits          * = {'0'..'9'}
const identFirstChars * = shared.Letters + {'_'} # Use set union with char literal
const identChars      * = shared.Letters + shared.Digits + {'_'}

