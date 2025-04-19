#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
# @deps compiler
import "$nim"/compiler/[ ast, idents, lineinfos ]
# @deps nim.gen
import ../random as R
import ./shared
import ./chars


#_______________________________________
# @section Identifier Generation: Name
#_____________________________
func name *(length :Positive= 8, underscore :bool= false) :string=
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
  # First character must be a letter (or underscore if allowed)
  let firstCharSet =
    if underscore : chars.IdentifierFirst
    else          : chars.Letters
  result = $R.sample(firstCharSet)

  # Remaining characters can be letters, digits, or underscores
  for i in 1..<max(1, length-1): result.add $R.sample(chars.Identifier)
  if length == 1: return
  result.add $R.sample(firstCharSet + chars.Digits)


#_______________________________________
# @section Identifier Generation: Node
#_____________________________
func typ *(info :TLineInfo; T :typedesc) :PNode=
  ## Generate a random type identifier node
  {.cast(noSideEffect).}: # Access to gIdentCache is safe
    # FIX: Make it random
    let typeIdent = gIdentCache.getIdent($T)
    result = newIdentNode(typeIdent, info)
#___________________
func random *(
    info       : TLineInfo;
    public     : bool     = false;
    length     : Positive = 8;
    underscore : bool     = false
  ) :PNode=
  ## Generate a random identifier node
  {.cast(noSideEffect).}: # Access to gIdentCache is safe
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

