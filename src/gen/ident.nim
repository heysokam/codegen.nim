#:______________________________________________________________________
#  nim.gen  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
from std/random as rand import nil
import ./shared

# Generate a random identifier name
proc random*(length: Positive= 8, allowUnderscore: bool = false): string =
  ## Generates a random valid Nim identifier.
  ##
  ## The generated identifier follows Nim's identifier rules:
  ## * First character is a letter (or underscore if `allowUnderscore` is true)
  ## * Subsequent characters can be letters, digits, or underscores
  ## * Total length will be `length` characters (minimum 1)
  ##
  ## Parameters:
  ## * `length`: The desired length of the identifier (default: 8)
  ## * `allowUnderscore`: Whether to allow underscore as first character (default: false)
  ##
  ## Returns:
  ## * A string containing a valid Nim identifier
  ##
  runnableExamples:
    let id1 = ident.random()         # e.g. "xKt5m2Pq"
    let id2 = ident.random(3)        # e.g. "abc"
    let id3 = ident.random(2, true)  # e.g. "_x"

  # First character must be a letter (or underscore if allowed)
  let firstCharSet =
    if allowUnderscore : shared.identFirstChars
    else               : shared.Letters
  result = $rand.sample(firstCharSet)

  # Remaining characters can be letters, digits, or underscores
  for i in 1..<max(1, length-1): result.add $rand.sample(shared.identChars)
  if length == 1: return
  result.add $rand.sample(firstCharSet + shared.Digits)

