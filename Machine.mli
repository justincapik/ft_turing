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

module Machine : MachineStruct