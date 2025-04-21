# Minimalist Feature Set
## Essential Operations
- Read a value
- Write a value
- Perform a basic calculation
- Compare values
- Jump to a different instruction

## Foundation
### Summary
The foundation of Turing completeness in an imperative language:
- Ability to read/store state
- Minimal operations to modify state
- Minimal operations to check conditions
- Ability to make decisions based on state
- Ability to loop/repeat actions based on the state

Therefore, the absolute minimal language needs:
- One literal type (int or float)
- Variables/assignment
- Minimal operators
- `if/else`
- `while`

With these you can write any algorithm, even if it's verbose.
Everything else is convenience or abstraction.

### 1. Literal Value (int)
Ability to represent data
_Without literal values, you can't represent input or constants_
```ni
0
```

### 2. State (variables/assignment)
Ability to store state
_Without state storage, you can't remember computation results_
```nim
var x = 0   # Variable declaration with assignment
```

### 3. Assignment and basic arithmetic (+ and -)
Ability to modify state
_Without state modification, you can't progress in calculations_
```nim
x = x + 1   # Increment
x = x - 1   # Decrement
```

### 4. Operations to check conditions (== and !=)
Ability to make decisions based on that state
_Without condition checking, you can't control program flow_
```nim
x == 0
y != 0
```

### 5. Conditional Execution (if statements)
Ability to branch based on current state
_Without branching, you can't make decisions_
```nim
if x == 0:
  # code block
```

### 6. Looping Construct (while)
Ability to loop/repeat actions based on the state
_Without loops, you can't handle arbitrary computations_
```nim
while x != 0:
  # code block
```

### 7. Unbounded Memory (arrays)
Ability to handle arbitrarily large problems
_Without (conceptually) unbounded memory access, you can't handle arbitrarily large computations_
```nim
var arr: array[int, int]  # Unbounded array (conceptually)
arr[x] = y                # Store value
y = arr[x]                # Retrieve value
```

### Notes
#### int/float literals
For an MVP, supporting just one (e.g., integers) is enough for most logic and control flow.  
Floats are only essential if you need fractional math early on.

#### Operators vs. Function Calls
- Conceptually, operations are the fundamental building blocks.
  _(function calls are less fundamental, but the are also operations)_
- With function calls, you can express operators as builtin functions (e.g., `add(a, b)` instead of `a + b`).  
- With operators but not functions, you lose abstraction and code reuse.  

#### Functions
Not strictly necessary for Turing-completeness (can use repetition), but they make code more manageable.  
User-defined functions can be added later on.

#### Control Flow (while vs. if/else vs. switch vs for)
- `if/else` is the most fundamental. Needed for any conditional logic.  
- `while` is required for Turing-completeness (unbounded repetition).  
- `switch`/`case` is just an abstraction over `if`; not strictly necessary.  
- `for` is an abstraction over `while`, and not strictly necessary.  

#### Other Optional Features
##### Basic I/O
Some way to see output (e.g., `print` or `echo`).
##### Comments
For code clarity. Not necessary for execution.
##### Scoping
For ergonomics, to avoid name clashes.

