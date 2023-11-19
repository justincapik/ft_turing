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

module Simul : Automate =
  struct

    type transition = {
      id : int;
      key : string;
      to_id : int;
      mutable final: string;
    }
    
    let new_transition id key to_id final = {
      id = id;
      key = key;
      to_id = to_id;
      final = final;
    }

    let print_tr tr =
      (Printf.printf "%d, %s, %d\n" tr.id tr.key tr.to_id)

    let search_transitions_for_out trs input in_id =
      let f = (fun t -> (t.id = in_id && t.key = input)) in
      match List.find_opt f trs with
      | None -> -1 
      | Some tr -> tr.to_id

    (* PARSING FUNCTION*)
    let rec get_new_transitions transitions keys id_count in_id final =

      let search_transitions trs input in_id =
        let f = (fun t -> (t.id = in_id && t.key = input)) in
        List.find_opt f trs
      in

      if List.is_empty keys
        then
          let hd = (List.hd transitions) in
          hd.final <- hd.final ^ final ^ "\n";
          ([hd] @ (List.tl transitions))
      else
        begin
          match search_transitions transitions (List.hd keys) in_id with
          | Some tr -> get_new_transitions transitions (List.tl keys) id_count tr.to_id final
          | None ->
              let newtr = new_transition in_id (List.hd keys) (id_count+1) "" in
              let transitions = [newtr] @ transitions in
              get_new_transitions transitions (List.tl keys) (id_count+1) (id_count+1) final
        end
      

  end