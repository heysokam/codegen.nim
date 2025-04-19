# Grammar Generation Todo List

## Phase 1: Minimal Compilable Units
- [ ] Basic Identifiers (IDENT)
  - [x] ASCII identifiers
    - [x] First character: letters (a-z, A-Z) or underscore
    - [x] Subsequent characters: letters, digits (0-9), or underscore
  - [ ] Unicode identifiers
    - [ ] Support for Unicode letters in first character
    - [ ] Support for Unicode letters and numbers in subsequent characters
  - [ ] Tests
    - [x] ASCII identifier tests
    - [ ] Unicode identifier tests
    - [x] Edge cases (minimum/maximum length)
    - [x] Invalid character tests

- [ ] Simple Expressions
  - [x] Integer literals
    - [x] INT_LIT (default int type)
      - [x] Basic decimal: `42`
      - [x] Binary: `0b0101`
      - [x] Octal: `0o377`
      - [x] Hexadecimal: `0xFF`
      - [x] Underscores in numbers: `1_000_000`
    - [x] Typed integers
      - [x] INT8_LIT: `42'i8`
      - [x] INT16_LIT: `42'i16`
      - [x] INT32_LIT: `42'i32`
      - [x] INT64_LIT: `42'i64`
      - [x] UINT_LIT: `42'u`
      - [x] UINT8_LIT: `42'u8`
      - [x] UINT16_LIT: `42'u16`
      - [x] UINT32_LIT: `42'u32`
      - [x] UINT64_LIT: `42'u64`
    - [x] Tests
      - [x] Range validation for each type
      - [x] All base representations
      - [x] Invalid literal detection
  - [x] String literals
    - [x] Basic string literals
    - [x] Raw string literals
    - [x] Triple-quoted string literals
    - [x] Tests for each string literal form
  - [x] Float literals
    - [x] FLOAT_LIT (default float type)
    - [x] FLOAT32_LIT: `42.0'f32`
    - [x] FLOAT64_LIT: `42.0'f64`
    - [x] Tests for each float literal form
- [ ] Variable Statements
  - [ ] Single identifier declarations
    ```nim
    var x = 42
    ```
  - [ ] Multiple identifiers with same type
    ```nim
    var x, y: int = 42
    ```
  - [ ] Tuple unpacking (varTuple)
    ```nim
    var (x, y) = (1, 2)
    ```
  - [ ] Tests for each variable declaration form

## Phase 2: Basic Procedures
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

## Phase 3: Extended Symbols and Expressions
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

## Phase 4: Control Flow
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

## Phase 5: Complex Declarations
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

## Phase 6: Advanced Features
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

## Integration Testing
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
