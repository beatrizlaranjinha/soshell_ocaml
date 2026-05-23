(* ficha 4 ex 7 - verificar se o comando deve correr em background *)
let is_background args =
  let n = Array.length args in
  n > 0 && args.(n - 1) = "&"

(* ficha 4 ex 7 - remover o simbolo & dos argumentos *)
let remove_background args =
  if is_background args then
    Array.sub args 0 (Array.length args - 1)
  else
    args

(* ficha 4 e ficha P6 - executar comandos externos *)
let execute args =
  let background = is_background args in
  let args = remove_background args in

  if Array.length args = 0 then
    ()
  else
    match Unix.fork () with
    | 0 ->
        begin
          try
            (* ficha P6 - aplicar redirecionamentos antes do exec *)
            let args = Redirects.redirects args in

            if Array.length args = 0 then
              exit 0
            else
              Unix.execvp args.(0) args

          with
          | Unix.Unix_error (err, _, _) ->
              prerr_endline ("Erro: " ^ Unix.error_message err);
              exit 1
        end

    | pid ->
        if background then
          Printf.printf "[background] pid %d\n%!" pid
        else
          ignore (Unix.waitpid [] pid)
