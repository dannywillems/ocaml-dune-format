# dune-alphafmt

An OCaml library and CLI tool that sorts specific field contents in `.dune` files
for consistent, deterministic formatting.

This tool helps maintain clean and readable dune files by ensuring consistent
ordering of dependencies, making diffs more readable and reducing merge conflicts.

---

## Features

- **Content sorting**: Sorts values within `libraries` and `preprocess` fields
- **Form preservation**: Maintains original order of top-level forms
- **Field preservation**: Maintains original field order within each form
- **Multiple form support**: Handles `library`, `executable`, `test`, and `tests` forms
- **Clean formatting**: Outputs properly formatted S-expressions
- **CLI tool**: Can be used standalone or integrated into build workflows

## Installation

```sh
opam install dune-alphafmt
```

## Usage

### Command Line

```sh
# Format a single dune file
dune-alphafmt dune

# Format and output to stdout
dune-alphafmt path/to/dune-file
```

### Library API

```ocaml
open Dune_alphafmt

let formatted = Alphafmt.format_dune "(library (name mylib) (libraries stdio base))"
(* Result: "(library (name mylib) (libraries base stdio))" *)
```

## Example

**Before:**
```lisp
(rule
 (target foo.txt)
 (deps bar.txt))

(library
 (synopsis "My awesome library")
 (public_name mylib)
 (name mylib)
 (libraries stdio lwt base)
 (modules mylib utils helper)
 (preprocess (pps ppx_jane ppx_base)))

(executable
 (name main)
 (libraries yojson base stdio)
 (modules main))
```

**After:**
```lisp
(rule
 (target foo.txt)
 (deps bar.txt))

(library
 (synopsis "My awesome library")
 (public_name mylib)
 (name mylib)
 (libraries base lwt stdio)
 (modules mylib utils helper)
 (preprocess (pps ppx_base ppx_jane)))

(executable
 (name main)
 (libraries base stdio yojson)
 (modules main))
```

### What Changed

1. **Form order preserved**: Top-level forms stay in original order
2. **Library dependencies sorted**: `stdio lwt base` → `base lwt stdio`
3. **Preprocessor dependencies sorted**: `ppx_jane ppx_base` → `ppx_base ppx_jane`
4. **Field order preserved**: Fields within each form stay in original order

## Integration with dune fmt

This tool is designed to complement `dune fmt --auto-promote` by providing
additional formatting capabilities for dune forms and dependency ordering. You can
use both tools together in your build pipeline for comprehensive dune file
formatting.

## Supported Forms

The tool processes the following dune forms:
- `(library ...)` - OCaml libraries
- `(executable ...)` - Standalone executables
- `(test ...)` - Test executables
- `(tests ...)` - Multiple test executables

Other forms (like `(rule ...)`) are left completely unchanged.
