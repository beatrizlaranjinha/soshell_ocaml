(* ficha P7 - verificar se existe pipe *)
let contains_pipe args =
  let rec aux i =
    if i >= Array.length args then
      -1
    else if args.(i) = "|" then
      i
    else
      aux (i + 1)
  in
  aux 0

(* ficha P7 - executar dois comandos ligados por pipe simples *)
(* ficha P7 - executar dois comandos ligados por pipe simples *)
let executar args =
  let background = Executor.is_background args in
  let args = Executor.remove_background args in

  let pipe_index = contains_pipe args in

  if pipe_index <= 0 || pipe_index >= Array.length args - 1 then
    prerr_endline "Erro: sintaxe incorreta no pipe"
  else begin
    (* comando antes do pipe *)
    let left =
      Array.sub args 0 pipe_index
    in

    (* comando depois do pipe *)
    let right =
      Array.sub args
        (pipe_index + 1)
        (Array.length args - pipe_index - 1)
    in

    (* criar pipe *)
    let read_fd, write_fd = Unix.pipe () in

    match Unix.fork () with

    (* processo filho da esquerda: escreve para o pipe *)
    | 0 ->
        begin
          try
            Unix.dup2 write_fd Unix.stdout;

            Unix.close read_fd;
            Unix.close write_fd;

            (* ficha P6 - permitir redirecionamentos no comando da esquerda *)
            let left = Redirects.redirects left in

            Unix.execvp left.(0) left
          with
          | Unix.Unix_error (err, _, _) ->
              prerr_endline ("Erro: " ^ Unix.error_message err);
              exit 1
        end

    (* processo pai *)
    | pid1 ->
        match Unix.fork () with

        (* processo filho da direita: lê do pipe *)
        | 0 ->
            begin
              try
                Unix.dup2 read_fd Unix.stdin;

                Unix.close read_fd;
                Unix.close write_fd;

                (* ficha P6 - permitir redirecionamentos no comando da direita *)
                let right = Redirects.redirects right in

                Unix.execvp right.(0) right
              with
              | Unix.Unix_error (err, _, _) ->
                  prerr_endline ("Erro: " ^ Unix.error_message err);
                  exit 1
            end

        (* processo pai: fecha descritores e espera *)
        | pid2 ->
            Unix.close read_fd;
            Unix.close write_fd;
            if background then
              Printf.printf "[background] pipe pids %d %d\n%!" pid1 pid2
            else begin
              ignore (Unix.waitpid [] pid1);
              ignore (Unix.waitpid [] pid2)
            end
  end
