module type Semantics =
  sig
    type constant
    
    val new_constant : string -> string -> string -> constant
    
    val show_inputs : constant list -> unit
  end

module Alphabet : Semantics =
  struct
    type constant = {
      key: string;
      short: string;
      full: string;
    }

    let new_constant key short full = {
      key = key;
      short = short;
      full = full;
    }

    let rec show_inputs consts =
      if not (List.is_empty consts) then
        begin
          let cur = List.hd consts in
          print_endline (cur.key ^ " -> [" ^ cur.short ^ "] " ^ cur.full);
          show_inputs (List.tl consts)
        end

end