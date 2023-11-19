let print_keyboard_event e st transitions constants states =
  print_endline (Sdlkeycode.to_string e.Sdlevent.keycode);



  let sts = Run.Full_Simulation.run_full_update transitions constants
    (Sdlkeycode.to_string e.Sdlevent.keycode) states in
  List.iter (fun x -> print_int x; print_string " ";) states;
  sts

let proc_events e transitions constants states =

  match e with 
  | Sdlevent.KeyDown { scancode = Sdlscancode.ESCAPE } ->
      Printf.printf "We hope your training has helped you kombattant !";
      exit 0
  | Sdlevent.KeyDown e -> print_keyboard_event e "down" transitions constants states 
  (*| Sdlevent.KeyUp e -> print_keyboard_event e "up"*)
  | Sdlevent.Quit e ->
      Printf.printf "We hope your training has helped you kombattant !";
      ignore(e);
      Sdl.quit ();
      exit 0
  | e -> ignore(Sdlevent.to_string e); []


let call_events transitions constants =
  let width, height = (10, 10) in
  Sdl.init [`JOYSTICK];
  at_exit print_newline;

  let window =
    Sdlwindow.create2
      ~title:"ft_ality"
      ~x:(`pos 0) ~y:(`pos 0)
      ~width ~height
      ~flags:[
      ]
  in
  ignore (window);

  let states = [] in

  let rec event_loop (states) =
    match Sdlevent.poll_event () with
    | Some ev ->
      let states = proc_events ev transitions constants states in
      event_loop (states); states
    | None -> []
  in
  let rec main_loop (states) =
    let states = event_loop (states) in
    List.iter (fun x -> print_int x; print_string " ";) states;
    Sdltimer.delay 50;
    main_loop (states)
  in
  main_loop (states)
