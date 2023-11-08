let () =
  let filename = "unary_sub.json" in
  let machine = Parse.parser filename in
  Machine.Machine.present_machine machine;
  Machine.Machine.run_machine machine "111-11=";