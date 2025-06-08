#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
# @deps compiler
import "$nim"/compiler/[ ast ]

#_______________________________________
# @section Integers
#_____________________________
const Integers_signed_nim   * = @[ $int,    $int8,   $int16,      $int32,      $int64                        ]
const Integers_unsigned_nim * = @[ $uint,   $uint8,  $uint16,     $uint32,     $uint64                       ]
const Integers_signed_C     * = @[ $cchar,  $cschar, $cint,       $clong,      $clonglong, $cshort, $csize_t ]
const Integers_unsigned_C   * = @[ $cuint,  $culong, $culonglong, $cushort                                   ]
const Integers_signed_all   * = Integers_signed_nim   & Integers_signed_C
const Integers_unsigned_all * = Integers_unsigned_nim & Integers_unsigned_C
const Integers_nim          * = Integers_signed_nim   & Integers_unsigned_nim
const Integers_C            * = Integers_signed_C     & Integers_unsigned_C
const Integers_all          * = Integers_signed_nim   & Integers_unsigned_nim & Integers_signed_C & Integers_unsigned_C
#_____________________________
func isInteger_signed   *(T :string) :bool= T in Integers_signed_all
func isInteger_unsigned *(T :string) :bool= T in Integers_unsigned_all
func isInteger_nim      *(T :string) :bool= T in Integers_nim
func isInteger_C        *(T :string) :bool= T in Integers_C
func isInteger          *(T :string) :bool= T in Integers_all


#_______________________________________
# @section Floats
#_____________________________
const Floats_nim * = @[ $float,  $float32, $float64 ]
const Floats_C   * = @[ $cfloat, $cdouble           ]
const Floats_all * = Floats_nim & Floats_C
#_____________________________
func isFloat_nim *(T :string) :bool= T in Floats_nim
func isFloat_C   *(T :string) :bool= T in Floats_C
func isFloat     *(T :string) :bool= T in Floats_all


#_______________________________________
# @section Conversion
#_____________________________
func toNodeKind *(T :string) :TNodeKind= result = case T
  # Signed Int
  of "int"     : nkIntLit
  of "int8"    : nkInt8Lit
  of "int16"   : nkInt16Lit
  of "int32"   : nkInt32Lit
  of "int64"   : nkInt64Lit
  of Integers_signed_C: nkIntLit
  # Unsigned Int
  of "uint"    : nkUIntLit
  of "uint8"   : nkUInt8Lit
  of "uint16"  : nkUInt16Lit
  of "uint32"  : nkUInt32Lit
  of "uint64"  : nkUInt64Lit
  of Integers_unsigned_C: nkUIntLit
  # Floats
  of "float"   : nkFloatLit
  of "float32" : nkFloat32Lit
  of "float64" : nkFloat64Lit
  of Floats_C  : nkFloatLit
  else: doAssert false, "unreachable"; nkEmpty

