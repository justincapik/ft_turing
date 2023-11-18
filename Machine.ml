module type MachineStruct = 
  sig

    type instruction
    type machine_data 

    val new_instruction: string -> char -> string -> char -> string -> instruction

    val new_machine: string -> char list -> char ->
      string list -> string -> string list -> instruction list ->
      machine_data
    
    val check_instruction : machine_data -> unit
    val check_string : machine_data -> string -> unit
    
    val present_machine : machine_data -> unit

    val run_machine : machine_data -> string -> unit

  end

module Machine : MachineStruct = 
  struct

    type instruction = {
      in_state  : string;
      read      : char;
      to_state  : string;
      write     : char;
      action    : string
    }

    type machine_data = {
      name              : string;
      machine_alphabet  : char list;
      blank             : char;
      states            : string list;
      inital            : string;
      finals            : string list;
      transitions       : instruction list;
    }

    let new_instruction in_state read to_state write action = {
      in_state = in_state;
      read = read;
      to_state = to_state;
      write = write;
      action = action;
    }

    let new_machine name machine_alphabet blank states initial finals transitions = {
      name = name;
      machine_alphabet = machine_alphabet;
      blank = blank;
      states = states;
      inital = initial;
      finals = finals;
      transitions = transitions;      
    }

    let check_instruction machine =
      let loop inst = 
        if not (List.exists (fun st -> st = inst.in_state) machine.states) then
          begin
            prerr_endline ("ERROR: invalide in_state in " ^ inst.in_state); raise Exit
          end
        else if not (List.exists (fun st -> st = inst.read) machine.machine_alphabet) then
          begin
            prerr_endline ("ERROR: invalide read in " ^ inst.in_state); raise Exit
          end
        else if not (List.exists (fun st -> st = inst.to_state) machine.states) then
          begin
            prerr_endline ("ERROR: invalide to_state in " ^ inst.in_state); raise Exit
          end
        else if not (List.exists (fun st -> st = inst.write) machine.machine_alphabet) then
          begin
            prerr_endline ("ERROR: invalide write in " ^ inst.in_state); raise Exit
          end
        else if not (inst.action = "RIGHT" || inst.action = "LEFT") then
          begin
            prerr_endline ("ERROR: invalide action in " ^ inst.in_state); raise Exit
          end
      in
      List.iter loop machine.transitions

    let check_string machine data_string =
      String.iter (fun f ->
        if f = machine.blank then
          begin prerr_endline "ERROR: found blank character in data string"; raise Exit end)
        data_string


    let instruction_string instr = 
      let reading = ( "\t(" ^ instr.in_state ^ ", " ^ (String.make 1 instr.read) ^ ")") in
      let out = ( "(" ^ instr.to_state ^ ", " ^ (String.make 1 instr.write) ^ ", " ^ instr.action ^ ")") in
      (reading ^ " -> " ^ out)

    let update_str str cursor blank = 
      if cursor = String.length str then
        str ^ (String.make 1 blank)
      else if cursor < 0 then
        (String.make 1 blank) ^ str
      else
        str

    let get_data_string str cursor =
      (String.sub str 0 cursor) ^ "<" ^ (String.make 1 str.[cursor]) ^ ">" ^
      (String.sub str (cursor+1) ((String.length str)-1-cursor))


    let present_machine machine =
      print_endline "-------------------------------------------------------------";
      print_endline ("Name: " ^ machine.name);
      print_endline "-------------------------------------------------------------";
      let alphabet_to_str lst = String.concat ", " (List.map (String.make 1) lst) in
      print_endline ("States: [ " ^ (String.concat ", " machine.states) ^ " ]");
      print_endline ("Alphabet: [ " ^ (alphabet_to_str machine.machine_alphabet) ^ " ]");
      print_endline ("Initial state: " ^ machine.inital);
      print_endline ("Finals: [ " ^ (String.concat ", " machine.finals) ^ " ]");
      print_endline "Instruction list:";
      List.iter (fun inst -> print_endline ("  " ^ (instruction_string inst))) machine.transitions;
      print_endline "-------------------------------------------------------------"

    let run_machine machine data_string =
      let rec loop insts str cursor cur_state =
        if not (List.mem cur_state machine.finals)
          then
            let cur_inst = List.find_opt (fun inst -> (inst.in_state = cur_state && str.[cursor] = inst.read)) insts in
            match cur_inst with
            | Some cur_inst -> 
              (* TODO CHANGE CUS CAN'T HAVE LONG STRING*)
              print_endline ((get_data_string str cursor) ^ (instruction_string cur_inst));
              let str = String.mapi (fun i c -> if i = cursor then cur_inst.write else c) str in
              
              (*update cursor and string*)
              let cursor = if cur_inst.action = "RIGHT" then (cursor + 1) else (cursor - 1) in
              let str = update_str str cursor machine.blank in
              let cursor = if cursor < 0 then 0 else cursor in
              (*move to next stae*) 
              loop insts str cursor cur_inst.to_state
            | None ->
              prerr_endline ("\nMachine is blocked: couldn't match current state <" ^ cur_state ^
                "> and current character <" ^ (String.make 1 str.[cursor]) ^ "> to instruction");
              raise Exit
        else
          begin
            print_endline ((get_data_string str cursor) ^ "\tHALT");
            print_endline "-------------------------------------------------------------"
          end
      in
      try
        loop machine.transitions data_string 0 machine.inital 
      with e-> ignore(e);
        raise Exit

  end