# codegen.nim | Random Code Generator for the Nim Programming Language
## Overview
`codegen.nim` is a library for generating random, but syntactically valid, Nim code.  
It provides tools to create random code snippets that follow Nim's grammar rules.  
Useful for testing, fuzzing, and generating random code.  

## Project Goals
1. Generate valid Nim code that compiles correctly
2. Provide control over the generated constructs
3. Support all Nim syntax constructs
4. Randomly generate compilable code

## Use Cases
- Testing tools and libraries
- Fuzz testing
- Stress testing

## Example Usage
```nim
# Generate random identifiers
let varName = ident.random(8)

# Generate random integers
let number = integer(-100, 100)

# Generate random strings
let str = strings(5, 10)
```

## Generation Strategy
1. Grammar-Aware Generation
   - Follows Nim's official grammar rules
   - Ensures syntactic correctness
   - Maintains proper structure

2. Customizable Output
   - Control over generated values
   - Min/max length parameters
   - Format specifications

3. Format Variety
   - Generates all valid literal formats
   - Handles edge cases
   - Includes common patterns

## Current Features
The generator currently supports:
- Integer literals
- String literals
- Identifiers

## Planned Features
- Expression generation
- Statement generation
- Control flow structures
- Type definitions
- Full program generation
- Custom generation rules
- Template/macro generation
- ... _[every other Nim syntax construct]_


## Project Structure
- [src/gen](./src/gen/): Core generation modules
- [src/gen/literal.nim](./src/gen/literal.nim): Literal generators
- [src/gen/ident.nim](./src/gen/ident.nim): Identifier generators
- [tests](./tests/): Tools consumed by all UnitTesting files

## References
- [Nim Manual](https://nim-lang.org/docs/manual.html)
- [grammar.txt](https://github.com/nim-lang/Nim/blob/devel/compiler/grammar.txt) (for syntax rules)
- [Compiler documentation](https://nim-lang.org/docs/nimc.html)

