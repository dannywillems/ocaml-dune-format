open Sexplib.Sexp

let sort_preprocess_pps = function
  | List (Atom "preprocess" :: [ List (Atom "pps" :: deps) ]) ->
    let string_of_sexp = function
      | Atom s -> s
      | _ -> "" (* should not happen for pps dependencies *)
    in
    let compare_deps a b =
      String.compare (string_of_sexp a) (string_of_sexp b)
    in
    let sorted_deps = List.sort compare_deps deps in
    List [ Atom "preprocess"; List (Atom "pps" :: sorted_deps) ]
  | other -> other

let sort_libraries_deps = function
  | List (Atom "libraries" :: deps) ->
    let string_of_sexp = function
      | Atom s -> s
      | _ -> "" (* should not happen for library dependencies *)
    in
    let compare_deps a b =
      String.compare (string_of_sexp a) (string_of_sexp b)
    in
    let sorted_deps = List.sort compare_deps deps in
    List (Atom "libraries" :: sorted_deps)
  | other -> other

let sort_dune_fields sexp =
  match sexp with
  | List (Atom form_name :: fields)
    when form_name = "library" || form_name = "executable" || form_name = "test"
         || form_name = "tests" ->
    let processed_fields =
      List.map
        (fun field -> field |> sort_preprocess_pps |> sort_libraries_deps)
        fields
    in
    List (Atom form_name :: processed_fields)
  | other -> other

let format_dune input =
  let sexps = Sexplib.Sexp.scan_sexps (Lexing.from_string input) in
  let processed = List.map sort_dune_fields sexps in
  String.concat "\n\n"
    (List.map (Sexplib.Sexp.to_string_hum ~indent:1) processed)
