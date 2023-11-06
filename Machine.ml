module type MachineStruct = 
  sig

    type instruction
    type machine_data 

    val new_instruction: string -> char -> string -> char -> string -> instruction

    val new_machine: string -> char list -> char ->
      string list -> string -> string list -> instruction list ->
      machine_data

    (*val run_machine : machine_data -> string -> unit*)

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

    (*
    let run_machine machine data_string =
      let rec loop machine data_string current_state_name cursor =
        match machine.transitions with
        | (state_hd::state_tail) -> if state_hd.name = current_state_name
          then
            let rec find_inst inst_list cur_alpha =
              match inst_list with
              | (inst_hd::inst_tail) -> if cur_alpha = inst_hd.read then inst_hd
                  else find_inst inst_tail cur_alpha
              | [] -> invalid_arg "invalide state name"
            in
            let cur_inst = find_inst state_hd (new_alphabet (String.get data_string cursor))
        | 

        | [] -> ()
      in
      loop machine data_string machine.inital 0
    *)

  end