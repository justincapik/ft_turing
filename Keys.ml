let parse filename = 

  let parse_line line =
    let lst = String.split_on_char '-' line in
    if List.length lst != 3 then
      begin
        prerr_endline "ERROR: invalide line in keys parsing";
        None
      end
    else
      Option.some (Semantics.Alphabet.new_constant
        (List.nth lst 0)
        (List.nth lst 1)
        (List.nth lst 2))
  in

  let rec read_file channel =
    try 
      let line = input_line channel in
      if String.length line = 0 then
        read_file channel
      else
        begin
          let elem = parse_line line in
          match elem with
          | None -> None
          | Some elem -> 
            let newelem = read_file channel in
            match newelem with
            | None -> None
            | Some newelem -> Option.some (List.append [elem] newelem)
        end
    with End_of_file -> Option.some []
  in

  if ((not (Sys.file_exists filename) || not (String.ends_with ~suffix:".keys" filename)))
    then
      begin
        prerr_endline "ERROR: invalide file";
        None
      end
  else

  let filechannel = open_in filename in
  match (read_file filechannel) with
  | None -> None
  | Some lst -> (*List.map (fun e -> Automate.Simul.print_co e) lst;*)
    Option.some lst
