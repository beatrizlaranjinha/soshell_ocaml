(* ficha P7 ex 1 - programa de threads *)

let x = ref 1

(* ficha P7 ex 1 - funcao executada por cada thread *)
let funcao id =
  while !x = 1 do
    ()
  done;
  print_endline ("OLA " ^ string_of_int id)

(* ficha P7 ex 1 - criar e esperar pelas threads *)
let () =
  let num_threads = 5 in

  let threads =
    Array.init num_threads (fun i ->
      Domain.spawn (fun () -> funcao i)
    )
  in

  print_endline "Inspecionar as threads e depois carregar Enter";

  ignore (read_line ());

  x := 2;

  Array.iter Domain.join threads;

  print_endline "O programa chegou ao fim."
