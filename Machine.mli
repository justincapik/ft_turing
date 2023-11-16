module type MachineStruct = 
  sig
    type instruction
    type machine_data 

    val new_instruction: string -> char -> string -> char -> string -> instruction

    val new_machine: string -> char list -> char ->
      string list -> string -> string list -> instruction list ->
      machine_data
    
    val check_instruction : machine_data -> unit

    val present_machine : machine_data -> unit

    val run_machine : machine_data -> string -> unit

  end

module Machine : MachineStruct