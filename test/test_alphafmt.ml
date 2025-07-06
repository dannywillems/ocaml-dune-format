let read_file filename =
  let ic = open_in filename in
  let len = in_channel_length ic in
  let content = really_input_string ic len in
  close_in ic;
  content

let write_temp_file content =
  let temp_file = Filename.temp_file "dune_test" ".dune" in
  let oc = open_out temp_file in
  output_string oc content;
  close_out oc;
  temp_file

let apply_dune_fmt content =
  let temp_file = write_temp_file content in
  let output_file = temp_file ^ ".formatted" in
  let cmd =
    Printf.sprintf "dune format-dune-file %s > %s" temp_file output_file
  in
  let exit_code = Sys.command cmd in
  if exit_code = 0 && Sys.file_exists output_file then (
    let formatted = read_file output_file in
    Sys.remove temp_file;
    Sys.remove output_file;
    formatted)
  else (
    if Sys.file_exists temp_file then Sys.remove temp_file;
    if Sys.file_exists output_file then Sys.remove output_file;
    content (* fallback to original if dune format-dune-file fails *))

let run_test test_name =
  let input_file = "res/" ^ test_name ^ ".input" in
  let expected_file = "res/" ^ test_name ^ ".expected" in
  let input = read_file input_file in
  let expected = read_file expected_file in
  let result = Alphafmt.format_dune input in
  let formatted_result = apply_dune_fmt result in
  if String.trim formatted_result = String.trim expected then
    Printf.printf "✓ %s test passed\n" test_name
  else (
    Printf.printf "✗ %s test failed\n" test_name;
    Printf.printf "Expected:\n%s\n" expected;
    Printf.printf "Got:\n%s\n" formatted_result;
    exit 1)

let test_basic_sorting () = run_test "basic_sorting"
let test_single_form () = run_test "single_form"
let test_empty_input () = run_test "empty_input"
let test_already_sorted () = run_test "already_sorted"
let test_library_sorting () = run_test "library_sorting"
let test_preprocess_pps_sorting () = run_test "preprocess_pps_sorting"
let test_libraries_sorting () = run_test "libraries_sorting"

let () =
  Printf.printf "Running alphafmt tests...\n";
  test_basic_sorting ();
  test_single_form ();
  test_empty_input ();
  test_already_sorted ();
  test_library_sorting ();
  test_preprocess_pps_sorting ();
  test_libraries_sorting ();
  Printf.printf "All tests passed! ✨\n"
