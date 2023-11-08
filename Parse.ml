open Machine

let clean_json contents =
  Str.global_replace (Str.regexp "[][> \n\t\r]") "" contents

let rec everything channel contents =
  try 
    let line = input_line channel in
    everything channel (contents ^ line ^ "\n")
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
    let filechannel = open_in filename in
    try
      let contents = everything filechannel "" in

      flush stdout;
      close_in filechannel;

      let json = Yojson.Basic.from_string contents in

      (* Locally open the JSON manipulation functions *)
      let open Yojson.Basic.Util in
      let name = json |> member "name" |> to_string in
      let al = json |> member "alphabet" |> to_list |> filter_string in
      let blank = json |> member "blank" |> to_string in
      let sts = json |> member "states" |> to_list |> filter_string in
      let initial = json |> member "initial" |> to_string in
      let finals = json |> member "finals" |> to_list |> filter_string in
      let transitions = json |> member "transitions" in
      (*tests*)
      let active_states = List.filter (fun elem -> not (List.mem elem finals)) sts in
      let instruction_list = get_transitions transitions active_states in

      (*
      Printf.printf "Name: %s \n" name;
      Printf.printf "alphabet: %s\n" (String.concat ", " al);
      Printf.printf "blank: %s \n" blank;
      Printf.printf "states: %s\n" (String.concat ", " sts);
      Printf.printf "initial: %s \n" initial;
      Printf.printf "finals: %s\n" (String.concat ", " finals);
      *)

      let char_al = List.map (fun elem -> elem.[0]) al in

      let machine = Machine.new_machine name char_al blank.[0] sts initial finals instruction_list in
      machine
      
    with e ->
      close_in_noerr filechannel;
      print_endline (Printexc.to_string e);
      invalid_arg "test";
    