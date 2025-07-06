open Sexplib.Sexp

let compare_by_first_atom a b =
  let atom_of = function
    | List (Atom hd :: _) -> hd
    | Atom a -> a
    | List [] -> "" (* empty list, rare in dune files *)
    | List (List _ :: _) -> "" (* nested lists start with list, not atom *)
  in
  String.compare (atom_of a) (atom_of b)

let sort_preprocess_pps = function
  | List (Atom "preprocess" :: [List (Atom "pps" :: deps)]) ->
      let string_of_sexp = function
        | Atom s -> s
        | _ -> "" (* should not happen for pps dependencies *)
      in
      let compare_deps a b = String.compare (string_of_sexp a) (string_of_sexp b) in
      let sorted_deps = List.sort compare_deps deps in
      List [Atom "preprocess"; List (Atom "pps" :: sorted_deps)]
  | other -> other

let sort_library_fields sexp =
  match sexp with
  | List (Atom "library" :: fields) ->
      let sorted_fields = List.sort compare_by_first_atom fields in
      let processed_fields = List.map sort_preprocess_pps sorted_fields in
      List (Atom "library" :: processed_fields)
  | other -> other

let format_dune input =
  let sexps = Sexplib.Sexp.scan_sexps (Lexing.from_string input) in
  let processed = List.map sort_library_fields sexps in
  String.concat "\n\n" (List.map (Sexplib.Sexp.to_string_hum ~indent:1) processed)
