let () =

  let print_usage str =
    let usage = "usage: ft_ality [-h] gmrfile keysfile

  positional arguments:
  .gmr\t description of the grammar
  .keys\t description of the input keys 

  optional arguments:
  -h, --help\tshow this help message and exit"
    in
    print_string str;
    print_endline usage
  in

  let input_line_error_handle argv =
    let find_h = (fun elem -> ((elem = "-h") || (elem = "--help"))) in
    match List.find_opt find_h argv with
    | Some a -> print_usage ""; false
    | None ->
      if List.length argv < 2 then
        begin
          prerr_int (List.length argv);
          prerr_endline "\nERROR: need at least one argument, check --help for details";
          false
        end
      else
        begin
          true
        end
  in


  let argv = Array.to_list Sys.argv in 
  
  if input_line_error_handle argv then 
    begin
      let keysfile =
        match List.find_opt (fun s -> String.ends_with ~suffix:".keys" s) argv with
        | None -> "./data/moves.keys"
        | Some file -> file
      in
      let consts =
        match (Keys.parse keysfile) with
        | None -> exit 0
        | Some data -> data
      in
      let transitionsfile =
        match List.find_all (fun s -> String.ends_with ~suffix:".gmr" s) argv with
        | [] ->
          prerr_endline "ERROR: no grammar file provided, check --help";
          exit 0
        | file -> file
      in
      let transitions = Transitions.parse (List.nth transitionsfile 0) in
      match transitions with
      | None -> ();
      | Some transitions -> 
      Semantics.Alphabet.show_inputs consts;
      print_endline "--------------------------";
      Events.call_events transitions consts;
      print_endline ""
    end;