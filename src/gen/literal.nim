import "$nim"/compiler/[ ast, parser, idents, options, lineinfos, msgs, pathutils, syntaxes ]
from std/random as rand import nil
import std/strutils
import std/strformat
import std/math
import std/bitops
import ./shared


#_______________________________________
# @section Helper Functions
#_____________________________
# @note These rnd functions do NOT make sense AT ALL. But they works :(
#___________________
const TmplDebug = "({$typeof(min)},{$typeof(max)}) | Cannot generate random number in range {min}..{max}"
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
func requiredBits [T: SomeInteger](n :T) :T= return if n == 0: 1 else: bitops.fastLog2(n).T + 1


#_______________________________________
# @section Integer.String Generation
#_____________________________
proc basic*(min,max :distinct SomeInteger) :string= $literal.rnd(min,max)
proc binary*(min,max :distinct SomeInteger) :string= "0b" & literal.rnd(min,max).toBin(requiredBits(max))
proc octal*(min,max :distinct SomeInteger) :string= "0o" & literal.rnd(min,max).toOct(requiredBits(max) div 3 + 1)
proc hexadecimal*(min,max :distinct SomeInteger) :string= "0x" & literal.rnd(min,max).toHex()

#_____________________________
proc toUnderscored*(n: int, probability: float = 0.5): string =
  ## Converts an integer to a string and inserts underscores randomly between digits.
  ## Underscores will not be placed next to each other.
  ##
  ## Args:
  ##   n: The input integer (positive or negative).
  ##   probability: The approximate chance (0.0 to 1.0) of inserting an
  ##                underscore at each valid position (between digits,
  ##                not after another underscore). Defaults to 0.5 (50%).
  ##
  ## Returns:
  ##   A string representation of the number with randomly inserted underscores.
  ##   Returns the original string if it has 0 or 1 characters.
  let number = $n
  if number.len <= 1: return number
  result.add(number[0])  # Start with the first character. Handles negative sign if present.
  for ch in number[1..^1]:  # Iterate through the rest of the characters of the original number string
    let canAdd = result[^1] != '_' and result.len > 1  # Condition 1: The last character added to 'result' must NOT be an underscore.
    let shouldAdd = rand.rand(1.0) < probability       # Condition 2: Random chance based on the provided probability.
    if canAdd and shouldAdd: result.add '_'            # If both conditions are met, add an underscore
    result.add( ch )                                   # Always add the current digit
#___________________
proc underscored*(min,max :distinct SomeInteger; probability: float = 0.5) :string= literal.rnd(min,max).toUnderscored(probability)

#_____________________________
type IntInfo = object
  suffix :string
  minVal :int64
  maxVal :uint64
#___________________
# Order matters: From smallest capacity to largest
const orderedTypes = [
  IntInfo(suffix:"i8",  minVal:int8.low,  maxVal:int8.high.uint),
  IntInfo(suffix:"u8",  minVal:0,         maxVal:uint8.high.uint),
  IntInfo(suffix:"i16", minVal:int16.low, maxVal:int16.high.uint),
  IntInfo(suffix:"u16", minVal:0,         maxVal:uint16.high.uint),
  IntInfo(suffix:"i32", minVal:int32.low, maxVal:int32.high.uint),
  IntInfo(suffix:"u32", minVal:0,         maxVal:uint32.high.uint),
  IntInfo(suffix:"u",   minVal:0,         maxVal:uint.high.uint),
  IntInfo(suffix:"u64", minVal:0,         maxVal:uint64.high.uint),
] #:: orderedTypes
#___________________
# @note Most confusing logic ever made. Don't ever condense this. NOT worth it
proc fitsInType*(min,max :distinct SomeSignedInt; info: IntInfo): bool =
  ## Checks if the given min/max range fits within the bounds of the info.
  if min < 0 and info.minVal >= 0: return false  # Negative values won't fit in unsigned types
  let realMax = system.min(max.high.uint, info.maxVal).int
  if min < info.minVal: return false
  if max > realMax: return false
  return true
#___________________
proc fitsInType*(min,max :distinct SomeUnsignedInt; info: IntInfo): bool =
  ## Checks if the given min/max range fits within the bounds of the info.
  let realMin = info.minVal.uint
  if min >= realMin: return false
  if max > info.maxVal: return false
  return true
#___________________
proc fitsInType*(min :SomeUnsignedInt; max :SomeSignedInt; info: IntInfo): bool =
  ## Checks if the given min/max range fits within the bounds of the info.
  if min < info.minVal: return false
  if max > info.maxVal: return false
  return true
#___________________
proc fitsInType*(min :SomeSignedInt; max :SomeUnsignedInt; info: IntInfo): bool =
  ## Checks if the given min/max range fits within the bounds of the info.
  if min < info.minVal: return false
  if max > info.maxVal: return false
  return true

#___________________
proc suffixed *(min,max :distinct SomeInteger) :string=
  ## Generates a random integer within [min, max]
  ## Appends the suffix of the *smallest* standard Nim type that can hold the generated value.
  ## @note
  ##  Max limits like `int.low..int.low`, `uint.high..uint.high`, etc
  ##  will resolve to `'u` for uint, not `'u32`/`'u64`. But `'i32`/`'i64` for int
  let value = literal.rnd(min,max)
  result.add $value
  result.add "'"
  # Find the smallest type suffix for this specific value
  for info in orderedTypes:
    if fitsInType(min,max, info):
      result.add info.suffix
      return
  # Fallback to Platform-dependent uint
  result.add if min < 0: "i" & $(sizeof(int)*8) else: "u" # `42'i` does not exist in the grammar :puzzled:


#_______________________________________
# @section Integer.String Generation: Entry Point
#_____________________________
proc integer*(min,max :distinct SomeInteger) :string=
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
  return case rand.rand(0..<6)
  of 1 : binary(min,max)
  of 2 : octal(min,max)
  of 3 : hexadecimal(min,max)
  of 4 : suffixed(min,max)
  of 5 : underscored(min,max)
  else : basic(min,max)



#_______________________________________
# @section String.String Generation
#_____________________________
proc string_basic*(content :string) :string=
  result = '"' & content.multiReplace({ # Escape quotes and backslashes
    "\\": "\\\\",
    "\"": "\\\"",
  }) & '"'
  result = result.replace("\n", "").replace("\r", "")
  if result.endsWith("\\\""): result.add "\""
#___________________
proc string_raw*(content :string) :string=
  # In raw strings, only quotes need to be escaped
  result = "r\"" & content.replace("\"", "\"\"") & "\""
  result = result.replace("\n", "").replace("\r", "")
#___________________
proc string_triple*(content :string) :string=
  # Remove `"` from the start and end to avoid syntax conflicts
  # Triple quoted strings don't need escaping, but avoid triple quotes in content to be safe
  var fixed = content
  # if content.len > 0 and content[ 0] == '\"': fixed = "\"" & fixed
  # if content.len > 0 and content[^1] == '\"': fixed = fixed & "\""
  if content.startsWith("\"\"\""): fixed = " " & fixed
  if content.endsWith("\"\"\""): fixed = fixed & " "
  fixed = fixed.replace("\"\"\"", "\"\"")
  result = "\"\"\"" & fixed & "\"\"\""

#_______________________________________
# @section String.String Generation: Entry Point
#_____________________________
proc strings *(minLen, maxLen :uint) :string=
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
  case rand.rand(2)
  of 1 : result = string_raw(content)
  of 2 : result = string_triple(content)
  else : result = string_basic(content)


#_______________________________________
# @section Node Generation
#_____________________________
proc random*(min,max :distinct SomeInteger) :PNode=
  return newIntNode(nkIntLit, parseInt(integer(min, max)))

