![](icon.jpeg) <br>
![GitHub License](https://img.shields.io/github/license/Devansh-Seth-DEV/LexiC)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/Devansh-Seth-DEV/LexiC)
![OS](https://img.shields.io/badge/OS-Linux-blue?logo=linux&logoColor=white)
![OS](https://img.shields.io/badge/OS-macOS-lightgrey?logo=apple&logoColor=white)

# Lexi C

## Overview

This project is a **Lexical Analyzer for the C Programming Language**.  
It processes C source code **(after removing comments, there should be no comments in the source code before sending the file as input)** and converts it into a structured sequence of tokens, capturing essential information like token type, value, line number, and column number.

The analyzer also generates a detailed **log file** for every analyzed source file, saved automatically inside a `/log` directory.

The project is modular and well-documented using **Doxygen** for easy understanding and maintainability.
You can find the full HTML documentation [here](https://devansh-seth-dev.github.io/LexiC/)

---

## Build and Compile

### `compile.sh` - Automating the Build Process

To streamline the build process, the project includes a `compile.sh` script. This script automates the compilation of source code files and generates an executable for the Lexical Analyzer. It compiles all the `.c` files in the `src/` directory and places the binary output in the `bin/` directory.

### Usage

To use the compile script:

1. Open a terminal.
2. Navigate to the project directory.
3. Run the following command:

```bash
./compile.sh
```

### Troubleshooting 

- Ensure that you have gcc installed on your system.

- If you encounter permission errors, you may need to make the compile.sh script executable with the following command:
```bash
chmod +x compile.sh
```

### Run

To run the LexiC:

```bash
./bin/lexer <source-code-file>
```

```bash
//Example
./bin/lexer example_code.c
```


---

## File I/O (LexerIO)

This module handles **file chunk operations** essential for lexical analysis.

It provides:
- **Reading** C source files (after removing comments) into manageable chunks.
- **Writing** processed tokens and logs into output files.
- **Memory-managed file operations** ensuring binary-safe reads and writes.

### Struct

#### `fchnk_t`
*Container for a storing file chunks.*

| Field | Type    | Description |
|-------|---------|-------------|
| `buff` | `char *` | Buffer containing file content |
| `chksz` | `size_t`  | Size of the data in the buffer |

### Functions

- **`fchnk_t *fchnk_ctor()`**
  <br>Constructor for file chunk objects.

- **`void fchnk_dtor(fchnk_t *chnk)`**
  <br>Destructor for releasing file chunk memory.

- **`fchnk_t *fchnk_ptor(char *const buff, const size_t chksz)`**
  <br>Initializes a file chunk with an existing buffer (ownership transferred).

- **`bool fwrite_fchnk(const char *fname, const fchnk_t *chnk)`**
  <br>Writes a file chunk's content to a file.
 

- **`fchnk_t *get_fchnk(const char *fname)`**
  <br>Reads the full content of a file into a file chunk object (binary-safe).

---

# Lexer Validation

Token validation functions for lexical analysis.

Provides pattern-matching functions that identify:
- Language keywords (e.g., `if`, `while`)
- Operators and punctuation (e.g., `+`, `;`)
- Literals (numeric, string, character)
- Identifiers and preprocessor directives

Used during tokenization to classify raw lexemes into specific token types.  
All functions are case-sensitive and follow standard C syntax rules.

> **Note:**  
> These are pure validation functions — they don't modify input or handle memory allocation.

---

# Lexer
Lexical analyzer components for token processing.

**Complete token handling system for source code analysis**, consisting of:

- Token type classification
- Individual token representation
- Token collection management

**Processing Pipeline:**
1. Classification categorizes lexemes.
2. Structures store the results.
3. Collections manage token sequences.

Includes: `lexer_validation.h`

---

## TokenClassification
**Token type definitions and classification utilities.**

Covers:

- Token categories: preprocessor, symbols, literals.
- Specific token types: keywords, operators, identifiers.
- Type conversion and identification utilities.

### Enums

#### `tokcat_e`
*Token Category Enumeration.*

| Enum Value  | Description |
|-------------|-------------|
| `PRE_PROC`  | Preprocessor directives (`#define`, `#include`) |
| `SYMBOLS`   | Operators and punctuation (`+`, `;`) |
| `LITERAL`   | String/character literals |
| `NFKI_LITERAL` | Numerical literals, floats, keywords, or identifiers |

#### `tok_e`
*Specific Token Type Enumeration.*

| Enum Value  | Description |
|-------------|-------------|
| `KEYWORD`                  | Reserved keywords (`int`, `if`, `return`) |
| `OPERATOR`                 | Operators (`+`, `-`, `*`, `/`, `&&`, `||`) |
| `PUNCTUATION`              | Punctuation characters (`;`, `,`, `()`, `{}`) |
| `NUMERIC_LITERAL`          | Integer numbers (`123`, `456`) |
| `FLOATING_POINT_LITERAL`   | Floating-point numbers (`3.14`) |
| `CHARACTER_LITERAL`        | Character literals (`'a'`) |
| `STRING_LITERAL`           | String literals (`"hello"`) |
| `INVALID_IDENTIFIER`       | Malformed identifiers |
| `IDENTIFIER`               | Valid identifiers (variable/function names) |
| `PRE_PROCESSOR_OPERATOR`   | Preprocessor-related operators |

### Functions

- **`const char *toktyp_rval(tok_e type)`**  
  Returns a human-readable string for a token type.

- **`tok_e get_toktyp(const char *value, tokcat_e type)`**  
  Determines a specific token type based on token string and category.

---

## TokenStructure
**Token instance representation and operations.**

Defines:

- Container structure for tokens.
- Constructors, destructors, and utilities for individual tokens.

### Struct

#### `tok_t`
*Container for a single token.*

| Field | Type    | Description |
|-------|---------|-------------|
| `val` | `char *` | Token string value |
| `typ` | `tok_e`  | Token type |
| `ln`  | `size_t` | Line number (1-indexed) |
| `col` | `size_t` | Column position (1-indexed) |

### Functions

- **`tok_t *tok_ctor()`**
  <br>Allocates a new empty token.

- **`tok_t **tok_nctor(size_t n)`**
  <br>Allocates an array of `n` tokens.

- **`tok_t *tok_ptor(char *value,
                     tok_e type,
                     size_t line,
                     size_t col)`**
  <br>Allocates and initializes a token.

- **`void tok_dtor(tok_t *tok)`**
  <br>Frees a token and its contents.

- **`void printf_tok(const tok_t *tok)`**
  <br>Prints token details to console.

- **`bool fwrite_tok(FILE *fp,
                     const tok_t *tok)`**
  <br>Writes token details to a file.

---

## TokenSet
**Collection of tokens and operations.**

Manages:

- Token arrays
- Set metadata
- Bulk operations on groups of tokens

### Struct

#### `tokset_t`
*Container for multiple tokens.*

| Field | Type       | Description |
|-------|------------|-------------|
| `toks` | `tok_t **` | Dynamic array of token pointers |
| `toksz` | `size_t`   | Number of tokens |

### Functions

- **`tokset_t *tokset_ctor()`**
  <br>Allocates and returns a new token set object.

- **`tokset_t *tokset_ptor(const size_t toksz)`**
  <br>Creates and initializes a token set with a specified number of tokens.

- **`void tokset_dtor(tokset_t *set)`**
  <br>Frees the memory associated with a token set.

- **`size_t cnt_toktyp(const tokset_t *const set,
                       const tok_e type)`**
  <br>Counts the number of tokens of a specific type in a token set.

- **`void printf_tokset(const tokset_t *const set)`**
  <br>Prints the contents of a token set to the standard output.
  
- **`bool fwrite_tokset(FILE *fp,
                        const tokset_t *const set)`**
  <br>Writes the contents of a token set to a file.

---

# Tokenization Core Implementation

The `lexer_tokenize.h` header file implements core functions for the tokenization process in a lexer. It is responsible for converting source code into token streams, counting tokens, and segmenting the code into lexical units. This header file provides the primary functions for handling the tokenization of source code, as well as utilities for managing token sets.

## Functions

- **`size_t tokcnt(const char *const line)`**
  <br>Counts the number of tokens in a given string (or file content).

- **`void toknz_segtoset(tokset_t *const set,
                         const size_t token_index,
                         const char *const line,
                         const size_t start,
                         const size_t end,
                         const size_t line_no,
                         const tokcat_e category,
                         const size_t column)`**
  <br>Tokenizes a segment of a line and stores the resulting token in the token set.

- **`tokset_t *toknz(const char *const line)`**
  <br>Tokenizes a line (or multiple lines of code) into a set of tokens.
