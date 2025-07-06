open Sexplib.Sexp

let string_of_sexp = function Atom s -> s | _ -> ""
let compare_deps a b = String.compare (string_of_sexp a) (string_of_sexp b)

let sort_preprocess_pps = function
  | List (Atom "preprocess" :: [ List (Atom "pps" :: deps) ]) ->
    let sorted_deps = List.sort compare_deps deps in
    List [ Atom "preprocess"; List (Atom "pps" :: sorted_deps) ]
  | other -> other

let sort_libraries_deps = function
  | List (Atom "libraries" :: deps) ->
    let sorted_deps = List.sort compare_deps deps in
    List (Atom "libraries" :: sorted_deps)
  | other -> other

let sort_dune_fields sexp =
  let form_to_reformat = [ "executable"; "library"; "test"; "tests" ] in
  match sexp with
  | List (Atom form_name :: fields)
    when List.exists (String.equal form_name) form_to_reformat ->
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
