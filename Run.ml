module type Run =
  sig

    type t

    val run_full_update : Automate.Simul.transition list -> 
      Semantics.Alphabet.constant list -> string -> int list -> int list

  end

(*
FULL GAME LOOP:
  - transitions -> P and Q
  - constants -> V
  - inputs -> a c E
  - state -> Qn states (link of int ids)
    *)

module Full_Simulation : Run =
  struct
    
    type t = {
      unused: int
    }
        
    let run_full_update transitions constants input state_list =

      let run_single_state state =
        let next_id = Automate.Simul.search_transitions_for_out transitions input state in
        print_int state; print_string " -> "; print_int next_id;
        print_endline ""; [next_id]
      in

      let go_through_all_states state_list =
        match state_list with
        | [] -> []
        | (hd::tl) -> state_list @ (run_single_state hd)
      in
      go_through_all_states ([0] @ state_list)
  end