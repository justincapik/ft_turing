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


let parser filename = 
    let filechannel = open_in filename in
    try
      let contents = everything filechannel "" in
     
      print_string contents;

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
      let rec test tr =
        match tr with
        | [str, assoc] -> print_endline (str ^ (assoc |> to_string))
        | (str,assoc)::tail ->
          try
            let lst = List.map to_assoc (assoc |> to_list) in
            List.iter test tail;
            print_endline (str ^ (assoc |> to_string))
            (*let res = String.concat " <=> " (List.map test lst) in
            print_endline ("RES("^str^")=>" ^ res)*)
          with e ->
            print_endline (str ^ (assoc |> to_string));
        | _ -> ()
      in
      test (transitions |> to_assoc);
      (*
      let k = Yojson.Basic.Util.keys transitions in
      let lst = read_transitions transitions k ((List.length k) + 1) in *)
      (*print_endline (transitions |> member "scanright" |> to_list |> member "action" |> to_string);
      let scanr = List.map (fun json -> member "scanright" json |> to_list ) transitions in*)
      (*let is_online = json |> member "is_online" |> to_bool_option in
      let authors = json |> member "authors" |> to_list in
      let names = List.map authors ~f:(fun json -> member "name" json |> to_string) in*)

      Printf.printf "Name: %s \n" name;
      Printf.printf "alphabet: %s\n" (String.concat ", " al);
      Printf.printf "blank: %s \n" blank;
      Printf.printf "states: %s\n" (String.concat ", " sts);
      Printf.printf "initial: %s \n" initial;
      Printf.printf "finals: %s\n" (String.concat ", " finals);
      (*Printf.printf "trans: %s\n" (String.concat ", " k);*)
      (*
      Printf.printf "transitions: %s\n" (String.concat ", " transitions);
      (* Print the results of the parsing *)
      printf "Title: %s (%d)\n" title pages;
      printf "Authors: %s\n" (String.concat ~sep:", " names);
      printf "Tags: %s\n" (String.concat ~sep:", " tags);
      let string_of_bool_option =
        function
        | None -> "<unknown>"
        | Some true -> "yes"
        | Some false -> "no" in
      printf "Online: %s\n" (string_of_bool_option is_online);
      printf "Translated: %s\n" (string_of_bool_option is_translated)
      *)
      
    with e ->
      close_in_noerr filechannel;
      print_endline (Printexc.to_string e);

    