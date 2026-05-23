(* ficha 4 - ciclo principal da shell *)
let () =
  while true do

    (* mostrar prompt *)
    print_string !(Soshell_ocaml.Builtins.prompt);
    flush stdout;

    (* ler linha introduzida pelo utilizador *)
    let linha = read_line () in

    (* executar linha *)
    Soshell_ocaml.Shell.executar_linha linha

  done
