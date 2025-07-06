(lang dune 3.0)

(package
 (name dune-alphafmt)
 (depends ocaml dune sexplib)
 (authors "dannywillems <be.danny.willems@gmail.com>")
 (maintainers "dannywillems <be.danny.willems@gmail.com>")
 (license MIT)
 (homepage "https://github.com/dannywillems/ocaml-dune-format")
 (bug_reports "https://github.com/dannywillems/ocaml-dune-format/issues")
 (synopsis "OCaml library and CLI tool to alphabetically sort dune files")
 (description "A tool that helps maintain deterministic and readable dune files by alphabetically sorting their top-level forms."))

(generate_opam_files true)