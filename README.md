# dune-alphafmt

An OCaml library and CLI tool that extends `dune fmt` functionality by
alphabetically sorting fields within `library` definitions in `.dune` files.

This tool helps maintain clean and deterministic dune files by ensuring library
fields are consistently ordered, making diffs more readable and reducing merge
conflicts.

---

## Features

- **Library field sorting**: Alphabetically sorts fields within `(library ...)`
  definitions
- **Preserves structure**: Maintains the original order of top-level forms
  (rules, executables, etc.)
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

let formatted = Alphafmt.format_dune "(library (name mylib) (libraries base))"
(* Result: "(library (libraries base) (name mylib))" *)
```

## Example

**Before:**
```lisp
(library
 (synopsis "My awesome library")
 (public_name mylib)
 (name mylib)
 (libraries base stdio lwt)
 (modules mylib utils helper)
 (preprocess (pps ppx_deriving.show)))
```

**After:**
```lisp
(library
 (libraries base stdio lwt)
 (modules mylib utils helper)
 (name mylib)
 (preprocess (pps ppx_deriving.show))
 (public_name mylib)
 (synopsis "My awesome library"))
```

## Integration with dune fmt

This tool is designed to complement `dune fmt --auto-promote` by providing
additional formatting capabilities specifically for library definitions. You can
use both tools together in your build pipeline for comprehensive dune file
formatting.
