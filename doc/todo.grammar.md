# Grammar Generation Todo List
> **Important**:  
> Every task MUST have a corresponding test suite.

## Shared Generator Tools
### Identifiers
- [ ] Basic Identifiers (IDENT)
  - [x] ASCII identifiers
    - [x] First character: letters (a-z, A-Z) or underscore
    - [x] Subsequent characters: letters, digits (0-9), or underscore
  - [ ] Unicode identifiers
    - [ ] Support for Unicode letters in first character
    - [ ] Support for Unicode letters and numbers in subsequent characters
- [ ] Quoted identifiers
- [ ] Tests for each identifier form
  - [x] ASCII identifier tests
  - [ ] Unicode identifier tests
  - [x] Edge cases (minimum/maximum length)
  - [x] Invalid character tests
  - [ ] Quoted identifier tests

## Phase 1: Nim Node Renderer Generator
### Statements
- [x] Variable declarations
  - [x] var
  - [x] let
  - [x] const
  - [ ] Multiple identifiers with same type
  - [ ] Tuple unpacking (varTuple)
- [ ] Procedure declarations
- [ ] Type declarations
- [ ] Control flow
  - [ ] if
  - [ ] when
  - [ ] try
  - [ ] case
  - [ ] for
  - [ ] while

### Expressions
- [ ] Literals
  - [x] Integer
  - [ ] String
  - [ ] Float
  - [ ] Nil
  - [ ] Tests for each literal form
- [ ] Operators
- [ ] Tests for each expression form

## Phase 2: Arbitrary Grammar Generator
- [ ] Literal Expressions
  - [ ] Integer literals
    - [ ] INT_LIT (default int type)
      - [ ] Basic decimal: `42`
      - [ ] Binary: `0b0101`
      - [ ] Octal: `0o377`
      - [ ] Hexadecimal: `0xFF`
      - [ ] Underscores in numbers: `1_000_000`
    - [ ] Typed integers
      - [ ] INT8_LIT: `42'i8`
      - [ ] INT16_LIT: `42'i16`
      - [ ] INT32_LIT: `42'i32`
      - [ ] INT64_LIT: `42'i64`
      - [ ] UINT_LIT: `42'u`
      - [ ] UINT8_LIT: `42'u8`
      - [ ] UINT16_LIT: `42'u16`
      - [ ] UINT32_LIT: `42'u32`
      - [ ] UINT64_LIT: `42'u64`
    - [ ] Tests
      - [ ] Range validation for each type
      - [ ] All base representations
      - [ ] Invalid literal detection
  - [ ] String literals
    - [ ] Basic string literals
    - [ ] Raw string literals
    - [ ] Triple-quoted string literals
    - [ ] Tests for each string literal form
  - [ ] Float literals
    - [ ] FLOAT_LIT (default float type)
    - [ ] FLOAT32_LIT: `42.0'f32`
    - [ ] FLOAT64_LIT: `42.0'f64`
    - [ ] Tests for each float literal form

## Old Generator Plan
### Phase 2: Basic Procedures
- [ ] Empty proc declarations
  ```nim
  proc simple() = discard
  ```
- [x] Procs with basic parameters
  ```nim
  proc withParams(x: int) = discard
  ```
- [x] Procs with return types
  ```nim
  proc withReturn(): int = 42
  ```
- [ ] Tests for basic procedures

### Phase 3: Extended Symbols and Expressions
- [ ] symbol
  - [ ] Basic symbols in declarations
    ```nim
    var normalIdent = 42
    var `quoted ident` = 42
    ```
  - [ ] Symbols in proc declarations
    ```nim
    proc `+`(a, b: int): int = a + b
    proc `quoted name`() = discard
    ```
  - [ ] Tests for symbols

- [ ] Extended expressions
  - [ ] operator expressions
    ```nim
    const x = 1 + 2 * 3
    ```
  - [ ] addr expressions
    ```nim
    var x = 42
    var y = addr x
    ```
  - [ ] Tests for expressions

### Phase 4: Control Flow
- [ ] if expressions
  ```nim
  if true:
    echo "true"
  ```
- [ ] when expressions
  ```nim
  when defined(windows):
    echo "windows"
  ```
- [ ] case expressions
  ```nim
  case 42
  of 0: echo "zero"
  else: echo "other"
  ```
- [ ] Tests for control flow

### Phase 5: Complex Declarations
- [ ] type declarations
  ```nim
  type
    MyType = object
      field: int
  ```
- [ ] generic procedures
  ```nim
  proc generic[T](x: T) = discard
  ```
- [ ] iterator declarations
  ```nim
  iterator items[T](x: seq[T]): T =
    for i in x:
      yield i
  ```
- [ ] Tests for complex declarations

### Phase 6: Advanced Features
- [ ] templates
  ```nim
  template twice(x: untyped) =
    x
    x
  ```
- [ ] macros
  ```nim
  macro m(x: untyped): untyped =
    x
  ```
- [ ] pragmas
  ```nim
  {.push raises: [].}
  proc nothrow() = discard
  {.pop.}
  ```
- [ ] Tests for advanced features

### Integration Testing
- [ ] Combinations of features
  ```nim
  type
    MyObj = object
      field: int
  
  proc `$`(x: MyObj): string =
    "MyObj(" & $x.field & ")"
  
  iterator items(x: MyObj): int =
    yield x.field
  
  when isMainModule:
    var obj = MyObj(field: 42)
    echo obj
  ```
- [ ] Complex programs
- [ ] Edge cases
- [ ] Compiler validation
