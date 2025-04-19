from std/math import nil
from std/bitops import nil
import std/strutils
import std/sequtils
import std/parseutils
# @deps nim.gen
import ./shared
import ./chars
import ./ident

#_______________________________________
# @section Helper Functions
#_____________________________
# @note These rnd functions do NOT make sense AT ALL. But they work :(
#___________________
proc rnd *(min,max :distinct SomeUnsignedInt) :auto=
  var R = rand.initRand()
  return rand.rand(R, min..max)
#___________________
proc rnd *(min,max :distinct SomeSignedInt) :auto=
  var R = rand.initRand()
  return rand.rand(R, min..max)
#___________________
proc rnd *(min :SomeUnsignedInt, max :SomeSignedInt) :auto=
  var R = rand.initRand()
  return rand.rand(R, min..max)
#___________________
proc rnd *(min :SomeSignedInt, max :SomeUnsignedInt) :auto=
  let realMax = system.min(max, min.high.uint).int
  var R = rand.initRand()
  return rand.rand(R, min..realMax)
#_____________________________
func requiredBits (n :SomeInteger) :uint= return if n == 0: 1 else: bitops.fastLog2(n).uint + 1
#___________________
proc toUnderscore *(S :string; probability :float= 0.5): string=
  ## @descr
  ##  Returns the {@arg S} string with underscores randomly inserted between characters
  ##  It will never add an underscore before the first character
  let start = if S.startsWith("-"): 1 else: 0
  let val   = S[start..^1]
  # Add the minus and the first character
  if start == 1: result.add S[0]
  result.add S[start]
  # Add every other character
  for id in start+1..<val.len:
    if probability < 1.0: rand.randomize()
    if rand.rand(1.0) < probability: result.add '_'
    result.add S[id]
#___________________
proc toUnderscore *(S :string; splitChar :string; probability :float= 0.5): string=
  let parts = S.split(splitChar)
  for id,part in parts:
    if id != 0 and id != parts.len: result.add splitChar
    result.add part.toUnderscore(probability)


#_______________________________________
# @section Base Literal Numbers: Decimal
#_____________________________
##! DEC_LIT = unary_minus? digit ( ['_'] digit )*
#___________________
proc lit_dec_prefix *(negative :bool): string=
  result.add chars.minus(negative)
#___________________
proc lit_dec *(max :distinct SomeInteger; negative :bool; underscore :bool= false) :string=
  result.add lit_dec_prefix(negative)
  result.add chars.dec_digits(requiredBits(max) div 8 + 1, underscore)
#___________________
proc lit_dec *(min,max :distinct SomeInteger; underscore :bool= false) :string=
  let num = $literal.rnd(min,max)
  result.add if underscore: num.toUnderscore() else: num

#_______________________________________
# @section Base Literal Numbers: Hexadecimal
#_____________________________
##! HEX_LIT = unary_minus? '0' ('x' | 'X' ) hexdigit ( ['_'] hexdigit )*
#___________________
proc lit_hex_prefix *(negative :bool): string=
  let upper = rand.rand(1.0) < 0.5
  result.add if negative: $chars.Minus.toSeq()[0] else: ""
  result.add if upper: "0X" else: "0x"
#___________________
proc lit_hex *(max :SomeInteger; negative :bool; underscore :bool= false): string=
  result.add lit_hex_prefix(negative)
  result.add chars.hex_digits(requiredBits(max) div 4 + 1, underscore)
#___________________
proc lit_hex *(min,max :distinct SomeInteger; underscore :bool= false): string=
  result.add lit_hex_prefix(negative= false)
  let num = literal.rnd(min,max).toHex()
  result.add if underscore: num.toUnderscore() else: num

#_______________________________________
# @section Base Literal Numbers: Octal
#_____________________________
##! OCT_LIT = unary_minus? '0' 'o' octdigit ( ['_'] octdigit )*
#___________________
proc lit_oct_prefix *(negative :bool): string=
  result.add if negative: $chars.Minus.toSeq()[0] else: ""
  result.add "0o"
#___________________
proc lit_oct *(max :distinct SomeInteger; negative :bool; underscore :bool= false) :string=
  result.add lit_oct_prefix(negative)
  result.add chars.oct_digits(max.typeof.sizeof*8 div 3 + 1, underscore)
#___________________
proc lit_oct *(min,max :distinct SomeInteger; underscore :bool= false) :string=
  result.add lit_oct_prefix(negative= false)
  let num = literal.rnd(min,max).BiggestInt.toOct(max.typeof.sizeof*8 div 3 + 1)
  result.add if underscore: num.toUnderscore() else: num

#_______________________________________
# @section Base Literal Numbers: Binary
#_____________________________
##! BIN_LIT = unary_minus? '0' ('b' | 'B' ) bindigit ( ['_'] bindigit )*
#___________________
proc lit_bin_prefix *(negative :bool; randomize :bool= false) :string=
  let upper = rand.rand(1.0) < 0.5
  result.add if randomize: chars.minus(negative) else: ""
  result.add if upper: "0B" else: "0b"
#___________________
proc lit_bin *(max :distinct SomeInteger; negative :bool; underscore :bool= false) :string=
  result.add lit_bin_prefix(negative, randomize= true)
  result.add chars.bin_digits(requiredBits(max), underscore)
#___________________
proc lit_bin *(min,max :distinct SomeInteger; underscore :bool= false) :string=
  result.add lit_bin_prefix(negative= false)
  let len = if min < 0: requiredBits(max) else: sizeof(max) * 8
  let num = literal.rnd(min,max).BiggestInt.toBin(len)
  result.add if underscore: num.toUnderscore() else: num


#_______________________________________
# @section Integer.String Generation: Base
#_____________________________
proc int_decimal *(min,max :distinct SomeInteger; underscore :bool= false) :string= lit_dec(min,max, underscore)
  ## @descr Generates a random decimal integer literal string between min and max
proc int_binary *(min,max :distinct SomeInteger; underscore :bool= false) :string= lit_bin(min,max, underscore)
  ## @descr Generates a random binary integer literal string between min and max
proc int_octal *(min,max :distinct SomeInteger; underscore :bool= false) :string= lit_oct(min,max, underscore)
  ## @descr Generates a random octal integer literal string between min and max
proc int_hexadecimal *(min,max :distinct SomeInteger; underscore :bool= false) :string= lit_hex(min,max, underscore)
  ## @descr Generates a random hexadecimal integer literal string between min and max
proc int_any *(min,max :distinct SomeInteger; underscore :bool= false) :string=
  ## @descr
  ##  Generates a random integer literal string between min and max
  ##  Can be decimal, binary, octal, or hexadecimal
  ##  {@arg underscore} will decide if underscores are added to the result
  case rand.rand(0..3)
  of 1 : int_octal(min,max, underscore)
  of 2 : int_hexadecimal(min,max, underscore)
  of 3 : int_binary(min,max, underscore)
  else : int_decimal(min,max, underscore)

#_______________________________________
# @section Integer.String Generation: Formatted
#_____________________________
proc int_underscored*(min,max :distinct SomeInteger) :string= int_decimal(min,max, underscore= true)
  ## Generates a random underscored integer literal string between min and max

#_____________________________
type int_Info = object
  suffix :string
  minVal :int64
  maxVal :uint64
#___________________
# Order matters: From smallest capacity to largest
const orderedTypes = [
  int_Info(suffix:"i8",  minVal:int8.low,  maxVal:int8.high.uint),
  int_Info(suffix:"u8",  minVal:0,         maxVal:uint8.high.uint),
  int_Info(suffix:"i16", minVal:int16.low, maxVal:int16.high.uint),
  int_Info(suffix:"u16", minVal:0,         maxVal:uint16.high.uint),
  int_Info(suffix:"i32", minVal:int32.low, maxVal:int32.high.uint),
  int_Info(suffix:"u32", minVal:0,         maxVal:uint32.high.uint),
  int_Info(suffix:"u",   minVal:0,         maxVal:uint.high.uint),
  int_Info(suffix:"u64", minVal:0,         maxVal:uint64.high.uint),
] #:: orderedTypes
#___________________
# @note Most confusing logic ever made. Don't ever condense this. NOT worth it
proc int_fitsInType*(min,max :distinct SomeSignedInt; info: int_Info): bool =
  ## Checks if the given min/max range fits within the bounds of the info.
  if min < 0 and info.minVal >= 0: return false  # Negative values won't fit in unsigned types
  let realMax = system.min(max.typeof.high.uint, info.maxVal).int
  if min < info.minVal: return false
  if max > realMax: return false
  return true
#___________________
proc int_fitsInType*(min,max :distinct SomeUnsignedInt; info: int_Info): bool =
  ## Checks if the given min/max range fits within the bounds of the info.
  let realMin = info.minVal.uint
  if min >= realMin: return false
  if max > info.maxVal: return false
  return true
#___________________
proc int_fitsInType*(min :SomeUnsignedInt; max :SomeSignedInt; info: int_Info): bool =
  ## Checks if the given min/max range fits within the bounds of the info.
  if min < info.minVal: return false
  if max > info.maxVal: return false
  return true
#___________________
proc int_fitsInType*(min :SomeSignedInt; max :SomeUnsignedInt; info: int_Info): bool =
  ## Checks if the given min/max range fits within the bounds of the info.
  if min < info.minVal: return false
  if max > info.maxVal: return false
  return true

#___________________
proc int_suffixed *(
    min,max    : distinct SomeInteger;
    underscore : bool = false;
    decimal    : bool = true;
    randQuote  : bool = false
  ) :string=
  ## Generates a random integer within [min, max]
  ## Appends the suffix of the *smallest* standard Nim type that can hold the generated value.
  ## @note
  ##  Max limits like `int.low..int.low`, `uint.high..uint.high`, etc
  ##  will resolve to `'u` for uint, not `'u32`/`'u64`. But `'i32`/`'i64` for int
  ##! INT8_LIT   = INT_LIT ['\''] ('i' | 'I') '8'
  ##! INT16_LIT  = INT_LIT ['\''] ('i' | 'I') '16'
  ##! INT32_LIT  = INT_LIT ['\''] ('i' | 'I') '32'
  ##! INT64_LIT  = INT_LIT ['\''] ('i' | 'I') '64'
  ##! UINT_LIT   = INT_LIT ['\''] ('u' | 'U')
  ##! UINT8_LIT  = INT_LIT ['\''] ('u' | 'U') '8'
  ##! UINT16_LIT = INT_LIT ['\''] ('u' | 'U') '16'
  ##! UINT32_LIT = INT_LIT ['\''] ('u' | 'U') '32'
  ##! UINT64_LIT = INT_LIT ['\''] ('u' | 'U') '64'
  # `'i` does not exist in Nim grammar :puzzled:
  #
  # TODO:
  ##! CUSTOM_NUMERIC_SUFFIX = IDENT # Any identifier that is not a pre-defined type suffix.
  ##! CUSTOM_NUMERIC_LIT    = (FLOAT_LIT | INT_LIT) '\'' CUSTOM_NUMERIC_SUFFIX
  let hasQuote = if randQuote: rand.rand(1.0) < 0.5 else: true
  result =
    if decimal : int_decimal(min,max, underscore)
    else       : int_any(min,max, underscore)
  if hasQuote: result.add "'"
  # Find the smallest type suffix for this specific value
  for info in orderedTypes:
    if int_fitsInType(min,max, info):
      result.add info.suffix
      return
  # Fallback to Platform-dependent int/uint  (note: there is no `'i` in Nim's grammar)
  result.add if min < 0: "i" & $(sizeof(int)*8) else: "u"


#_______________________________________
# @section Integer.String Generation: Entry Point
#_____________________________
proc integer *(min,max :distinct SomeInteger) :string=
  ## Generates a random integer literal string
  ##
  ## The generated literal follows Nim's integer literal rules and can be:
  ## * Basic decimal: 42
  ## * Binary: 0b0101
  ## * Octal: 0o377
  ## * Hexadecimal: 0xFF
  ## * With type suffix: 42'i8, 42'u32, etc.
  ## * With underscores: 1_000_000
  ##
  ## Parameters:
  ## * `min`: The minimum value to generate (default: low(int))
  ## * `max`: The maximum value to generate (default: high(int))
  ##
  ## Returns:
  ## * A string containing the value of a valid Nim integer literal
  ##
  let underscore = rand.rand(1.0) < 0.5
  return case rand.rand(4)
  of 1 : int_binary(min,max, underscore)
  of 2 : int_octal(min,max, underscore)
  of 3 : int_hexadecimal(min,max, underscore)
  of 4 : int_suffixed(min,max, underscore)
  else : int_decimal(min,max, underscore)


#_______________________________________
# @section String.String Generation
#_____________________________
proc string_basic*(content :string) :string=
  ## Generates a random string literal
  ##! STR_LIT = '"' CHAR* '"'
  result = '"' & content.multiReplace({ # Escape quotes and backslashes
    "\\": "\\\\",
    "\"": "\\\"",
  }) & '"'
  result = result.replace("\n", "").replace("\r", "")
  if result.endsWith("\\\""): result.add "\""
#___________________
proc string_raw*(content :string) :string=
  ## Generates a random raw string literal
  # RSTR_LIT = 'r' STR_LIT
  # Only quotes need to be escaped in raw strings
  result = "r\"" & content.replace("\"", "\"\"") & "\""
  result = result.replace("\n", "").replace("\r", "")
#___________________
proc string_triple*(content :string) :string=
  ## Generates a random triple-quoted string literal
  # Remove `"` from the start and end to avoid syntax conflicts
  # Triple quoted strings don't need escaping, but avoid triple quotes in content to be safe
  var fixed = content
  if content.startsWith("\"\"\""): fixed = " " & fixed
  if content.endsWith("\"\"\""): fixed = fixed & " "
  fixed = fixed.replace("\"\"\"", "\"\"")
  result = "\"\"\"" & fixed & "\"\"\""
#___________________
proc string_generalized_basic*(content :string; ident :string) :string=
  ## Generates a random generalized string literal
  ##! G_STR_LIT = IDENT STR_LIT
  result = ident & string_basic(content)
#___________________
proc string_generalized_triple*(content :string; ident :string) :string=
  ## Generates a random generalized triple-quoted string literal
  ##! G_TRIPLESTR_LIT = IDENT TRIPLESTR_LIT
  result = ident & string_triple(content)
#___________________
proc string_generalized*(content :string; ident :string) :string=
  ## Generates a random generalized string literal
  ## Can be either a regular or triple-quoted string
  ##! generalizedStr = G_STR_LIT | G_TRIPLESTR_LIT
  case rand.rand(2)
  of 1 : result = string_generalized_triple(content, ident)
  else : result = string_generalized_basic(content, ident)

#_______________________________________
# @section String.String Generation: Entry Point
#_____________________________
proc string *(minLen, maxLen :uint; generalized :bool= true) :string=
  ## Generates a random string literal in one of the following formats:
  ## - Regular string: "hello"
  ## - Raw string: r"hello"
  ## - Triple quoted string: """hello"""
  ##
  ## The length will be between minLen and maxLen inclusive.
  let length = rand.rand(minLen..maxLen)
  var content = newStringOfCap(length)
  for i in 0..<length: content.add rand.rand(32..126).chr  # ASCII printable characters (32-126)
  # Choose random format (regular, raw, or triple-quoted)
  case rand.rand(if generalized: 3 else: 2)
  of 1 : result = string_raw(content)
  of 2 : result = string_triple(content)
  of 3 : result = string_generalized(content, ident.name(rand.rand(1'u..maxLen), rand.rand(1.0) < 0.5))
  else : result = string_basic(content)



#_______________________________________
# @section Float Generation
#_____________________________
##! FLOAT_LIT = unary_minus? dec_digits (('.' dec_digits [exponent]) | exponent)
#___________________
# proc float_digits (count :uint= 1; underscore :bool= false) :string= chars.dec_digits(count, underscore)
#   ## Generates a sequence of {@arg count} random float digits with an optional underscore before each
#   ##! float_digits = dec_digits
#___________________
# proc float_exponent (precision :range[1..int.high]= 1; underscore :bool= false) :string=
#   ## Generates the exponent part of a float literal with the given digits of precision
#   ##! exponent = ('e' | 'E' ) ['+' | '-'] dec_digits
#   let isNegative = rand.rand(1.0) < 0.5
#   let hasSign    = rand.rand(1.0) < 0.5
#   let useUpperE  = rand.rand(1.0) < 0.5
#   result.add if useUpperE: 'E' else: 'e'
#   if hasSign: result.add if isNegative: "-" else: "+"
#   result.add float_digits(precision.uint, underscore)
#___________________
# proc float_base (
#     min,max     : float;
#     underscore  : bool = false;
#     exponential : bool = false;
#   ) :string=
#   ## Generates a float literal between min and max
#   ## Will add an exponent if {@arg exponential} is true
#   ## Will add underscores if {@arg underscore} is true
#   ##! FLOAT_LIT = unary_minus? dec_digits (('.' dec_digits [exponent]) | exponent)
#   let isNegative = min < 0 and rand.rand(1.0) < 0.5
#   let hasFraction = rand.rand(1.0) < 0.5
#   if isNegative: result.add "-"
#   let count = system.max(1'u, abs(max).uint - abs(min).uint)
#   result.add float_digits(count, underscore)
#   if hasFraction: result.add "." & float_digits(16, underscore)
#   if exponential: result.add float_exponent(16, underscore)
#___________________
proc float_base (
    min,max     : float;
    underscore  : bool = false;
    exponential : bool = false;
  ) :string=
  ## Generates a float literal between min and max
  ## Will add an exponent if {@arg exponential} is true
  ## Will add underscores if {@arg underscore} is true
  let num = $rand.rand(min..max)
  result.add if underscore: num.toUnderscore(splitChar=".") else: num
#___________________
proc float_basic*(min,max :float) :string= float_base(min, max, underscore = false, exponential = false)
  ## Generates a basic decimal float literal between min and max
  ##! # FLOAT_BASIC = FLOAT_LIT with exponent and underscore disabled
#___________________
proc float_scientific*(min,max :float) :string= float_base(min, max, underscore = false, exponential = true)
  ## Generates a scientific notation float literal between min and max
  ##! # FLOAT_SCIENTIFIC = FLOAT_LIT with exponent enabled and underscore disabled
#___________________
proc float_hex*(min,max :float) :string=
  ## Generates a hexadecimal float literal between min and max
  ##! FLOAT_LIT_hex = HEX_LIT '\'' (FLOAT32_SUFFIX | FLOAT64_SUFFIX)
  result.add lit_hex(min.toInt, max.toInt, underscore = false)
  # Suffix is mandatory for hex float literals
  result.add "'"
  result.add shared.floatSuffixes[rand.rand(0..6)]
#___________________
proc float_suffixed*(min,max :float) :string=
  ## Generates a 32/64-bit float literal between min and max
  ## Adds a type suffix to the end of the float literal
  ##! FLOAT_LIT_suffixed = FLOAT_LIT '\'' (FLOAT32_SUFFIX | FLOAT64_SUFFIX)
  result = float_basic(min, max)
  result.add "'"
  result.add shared.floatSuffixes[rand.rand(0..6)]
#___________________
proc float_underscored*(min,max :float) :string= float_base(min, max, underscore = true, exponential = false)
  ## Generates an underscored float literal between min and max
  ##! # FLOAT_LIT_underscored = FLOAT_LIT with underscore enabled
#___________________
proc float*(min,max :float) :string=
  ## Generates a random float literal between min and max
  case rand.rand(4)
  of 1 : result = float_underscored(min, max)
  of 2 : result = float_scientific(min, max)
  of 3 : result = float_hex(min, max)
  of 4 : result = float_suffixed(min, max)
  else : result = float_basic(min, max)


