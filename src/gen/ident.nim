#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
# @deps std
from std/random as rand import nil
# @deps compiler
import "$nim"/compiler/[ ast, idents, lineinfos ]
# @deps nim.gen
import ./shared
import ./chars


#_______________________________________
# @section Identifier Generation: Name
#_____________________________
proc name *(length :Positive= 8, underscore :bool= false) :string=
  ## Generates a random valid Nim identifier name
  ##
  ## The generated identifier follows Nim's identifier rules:
  ## * First character is a letter (or underscore if `underscore` is true)
  ## * Subsequent characters can be letters, digits, or underscores
  ## * Total length will be `length` characters (minimum 1)
  ##
  ## Parameters:
  ## * `length`: The desired length of the identifier (default: 8)
  ## * `underscore`: Whether to allow underscore as first character (default: false)
  ##
  ## Returns:
  ## * A string containing a valid Nim identifier
  ##
  #! IDENTIFIER = letter ( ['_'] (letter | digit) )*
  runnableExamples:
    let id1 = ident.random()         # e.g. "xKt5m2Pq"
    let id2 = ident.random(3)        # e.g. "abc"
    let id3 = ident.random(2, true)  # e.g. "_x"

  # First character must be a letter (or underscore if allowed)
  let firstCharSet =
    if underscore : chars.IdentifierFirst
    else          : chars.Letters
  result = $rand.sample(firstCharSet)

  # Remaining characters can be letters, digits, or underscores
  for i in 1..<max(1, length-1): result.add $rand.sample(chars.Identifier)
  if length == 1: return
  result.add $rand.sample(firstCharSet + chars.Digits)


#_______________________________________
# @section Identifier Generation: Node
#_____________________________
proc typ *(info :TLineInfo; T :typedesc) :PNode=
  ## Generate a random type identifier node
  # FIX: Make it random
  let typeIdent = gIdentCache.getIdent($T)
  result = newIdentNode(typeIdent, info)
#___________________
proc random *(
    info       : TLineInfo;
    public     : bool     = false;
    length     : Positive = 8;
    underscore : bool     = false
  ) :PNode=
  ## Generate a random identifier node
  # 1. Name
  let name_str   = ident.name(length, underscore) # Generate random proc name
  let name_ident = gIdentCache.getIdent(name_str)
  let name_node  = newIdentNode(name_ident, info)
  if not public: return name_node

  # 2. Postfix node for export
  let pub_ident = gIdentCache.getIdent("*") # Identifier for the export operator
  let pub_node  = newIdentNode(pub_ident, info)

  result = newNodeI(nkPostfix, info) # Create postfix node for name
  # Match parser order: operator first, then identifier
  result.add(pub_node)  # Child 0: Operator Ident (*)
  result.add(name_node) # Child 1: Base Ident (randomName)

