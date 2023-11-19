module type Automate =
  sig
    type transition
    
    val new_transition : int -> string -> int -> string -> transition

    val print_tr : transition -> unit
    
    val search_transitions_for_out : transition list -> string -> int -> int

    val get_new_transitions : transition list ->
      string list -> int -> int -> string -> transition list
  end
  
(*
  Finite Automaton for Regular language
*)

module Simul : Automate