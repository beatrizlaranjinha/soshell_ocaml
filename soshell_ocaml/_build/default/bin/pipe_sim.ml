(* ficha P7 ex 2 - detectar o simbolo pipe *)
let contains_pipe args =
  let rec loop i =
    if i >= Array.length args then
      -1
    else if args.(i) = "|" then
      i
    else
      loop (i + 1)
  in
  loop 0

(* ficha P7 ex 2 - simular dois comandos ligados por pipe *)
let () =
  let args = [| "ls"; "-l"; "-a"; "|"; "wc"; "-c" |] in
  let indice = contains_pipe args in

  if indice > 0 then begin
    let fd_read, fd_write = Unix.pipe () in

    print_endline ("pipe detected at index " ^ string_of_int indice);

    match Unix.fork () with
    | 0 ->
        let left = Array.sub args 0 indice in

        prerr_endline ("cmd write to pipe: <" ^ left.(0) ^ ">");

        Unix.dup2 fd_write Unix.stdout;
        Unix.close fd_read;
        Unix.close fd_write;

        Unix.execvp left.(0) left

    | _pid ->
        let right =
          Array.sub args
            (indice + 1)
            (Array.length args - indice - 1)
        in

        prerr_endline ("cmd read from pipe: <" ^ right.(0) ^ ">");

        Unix.dup2 fd_read Unix.stdin;
        Unix.close fd_read;
        Unix.close fd_write;

        Unix.execvp right.(0) right
  end
