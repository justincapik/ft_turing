module type Run =
  sig

    type t

    val run_full_update : Automate.Simul.transition list -> 
      Semantics.Alphabet.constant list -> string -> int list -> int list

  end

module Full_Simulation : Run