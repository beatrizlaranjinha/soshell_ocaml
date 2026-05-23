(* ficha P7 suplementar - verificar se existe pipe *)
let contains_pipe args =
  let rec aux i =
    if i >= Array.length args then -1
    else if args.(i) = "|" then i
    else aux (i + 1)
  in
  aux 0

(* ficha P7 suplementar - dividir argumentos por pipes *)
let split_by_pipe args =
  let rec aux current acc = function
    | [] ->
        List.rev (Array.of_list (List.rev current) :: acc)

    | "|" :: rest ->
        aux [] (Array.of_list (List.rev current) :: acc) rest

    | x :: rest ->
        aux (x :: current) acc rest
  in

  aux [] [] (Array.to_list args)

(* ficha P7 suplementar - validar comandos do pipe *)
let valid_commands commands =
  List.for_all (fun cmd -> Array.length cmd > 0) commands

(* ficha P7 suplementar - executar varios comandos ligados por pipes *)
let executar args =
  let background = Executor.is_background args in
  let args = Executor.remove_background args in
  let commands = split_by_pipe args in

  if not (valid_commands commands) then
    prerr_endline "Erro: sintaxe incorreta no pipe"
  else
    let n = List.length commands in

    if n < 2 then
      prerr_endline "Erro: pipe insuficiente"
    else begin
      let pipes =
        Array.init (n - 1) (fun _ -> Unix.pipe ())
      in

      let close_all_pipes () =
        Array.iter
          (fun (r, w) ->
            Unix.close r;
            Unix.close w)
          pipes
      in

      let executar_comando i cmd =
        match Unix.fork () with
        | 0 ->
            begin
              try
                (* se nao for o primeiro comando, lê do pipe anterior *)
                if i > 0 then begin
                  let r, _ = pipes.(i - 1) in
                  Unix.dup2 r Unix.stdin
                end;

                (* se nao for o ultimo comando, escreve para o proximo pipe *)
                if i < n - 1 then begin
                  let _, w = pipes.(i) in
                  Unix.dup2 w Unix.stdout
                end;

                close_all_pipes ();

                (* ficha P6 - permitir redirecionamentos em cada comando *)
                let cmd = Redirects.redirects cmd in

                Unix.execvp cmd.(0) cmd
              with
              | Unix.Unix_error (err, _, _) ->
                  prerr_endline ("Erro: " ^ Unix.error_message err);
                  exit 1
            end
        | pid ->
            pid
      in

      let pids =
        commands
        |> List.mapi executar_comando
      in

      close_all_pipes ();

      if background then
        print_endline "[background] pipeline"
      else
        List.iter
          (fun pid -> ignore (Unix.waitpid [] pid))
          pids
    end
