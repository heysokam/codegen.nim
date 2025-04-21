
## minim | Language Features
<!-- buildsystem and outputs -->
- Compilation to C
- Compilation to Zig
<!-- design philosophy -->
- Support for manual memory management
- Procedural programming support
<!-- grammar -->
- Python-inspired syntax
- Indentation-significant syntax
- Variables
  - `var`   : Runtime mutable
  - `let`   : Runtime immutable
  - `const` : Comptime immutable


## Not in Nim
- Literals
  - unions

## Nim Language Features (not in minim)
### TODO
- Variables
  - Tuple unpacking in assignments/declarations

<!-- function calls -->
- Function/Operator overloading
- User-defined operators
- Call Syntax ergonomics
  - Uniform Function Call Syntax (UFCS)

<!-- typesystem -->
- Literals
  - integers
  - booleans
  - characters
  - enums
  - bitsets
  - arrays
  - sequences
  - strings
  - Subrange
- `type` declarations
- Generics (parametric polymorphism)
- Algebraic Data Types (Sum types) via object variants
- Procedure types (first-class functions)
- Distinct types (for strong type safety, e.g., preventing unit errors)
- Floating-point types
- Enumeration types
- Set types (type-safe bitsets)
- String types (`string` and `cstring`)
- Structured types (tuples, objects)
- Array types (fixed-size)
- Sequence types (dynamic size)
- Open arrays (flexible parameter type for array-like structures)
- Tuple types (heterogeneous fixed-size collections)
- Object types (records/structs, support for inheritance)
- Object construction syntax
- Reference types (`ref`) and Pointer types (`ptr`)

<!-- comptime -->
- Compile-time execution
  - `static` blocks
  - `when` statement

<!-- branching -->
- Zero-overhead iterators
  - `iterator` statement
  - `yield` statement
- `if`/`elif`/`else` statements and expressions
- `when` statements and expressions (compile-time conditional compilation)
- `case` statements and expressions (pattern matching on values/ranges)
- `for` loops with iterators, ranges (`..`, `..<`), `items`, `pairs`
- `while` loops
- `block` statements with labels
- `break` and `continue` loop control (label support for `break`)
- `return` statement
- `defer` statement (ensures execution before scope exit)

<!-- paradigms -->
- Functional programming support (iterators, first-class functions, closures)
- Object-Oriented Programming support (inheritance, methods)

<!-- buildsystem -->
- Builtin Cross-compilation support
- Native dependency-free executables

<!-- sem -->
- Strong type system
- Static typing
<!-- far -->
- Metaprogramming capabilities
  - Templates for code generation
  - Abstract Syntax Tree (AST) based macros
  - Term rewriting macros
  - Compile-time code generation

### Not in minim
- Compilation to C++
- Compilation to JavaScript
- Optional LLVM backend
- Foreign Function Interface (FFI) for C, C++, Objective-C, JavaScript
  _minim IS the target language. It does not need ffi_
- Type inference
- Identifier equality (case and underscore insensitive)
- Automatic Memory management:
  - Deterministic ARC/ORC (Automatic Reference Counting with cycle collector), destructors, move semantics
  - Optional traditional Garbage Collection modes
- Object-Oriented Programming support (inheritance, methods)
- Unchecked arrays
- Traced and untraced pointer distinctions
- Async/await syntax for asynchronous operations

---
- Special `_` identifier for discarding values
- Procedures (`proc`) and Functions (`func`)
- Modules for code organization
- Package management via Nimble (`.nimble` files, git/mercurial distribution)
- `import`, `export`, `include` statements for modularity
- Selective imports (`from module import symbol`)
- Visibility control (`*` export marker)
- Pragmas (`{. .}`) for compiler directives and annotations
- Custom annotations via macro pragmas
- Method call syntax (`obj.method(args)` as sugar for `method(obj, args)`)
- Properties (via overloading `[]`, `[]=` etc.)
- Dynamic dispatch / Multi-methods
- Type conversions (explicit)
- Type casting (`cast`)
- `addr` operator (get memory address)
- `unsafeAddr` operator
- Bitwise operators
- Helpful runtime error tracebacks
- Single-line comments (`#`)
- Documentation comments (`##`)
- Multi-line, nestable comments (`#[ ]#`)
- String literals (double-quoted, escape sequences)
- Triple-quoted string literals (multi-line, raw)
- Raw string literals (`r"..."`)
- Character literals (single-quoted)
- Numeric literals (integer, float, hex `0x`, binary `0b`, octal `0o`)
- Underscores in numeric literals for readability (`1_000`)
- `discard` statement (to explicitly ignore results)
- `asm` statement (inline assembler)
- `void` type (denotes absence of value, for parameters/return types)
- `typedesc` type (represents types themselves)
- `static[T]` type parameter (compile-time value parameter)
- `typeof` operator
- Concepts (advanced type classes, experimental)
- Strict `not nil` checking (experimental)
- View types / Borrowing (`lent T`, experimental)
- Out parameters (`out T`, experimental)
- Overloadable enums (experimental)
- Strict funcs (experimental purity checking)
- Self-contained compiler (written in Nim)
- Extensive standard library (IO, OS interaction, networking, data structures, algorithms, math, regex, JSON, etc.)
<!-- multi-threading -->
- Message passing support (for concurrency)
- Parallel statement (experimental)
<!-- effects -->
- Exception handling (`try`, `except`, `finally`, `raise`)
- Custom exceptions (object-based)
- Exception tracking (`{.raises.}` pragma)
- Effects system (tracking side effects, GC safety, tags)
---
- Static typing
- Type inference
- Garbage collection (default, but configurable)
- Manual memory management options
- Procedural, object-oriented, and functional programming paradigms
- Compile-time execution (when statements/blocks)
- Metaprogramming via templates and macros
- Generics
- Tuples and objects (records)
- Distinct types
- Algebraic data types (object variants)
- Pattern matching (case statements)
- Destructuring assignments
- First-class functions
- Closures
- Lambda expressions (anonymous procedures)
- Iterators (inline and closure)
- Exception handling
- Defer statements
- Modules and imports
- Public/private visibility qualifiers
- Operator overloading
- Custom operators
- Method call syntax (foo.bar() and bar(foo))
- Uniform call syntax
- Pragmas for compiler directives
- Explicit mutability via 'var' parameters
- Forward declarations
- Named and optional parameters
- Varargs (variable number of arguments)
- Type conversion operators
- Multi-methods
- Symbol binding via backticks
- C/C++/JavaScript/Objective-C interoperability
- Compile-time reflection
- Concept-based polymorphism (type classes)
- User-defined type conversions
- Block expressions
- Array and sequence types
- Sets
- Tables (hash maps)
- Documentation comments
- Export markers
- Type sections
- Constants
- Enum types
- Bit fields
- Pointer types
- Reference types
- Threads and thread-local variables
- Atomic operations
- Async/await for asynchronous programming
- Effect system (experimental)
- Distinct operator overloads
- Result type for error handling
- Converters
- Static[T] for compile-time only types
- C++ destructors support through hooks
- Compile-time type information (RTTI)
- Integer literals with type suffixes
- Discard statements
- Ternary operator (`if` expressions)
- Case expressions
- Parallel and spawn for parallel programming
- Shallow and deep copying semantics
- Implicit returns
- Lifetime tracking (experimental)
- Strict funcs (side-effect free functions)
- Docgen and RST support
- Package management with Nimble
- Source code filters
- Dynamic dispatch
- Static modifier (compile-time execution)
- Typed vs untyped parameters in macros
- Bind statements
- Include statements
- Mixin statements
- Using statements
- Implicit type conversions (where safe)
- Ranges and slice syntax
- Break and continue statements
- Attribute pragmas
- User-defined pragmas
- Destructors (for manual memory management)
- Custom allocators
- Raw string literals
- Unicode support
- First-class enums
- Memory regions (experimental)
- Hint and warning pragmas
- Debug pragmas
- Optimization pragmas
- Computed goto and computed case statements
- Type classes
- Multi-line string literals
- Dollar operator (stringification)
- Automatic dereferencing
---
- Significant indentation
- Nested expressions
- Arithmetic and logical operators with multiple precedence levels (`OP0`–`OP10`)
- User-defined operators (inferred from symbolic `operator` rules)
- Unary operators (`not`, `-`, `notin`, `isnot`, `addr`)
- Binary operators including:
  - Arithmetic (`+`, `-`, `*`, `/`, `div`, `mod`)
  - Bitwise (`shl`, `shr`, `and`, `or`, `xor`, `not`)
  - Comparison (`==`, `!=`, `<`, `<=`, `>`, `>=`)
  - Membership (`in`, `notin`, `of`)
  - Identity (`is`, `isnot`)
  - Range (`..`)
- Chained operator expressions (via precedence levels)
- Dot access (`.`) for field access, method calls, module scoping
- Optional dot access prefixes like `type`, `addr`
- Symbol quoting using backticks (`\`symbol\``)
- Literals as symbols (quoted operator/function names)
- Qualified identifiers (e.g., `foo.bar.baz`)
- Function call syntax (`f(x, y=2)`)
- Optional argument syntax (`x=2`)
- Named arguments
- Expression sequences and lists (e.g., `expr, expr`)
- Statements ending in `;` or newline
- Tuple construction and unpacking (via `expr : expr`)
- Tuple types and destructuring (implied from `tupleConstr`)
- Set and table constructors (`{x, y}`, `{k: v}`)
- Array indexing (`x[i]`)
- Multi-dimensional indexing
- Array slicing (`a[1..3]`)
- Procedure definitions (`proc foo(x: int): int = ...`)
- Iterator definitions (`iterator foo(): int = ...`)
- Template definitions (`template foo(): int = ...`)
- Macro definitions (`macro foo(): int = ...`)
- Lambda expressions (`proc(x: int): int => x + 1`)
- Control flow constructs:
  - `if`, `elif`, `else`
  - `case`, `of`, `else`
  - `for`, `in`, `while`
  - `break`, `continue`
  - `try`, `except`, `finally`, `raise`
  - `defer`
  - `return`, `yield`
- Block expressions (`block:`)
- Cast expressions (`cast[T](x)`)
- Type introspection/casting (`typeof`, `type`, `is`, `isnot`)
- Object types and inheritance (`object of Parent`)
- Case objects and case statements with enum-like matching
- Inline assembly (`asm "..."`)
- Static evaluation (`static:` block or `static[T]`)
- Compile-time function evaluation (`when`, `const`, `static`)
- Conditional compilation (`when`, `elif`, `else`)
- Macros and term rewriting constructs (from `macro`, `quote`, `unquote`)
- Pattern matching in macros (using `quote do:` and identifiers)
- Generic procedures and types (`proc foo[T](x: T): T`)
- Constraints in generics (`T: SomeConstraint`)
- Concepts and type classes (via grammar of type constraints)
- Multiple assignment / destructuring (`let (a, b) = ...`)
- Range types (`0..10`)
- Set types (`set[Color]`)
- Type declarations and aliases (`type MyInt = int`)
- Variable declarations (`var`, `let`, `const`)
- Parameter direction (`var x`, `out x`)
- Borrow checking support (`lent`, `var`, `ref`, `ptr`)
- View types (`lent`, `var`, `ref`)
- Procedural types (`proc(x: int): int`)
- Distinct types (`distinct int`)
- Object variants (`case kind: T of ...`)
- Converter declarations (`converter toInt(x: string): int`)
- Method and multi-dispatch support (`method`)
- Mixins and symbol injection (`mixin`, `bind`, `import`)
- Module system with `import`, `from`, `include`
- Exporting and visibility control (`export`, `public`)
- Threading support (`spawn`, `parallel`)
- Expression blocks with last-expression-as-return (`result = ...`)
- Alias expressions (`x as y`)
- Error handling with `try`, `except`, `finally`, `raise`
- Out parameters (`proc foo(out x: int)`)
- Automatic destructors and memory management via scoping
- Custom pragmas (`{.pragma.}`) and effects tracking
- Custom overload resolution with `using`, `template`, `macro`
- Foreign function interface keywords (`cdecl`, `importc`, `dynlib`)
- Assembly embedding (`asm`)
- Annotations on types and declarations (`{.inline.}`, `{.noSideEffect.}`)
---


## Roadmap
> @note Each stage builds on the previous, so it can be used+tested at every step.

### 1. Minimal Expressions & Statements
**Goal:** Arithmetic, assignment, and basic output.
- Literals: integers, floats, strings, booleans, nil
- Identifiers and assignment (`let`/`var`/`const`)
- Arithmetic operators: `+`, `-`, `*`, `/`
- Parentheses for grouping
- Simple statements: assignment, expression, output (e.g., `echo` or `print`)
- Comments

**Grammar focus:**  
- `simpleExpr`, `expr`, `literal`, `identOrLiteral`, `let`, `var`, `const`, `exprStmt`, `simpleStmt`

### 2. Control Flow
**Goal:** Make the language Turing-complete.
- `if` expressions/statements
- `while` loops
- `block` statements
- `return` statement

**Grammar focus:**  
- `ifStmt`, `ifExpr`, `whileStmt`, `blockStmt`, `returnStmt`, `stmt`

### 3. Functions & Procedures
**Goal:** User-defined routines.
- Function/procedure definitions (`proc`, `func`)
- Parameters and return types
- Function calls
- Scoping rules

**Grammar focus:**  
- `routineExpr`, `routine`, `paramList`, `paramListColon`, `routineType`, `primarySuffix`, `expr`

### 4. Composite Types
**Goal:** Enable structured data.
- Tuples
- Arrays
- Objects (records/structs)
- Type declarations (`type`)

**Grammar focus:**  
- `tupleType`, `tupleDecl`, `arrayConstr`, `objectDecl`, `typeDef`, `typeDesc`, `section(typeDef)`

### 5. Modules & Imports
**Goal:** Code organization.
- `import` and `export` statements
- Module boundaries

**Grammar focus:**  
- `importStmt`, `exportStmt`, `fromStmt`, `module`

### 6. Advanced Expressions & Operators
**Goal:** More expressive code.
- Logical operators: `and`, `or`, `not`
- Comparison operators: `==`, `!=`, `<`, `>`, `<=`, `>=`
- Operator precedence
- Slices and ranges

**Grammar focus:**  
- `operator`, `cmpExpr`, `andExpr`, `orExpr`, `sliceExpr`, `range`, `operatorB`

### 7. Error Handling
**Goal:** Robust programs.
- `try`/`except`/`finally` blocks
- `raise` statement

**Grammar focus:**  
- `tryStmt`, `tryExpr`, `raiseStmt`

### 8. Iteration & Collections
**Goal:** More powerful loops.
- `for` loops
- Iterators
- Sets, tables (dictionaries)

**Grammar focus:**  
- `forStmt`, `forExpr`, `iterator`, `setOrTableConstr`

### 9. Pragmas, Macros, and Advanced Features
**Goal:** Metaprogramming and customization.
- Pragmas (`{. ... .}`)
- Macros, templates, mixins, converters

**Grammar focus:**  
- `pragma`, `macro`, `template`, `mixinStmt`, `converter`, `pragmaStmt`

### 10. Full Language Coverage
**Goal:** Complete Nim grammar support.
- All remaining constructs: `case`, `when`, `defer`, `asm`, `concept`, etc.
- Full error reporting, type inference, generics, etc.



