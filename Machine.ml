module type MachineStruct = 
  sig

    type instruction
    type machine_data 

    val new_instruction: string -> char -> string -> char -> string -> instruction

    val new_machine: string -> char list -> char ->
      string list -> string -> string list -> instruction list ->
      machine_data
    
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

    let instruction_string instr = 
      let reading = ( "(" ^ instr.in_state ^ ", " ^ (String.make 1 instr.read) ^ ")") in
      let out = ( "(" ^ instr.in_state ^ ", " ^ (String.make 1 instr.write) ^ ", " ^ instr.action ^ ")") in
      (reading ^ " -> " ^ out)

    let rec present_machine machine =
      print_endline ("Name: " ^ machine.name);
      let alphabet_to_str lst = String.concat ", " (List.map (String.make 1) lst) in
      print_endline ("States: [ " ^ (String.concat ", " machine.states) ^ " ]");
      print_endline ("Alphabet: [ " ^ (alphabet_to_str machine.machine_alphabet) ^ " ]");
      print_endline ("Initial state: " ^ machine.inital);
      print_endline ("Finals: [ " ^ (String.concat ", " machine.finals) ^ " ]");
      print_endline "Instruction list:";
      List.iter (fun inst -> print_endline ("  " ^ (instruction_string inst))) machine.transitions

    let run_machine machine data_string =
      let rec loop insts str cursor cur_state =
        if not (List.mem cur_state machine.finals)
          then
            let cur_inst = List.find (fun inst -> (inst.in_state = cur_state && str.[cursor] = inst.read)) insts in
            (* TODO CHANGE CUS CAN'T HAVE LONG STRING*)
            let str = String.mapi (fun i c -> if i = cursor then cur_inst.write else c) str in
            let cursor = if cur_inst.action = "RIGHT" then (cursor + 1) else (cursor - 1) in
            print_string (str ^ " \t" ^ (instruction_string cur_inst));
            print_endline "";
            loop insts str cursor cur_inst.to_state;
        else
          print_endline "Loop done !";
      in
      loop machine.transitions data_string 0 machine.inital 

  end