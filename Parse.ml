
let clean_json contents =
  Str.global_replace (Str.regexp "[][> \n\t\r]") "" contents

let rec everything channel contents =
  try 
    let line = input_line channel in
    everything channel (contents ^ line)
  with e ->
    clean_json contents

(*let rec machine_details contents details = *)


let parser filename = 
    let filechannel = open_in filename in
    try
      let contents = everything filechannel "" in
     
      print_endline "PRINTING";
      print_string (String.trim contents);
      print_endline "DONE PRINTING";

      flush stdout;
      close_in filechannel
    with e ->
      close_in_noerr filechannel;