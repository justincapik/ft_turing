open Machine

let read_file channel =
  let rec internal channel contents linenb =
    if String.length contents > 1000000 then
      contents
    else
      begin
        try 
          let line = input_line channel in
          internal channel (contents ^ line ^ "\n") (linenb+1)
        with e -> ignore(e);
          contents
      end
  in
  internal channel "" 0 

let rec read_transitions transitions keys n =
  match n with
  | 0 -> []
  | _ -> List.append [transitions |> Yojson.Basic.Util.member (List.nth keys n)
      |> Yojson.Basic.Util.member "read"]
    (read_transitions transitions keys (n-1))

let get_transitions tr states =
  let open Yojson.Basic.Util in 
  let get_all_instruction name =
    let get_one_instruction lst = 
      let cs = name in 
      let r = (lst |> member "read" |> to_string) in
      let ts = lst |> member "to_state" |> to_string in
      let w = (lst |> member "write" |> to_string) in
      let a = lst |> member "action" |> to_string in
      if String.length r != 1 then
        begin
          prerr_endline ("ERROR: invalide read in " ^ cs); raise Exit
        end
      else if String.length w != 1 then
        begin
          prerr_endline ("ERROR: invalide write in " ^ cs); raise Exit
        end;
      let r = r.[0] in
      let w = w.[0] in
      Machine.new_instruction cs r ts w a
    in
    let lst = tr |> member name |> to_list in
    List.map get_one_instruction lst
  in
  List.flatten (List.map get_all_instruction states)

let parser filename =
  if ((not (Sys.file_exists filename) || not (String.ends_with ~suffix:".json" filename)))
    then
      begin
        prerr_endline "ERROR: invalide file";
        raise Exit
      end;

  let filechannel = open_in filename in
    
  try

    let contents = read_file filechannel in

    flush stdout;
    close_in filechannel;

    (*Json parsing and finding fields*)
    let json = Yojson.Basic.from_string contents in
    print_string "";
    
    let open Yojson.Basic.Util in
    let name = json |> member "name" |> to_string in
    let al = json |> member "alphabet" |> to_list |> filter_string in
    let blank = json |> member "blank" |> to_string in
    let sts = json |> member "states" |> to_list |> filter_string in
    let initial = json |> member "initial" |> to_string in
    let finals = json |> member "finals" |> to_list |> filter_string in
    let transitions = json |> member "transitions" in

    let char_al = List.map (fun elem -> if (String.length elem) != 1 then
      begin prerr_endline "ERROR: alphabet character is not of length one"; raise Exit end else elem.[0]) al in

    (*Error verification*)
    if (not (List.mem initial sts)) then
      begin
        print_endline "ERROR: initial state not in states list"; raise Exit
      end
    else if (not (List.exists (fun st -> st = blank) al)) then
      begin
        print_endline "ERROR: blank alphabet character not in alphabet";
        raise Exit
      end
    else if List.is_empty finals then
      begin
        print_endline "ERROR: finals list is empty";
        raise Exit
      end;
    List.iter (fun f ->
      if (not (List.mem f sts)) then
        begin prerr_endline "ERROR: final state not found in states list"; raise Exit end)
      finals;
   
    (*create machine*)
    let active_states = List.filter (fun elem -> not (List.mem elem finals)) sts in
    let instruction_list = get_transitions transitions active_states in
    let machine = Machine.new_machine name char_al blank.[0] sts initial finals instruction_list in
    
    (*final instruction verification*)
    Machine.check_instruction machine;
    
    machine
   
  (*Json error catching*)
  with
    | Yojson.Json_error e ->
      close_in_noerr filechannel;
      prerr_endline "ERROR: format error during parsing: ";
      prerr_endline e;
      raise Exit
    | Yojson.Basic.Finally (exn1, exn2)->
      close_in_noerr filechannel;
      let err_str = ("\nParsing excption:" ^ (Printexc.to_string exn1) ^ "\nFinalizer exception:" ^ (Printexc.to_string exn2)) in
      prerr_string "ERROR: error during parsing and catching error: ";
      prerr_endline err_str;
      raise Exit
    | Yojson.Basic.Util.Type_error (str, f)->
      ignore (f);
      close_in_noerr filechannel;
      let err_str = str in
      let contains s1 s2 =
        let re = Str.regexp_string s2 in
        try 
          ignore (Str.search_forward re s1 0); 
          true
        with Not_found -> false
      in
      if contains str "null" then
        prerr_endline "ERROR: missing field in json"
      else
        begin
          prerr_string "ERROR: Type error during parsing: ";
          prerr_endline err_str
        end;
      raise Exit
    | Yojson.Basic.Util.Undefined (str, f)->
      ignore (f);
      close_in_noerr filechannel;
      let err_str = str in
      prerr_string "ERROR: Array index out of bounds found during parsing: ";
      prerr_endline err_str;
      raise Exit
    | e ->
      close_in_noerr filechannel;
      (*prerr_endline ("ERROR: unrecognized error during parsing:" ^ (Printexc.to_string e));*)
      ignore (e);
      raise Exit