let parse ?prev_states:(prev_states=None) filename =

  let parse_line line =
    let lst = String.split_on_char ':' line in
    let finish = (List.nth lst 0) in
    let keys = String.split_on_char ',' (List.nth lst 1) in
    [finish] @ keys
  in

  let read_file channel =
    let rec internal channel id_count =
      try 
        let line = input_line channel in
        let lst = parse_line line in
        (*TODO FINAL IS (List.hd lst) *)
        let transitions = internal channel id_count in
        let id_count = (List.length transitions) in
        let newtr = Automate.Simul.get_new_transitions
          transitions (List.tl lst) id_count 0 (List.hd lst) in
        newtr
      with End_of_file -> []
    in

    internal channel 0
  in

  if ((not (Sys.file_exists filename) || not (String.ends_with ~suffix:".gmr" filename)))
    then
      begin
        prerr_endline "ERROR: invalide file";
        None
      end
  else
    begin
      let filechannel = open_in filename in
      let transitions = read_file filechannel in
      List.iter (fun t -> Automate.Simul.print_tr t) transitions;
      Option.some transitions
    end