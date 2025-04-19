#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
# @deps std
import std/sets
# @deps compiler
import "$nim"/compiler/[ ast, idents, lineinfos ]
# @deps nim.gen
import ../random as R
import ./ident
import ./shared


# Generate a random procedure node
func random*(info: TLineInfo; public :bool= false): PNode =
  {.cast(noSideEffect).}: # Access to gIdentCache is safe
    # 1. Name (Postfix node for export)
    let nameNode = ident.random(info, public) # Create postfix node for name

    # 2. Formal Params
    let randomRetType = R.sample(basicTypes) # Randomly select a return type from basic types only
    let retTypeIdent  = gIdentCache.getIdent(randomRetType)
    let retTypeNode   = newIdentNode(retTypeIdent, info) # Use the random type
    let paramsNode    = newNodeI(nkFormalParams, info)
    paramsNode.add(retTypeNode) # Add return type node as first child

    var lastParamDef: PNode = nil
    var lastParamTypeIdent: PIdent = nil
    var usedParamNames = initHashSet[string]() # Track used names in this scope

    # Parameter Helper Proc
    proc addParam(initialNameLength: int; typeStr: string) =
      # Ensure unique name
      var nameStr = ""
      while true:
        nameStr = ident.name(length=initialNameLength)
        if nameStr notin usedParamNames:
          usedParamNames.incl(nameStr)
          break

      let paramIdent = gIdentCache.getIdent(nameStr)
      let paramNameNode = newIdentNode(paramIdent, info)
      let typeIdent = gIdentCache.getIdent(typeStr)

      # Check if we can group with the previous definition
      if lastParamDef != nil and typeIdent == lastParamTypeIdent:
        # Group: Insert the new name node before the type node in the last definition
        let typeNodeIndex = lastParamDef.len - 2 # Index of type node (before default value)
        lastParamDef.sons.insert(paramNameNode, typeNodeIndex)
      else:
        # Start new group: Create new nkIdentDefs node
        let typeNode = newIdentNode(typeIdent, info)
        let newParamDef = newNodeI(nkIdentDefs, info)
        newParamDef.add(paramNameNode)
        newParamDef.add(typeNode)
        newParamDef.add(newNodeI(nkEmpty, info)) # No default value
        paramsNode.add(newParamDef) # Add new definition to the list
        # Update tracking for next potential grouping
        lastParamDef = newParamDef
        lastParamTypeIdent = typeIdent

    # --- Add Parameters ---
    let numParams = R.integer(0..16) # Generate 0 to 16 parameters
    for i in 0..<numParams:
      let randomType = R.sample(basicTypes)
      let randomLength = R.integer(1..32) # Use length up to 32
      addParam(randomLength, randomType)
    # --- End Parameters ---

    # 3. Body
    let bodyNode = newNodeI(nkStmtList, info)
    let returnNode = newNodeI(nkReturnStmt, info)
    returnNode.add(newNodeI(nkEmpty, info)) # Empty node for the return value
    bodyNode.add(returnNode)

    # 4. Combine into final proc node
    result = newNodeI(nkProcDef, info)
    result.add(nameNode)                 # Child 0: Name (with export)
    result.add(newNodeI(nkEmpty, info))  # Child 1: Generic params (empty)
    result.add(newNodeI(nkEmpty, info))  # Child 2: Signature (empty)
    result.add(paramsNode)               # Child 3: Formal params
    result.add(newNodeI(nkPragma, info)) # Child 4: Pragma (empty)
    result.add(newNodeI(nkEmpty, info))  # Child 5: Reserved (empty)
    result.add(bodyNode)                 # Child 6: Body

