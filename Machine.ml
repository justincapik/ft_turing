module type MachineStruct = 
  sig

    type alphabet
    type state 
    type move
    type instruction
    type machine_data 

    val new_alphabet: char -> alphabet
    val new_state: string -> state
    val new_move: string -> move

    val new_instruction: state -> alphabet -> state -> alphabet -> move -> instruction

    val new_machine: string -> alphabet list -> alphabet ->
      state list -> state -> state list -> state list ->
      machine_data

    (*val run_machine : machine_data -> string -> unit*)

  end

module Machine : MachineStruct = 
  struct

    type alphabet = char
    type state = string
    type move = string
    type instruction = {
      in_state  : state;
      read      : alphabet;
      to_state  : state;
      write     : alphabet;
      action    : move
    }

    type machine_data = {
      name              : string;
      machine_alphabet  : alphabet list;
      blank             : alphabet;
      states            : state list;
      inital            : state;
      finals            : state list;
      transitions       : state list;
    }

    let new_alphabet a = a
    let new_state s = s
    let new_move m = m

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