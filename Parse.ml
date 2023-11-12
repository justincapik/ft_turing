open Machine

let rec read_file channel contents =
  try 
    let line = input_line channel in
    read_file channel (contents ^ line ^ "\n")
  with e ->
    contents

let rec read_transitions transitions keys n =
  match n with
  | 0 -> []
  | _ -> List.append [transitions |> Yojson.Basic.Util.member (List.nth keys n)
      |> Yojson.Basic.Util.member "read"]
    (read_transitions transitions keys (n-1))

let rec get_transitions tr states =
  let open Yojson.Basic.Util in 
  let rec get_all_instruction name =
    let get_one_instruction lst = 
      let cs = name in 
      let r = (lst |> member "read" |> to_string).[0] in
      let ts = lst |> member "to_state" |> to_string in
      let w = (lst |> member "write" |> to_string).[0] in
      let a = lst |> member "action" |> to_string in
      Machine.new_instruction cs r ts w a
    in
    try
      let lst = tr |> member name |> to_list in
      List.map get_one_instruction lst
    with e ->
      prerr_endline ("Error while reading state " ^ name); []
  in
  List.flatten (List.map get_all_instruction states)


let parser filename =
  if ((not (Sys.file_exists filename)) || (not (String.ends_with ~suffix:".json" filename))) then
    begin
      prerr_endline "ERROR: invalide file";
      raise Exit
    end;

  let filechannel = open_in filename in
    
  (*try TODO*) 
  let contents = read_file filechannel "" in

  try

    flush stdout;
    close_in filechannel;

    let json = Yojson.Basic.from_string contents in
    print_string "";
    
    (* get main *)
    let open Yojson.Basic.Util in
    let name = json |> member "name" |> to_string in
    let al = json |> member "alphabet" |> to_list |> filter_string in
    let blank = json |> member "blank" |> to_string in
    let sts = json |> member "states" |> to_list |> filter_string in
    let initial = json |> member "initial" |> to_string in
    let finals = json |> member "finals" |> to_list |> filter_string in
    let transitions = json |> member "transitions" in
    
    let active_states = List.filter (fun elem -> not (List.mem elem finals)) sts in
    let instruction_list = get_transitions transitions active_states in

    let char_al = List.map (fun elem -> elem.[0]) al in

    let machine = Machine.new_machine name char_al blank.[0] sts initial finals instruction_list in
    machine
    
  with
    | Yojson.Json_error e ->
      close_in_noerr filechannel;
      prerr_endline "ERROR: format error during parsing: ";
      prerr_endline e;
      raise Exit
    | Yojson.Basic.Finally (exn1, exn2)->
      close_in_noerr filechannel;
      let err_str = ("\nParsing excption:" ^ (Printexc.to_string exn1) ^ "\nFinalizer exception:" ^ (Printexc.to_string exn1)) in
      prerr_string "ERROR: error during parsing and catching error: ";
      prerr_endline err_str;
      raise Exit
    | Yojson.Basic.Util.Type_error (str, f)->
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
      close_in_noerr filechannel;
      let err_str = str in
      prerr_string "ERROR: Array index out of bounds found during parsing: ";
      prerr_endline err_str;
      raise Exit
    | e ->
      close_in_noerr filechannel;
      prerr_endline "ERROR: unrecognized error during parsing:";
      prerr_endline (Printexc.to_string e);
      raise Exit
  