#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
# @deps std
from std/random as rand import nil
import std/sequtils
# @deps nim.gen
# import ./shared


#_______________________________________
# @section Character Sets
#_____________________________
const Binary          * = {'0','1'}
const Octal           * = chars.Binary + {'2'..'7'}
const Decimal         * = chars.Octal  + {'8'..'9'}
const Hexadecimal     * = chars.Decimal + {'A'..'F', 'a'..'f'}
const Underscore      * = {'_'}
const Minus           * = {'-'}
const Digits          * = chars.Decimal
const Letters         * = {'a'..'z', 'A'..'Z'}
const IdentifierFirst * = chars.Letters + chars.Underscore
const Identifier      * = chars.Letters + chars.Digits + chars.Underscore

#_______________________________________
# @section Random Characters
#_____________________________
proc digit *(underscore :bool = false; notZero :bool = false): string =
  ## Generates a random digit with an optional underscore before it
  #! digit = '0'..'9'
  if underscore: result.add chars.Underscore.toSeq()[0]
  result.add rand.sample(chars.Digits)
#___________________
proc hex *(underscore :bool = false; notZero :bool = false): string =
  ## Generates a random hexadecimal digit with an optional underscore before it
  #! hexdigit = digit | 'A'..'F' | 'a'..'f'
  if underscore: result.add chars.Underscore.toSeq()[0]
  result.add rand.sample(if notZero: chars.Hexadecimal * {'0'} else: chars.Hexadecimal)
#___________________
proc oct *(underscore :bool = false; notZero :bool = false): string =
  ## Generates a random octal digit with an optional underscore before it
  #! octdigit = '0'..'7'
  if underscore: result.add chars.Underscore.toSeq()[0]
  result.add rand.sample(if notZero: chars.Octal * {'0'} else: chars.Octal)
#___________________
proc bin *(underscore :bool = false): string =
  ## Generates a random binary digit with an optional underscore before it
  #! bindigit = '0'..'1'
  if underscore: result.add chars.Underscore.toSeq()[0]
  result.add rand.sample(chars.Binary)
#___________________
proc minus *(guarantee :bool= false; randomize :bool= true) :string=
  ## Generates "-" or ""
  ## it will always return "-" if {@arg guarantee} is true
  #! unary_minus = '-'
  return if not guarantee and randomize and rand.rand(1.0) < 0.5: "" else: $chars.Minus.toSeq()[0]


#_______________________________________
# @section Multi-Character
#_____________________________
proc dec_digits *(count :uint= 1; underscore :bool = false; notZero :bool = false) :string=
  ## Generates a sequence of {@arg count} random decimal digits with an optional underscore before each
  ## Does not add an underscore before the first digit
  #! dec_digits = digit ( ['_'] digit )*
  if count == 0: return ""
  result.add chars.digit(underscore=false, notZero=true)
  for _ in 0..<rand.rand(0'u..count-1): result.add chars.digit(underscore, notZero)
#___________________
proc hex_digits *(count :uint= 1; underscore :bool = false; notZero :bool = false) :string=
  ## Generates a sequence of {@arg count} random hexadecimal digits with an optional underscore before each
  ## Does not add an underscore before the first digit
  #! hex_digits = hexdigit ( ['_'] hexdigit )*
  if count == 0: return ""
  result.add chars.hex(underscore=false, notZero=true)
  for _ in 0..<rand.rand(0'u..count-1): result.add chars.hex(underscore, notZero)
#___________________
proc oct_digits *(count :uint= 1; underscore :bool = false; notZero :bool = false) :string=
  ## Generates a sequence of {@arg count} random octal digits with an optional underscore before each
  ## Does not add an underscore before the first digit
  #! oct_digits = octdigit ( ['_'] octdigit )*
  if count == 0: return ""
  result.add chars.oct(underscore=false, notZero=true)
  for _ in 0..<rand.rand(0'u..count-1): result.add chars.oct(underscore, notZero)
#___________________
proc bin_digits *(count :uint= 1; underscore :bool = false) :string=
  ## Generates a sequence of {@arg count} random binary digits with an optional underscore before each
  ## Does not add an underscore before the first digit
  #! bin_digits = bindigit ( ['_'] bindigit )*
  if count == 0: return ""
  result.add chars.bin(underscore=false)
  for _ in 0..<rand.rand(0'u..count-1): result.add chars.bin(underscore)

