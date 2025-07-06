let () =
  if Array.length Sys.argv <> 2 then begin
    Printf.eprintf "Usage: %s <dune-file>\n" Sys.argv.(0);
    exit 1
  end;

  let filename = Sys.argv.(1) in
  let input =
    try
      let ic = open_in filename in
      let len = in_channel_length ic in
      let content = really_input_string ic len in
      close_in ic;
      content
    with _ ->
      Printf.eprintf "Error: could not read file %s\n" filename;
      exit 1
  in

  let formatted = Alphafmt.format_dune input in
  print_endline formatted
