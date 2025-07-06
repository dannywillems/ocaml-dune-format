# CLAUDE.md — Contributor Instructions for Claude Code

Welcome, Claude.

You are contributing to `dune-alphafmt`, an OCaml library and CLI tool that
alphabetically sorts top-level S-expression forms in `.dune` files.

Please follow these conventions and constraints.

---

## 🧠 Project Purpose

This tool helps maintain deterministic and readable `dune` files by
sorting specific field contents within dune forms.

It should:
- Parse valid S-expressions (dune format)
- Sort contents of `libraries` and `preprocess` fields alphabetically
- Preserve original order of top-level forms and fields within forms

---

## 🗂 Structure

- `src/` — the core library (`alphafmt.ml`)
- `src/bin/` — CLI entrypoint (`main.ml`)
- `dune-project` — defines the project
- `.ocamlformat` — enforced formatting
- `README.md` — end-user instructions

---

## 🔧 Conventions

- Use OCaml 4.14+
- Use only standard library + `sexplib`
- Expose a clean public API via `format_dune : string -> string`
- All formatting logic lives in `src/`
- CLI should be minimal: no external deps (no `cmdliner`, etc.)
- **Always format output to 80 characters line length**

---

## ✅ Tasks You May Perform

- Refactor `alphafmt.ml` for clarity, purity, or testability
- Add recursive sorting of nested forms (if asked)
- Improve CLI ergonomics (e.g., `--inplace`, `--check`)
- Write clean tests if a `test/` folder is added
- Respect `.ocamlformat`
- Do **not** introduce unnecessary abstractions

---

## ❌ Do Not

- Do not add dependencies without justification
- Do not over-engineer (keep it simple)
- Do not format non-`.dune` files (unless explicitly asked)

---

## ✅ Good Output Example

```lisp
(library ...)
(preprocess ...)
(rule ...)
