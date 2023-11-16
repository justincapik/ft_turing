open Parse

let print_usage str =
  let usage = "usage: ft_turing [-h] jsonfile input

positional arguments:
 jsonfile\tjson description of the machine

 input\t\tinput of the machine

optional arguments:
 -h, --help\tshow this help message and exit"
  in
  print_string str;
  print_endline usage

let () =
  let argv = Array.to_list Sys.argv in 
  try
    (*Error check*)
    let find_h = (fun elem -> ((elem = "-h") || (elem = "--help"))) in
    try
      if (List.find find_h argv != "") then
      print_usage "";
    with e -> ignore(e);

    if List.length argv != 3 then
      prerr_endline "ERROR: Wrong number of arguments";
    
    let filename = List.nth argv 1 in
    let data_string = List.nth argv 2 in
    let machine = Parse.parser filename in
    Machine.Machine.check_string machine data_string;
    (*create machine struct*)
    Machine.Machine.present_machine machine;
    (*run machine*)
    Machine.Machine.run_machine machine data_string;
  with e -> ignore (e);(*print_endline (Printexc.to_string e);*)