#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
# @deps compiler
import "$nim"/compiler/[ ast, idents, lineinfos ]
# @deps nim.gen
import ../../random
import ../ident
import ../shared
import ../expression

#_______________________________________
# @section Variable Generation
#_____________________________
func runtime (
    info    : TLineInfo;
    public  : bool     = false;
    mutable : bool     = true;
    T       : string   = $int;
    count   : Positive = 1;
  ) :PNode=
  # Create let/var declaration node
  let kind = if mutable: nkVarSection else: nkLetSection
  result = newNodeI(kind, info)
  for id in 1..count:
    let identDefs = newNodeI(nkIdentDefs, info)
    identDefs.add(ident.random(info, public))  # Child 0: Name (with export)
    identDefs.add(ident.typ(info, T))          # Child 1: Type
    identDefs.add(expression.random(info, T))  # Child 2: Value
    result.add(identDefs)
#___________________
func comptime (
    info   : TLineInfo;
    public : bool     = false;
    T      : string   = $int;
    count  : Positive = 1;
  ) :PNode=
  # Create const declaration node
  result = newNodeI(nkConstSection, info)
  for id in 1..count:
    let constDef = newNodeI(nkConstDef, info)
    constDef.add(ident.random(info, public))  # Child 0: Name (with export)
    constDef.add(ident.typ(info, T))          # Child 1: Type
    constDef.add(expression.random(info, T))  # Child 2: Value
    result.add constDef


#_______________________________________
# @section Variable Generation: Entry Point
#_____________________________
func random *(
    info    : TLineInfo;
    public  : bool;
    mutable : bool;
    runtime : bool;
    T       : string;
  ) :PNode=
  if runtime : variable.runtime(info, public, mutable, T)
  else       : variable.comptime(info, public, T)
#___________________
func random *(
    info   : TLineInfo;
    public : bool = random.bool();
  ) :PNode= info.random(public, random.bool(), random.bool(), random.typename())

