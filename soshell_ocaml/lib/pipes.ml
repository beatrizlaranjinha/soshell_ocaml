(* ficha extra - verificar se existe pipe *)
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

(* ficha extra - executar dois comandos ligados por pipe *)
let executar args =
  let pipe_index = contains_pipe args in

  let left =
    Array.sub args 0 pipe_index
  in

  let right =
    Array.sub args
      (pipe_index + 1)
      (Array.length args - pipe_index - 1)
  in

  let read_fd, write_fd = Unix.pipe () in

  match Unix.fork () with

  (* processo filho da esquerda *)
  | 0 ->
      Unix.dup2 write_fd Unix.stdout;
      Unix.close read_fd;
      Unix.close write_fd;
      Unix.execvp left.(0) left

  (* processo pai *)
  | pid1 ->
      match Unix.fork () with

      (* processo filho da direita *)
      | 0 ->
          Unix.dup2 read_fd Unix.stdin;
          Unix.close read_fd;
          Unix.close write_fd;
          Unix.execvp right.(0) right

      (* processo pai *)
      | pid2 ->
          Unix.close read_fd;
          Unix.close write_fd;
          ignore (Unix.waitpid [] pid1);
          ignore (Unix.waitpid [] pid2)
