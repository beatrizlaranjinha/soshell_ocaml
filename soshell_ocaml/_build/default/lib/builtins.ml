(* prompt da shell *)
let prompt = ref "SOSHELL> "

(* ficha 4 ex 6 - copiar dados entre ficheiros *)
let io_copy in_fd out_fd =
  let buffer = Bytes.create 1024 in

  let rec loop () =
    let n = Unix.read in_fd buffer 0 1024 in
    if n > 0 then begin
      ignore (Unix.write out_fd buffer 0 n);
      loop ()
    end
  in

  loop ()

(* ficha 4 ex 6 - comando socp *)
let socp fonte destino =
  let in_fd = Unix.openfile fonte [Unix.O_RDONLY] 0 in
  let out_fd =
    Unix.openfile destino
      [Unix.O_WRONLY; Unix.O_CREAT; Unix.O_TRUNC]
      0o644
  in

  io_copy in_fd out_fd;
  Unix.close in_fd;
  Unix.close out_fd

(* ficha 4 - comandos embutidos da shell *)
let builtin args =
  if Array.length args = 0 then
    true

  (* ficha 4 ex 1 - sair da shell *)
  else if args.(0) = "sair" then
    exit 0

  (* ficha 4 ex 2 - mostrar informação da shell *)
  else if args.(0) = "obterinfo" then begin
    print_endline "SoShell 2026 versao 1.1";
    true
  end

  (* ficha 4 ex 3 - mudar o prompt *)
  else if String.length args.(0) > 4
          && String.sub args.(0) 0 4 = "PS1=" then begin
    prompt := String.sub args.(0) 4 (String.length args.(0) - 4);
    true
  end

  (* ficha 4 ex 4 - mostrar o utilizador atual *)
  else if args.(0) = "quemsoueu" then begin
    let uid = Unix.getuid () in
    let pw = Unix.getpwuid uid in
    print_endline ("Sou utilizador: " ^ pw.Unix.pw_name);
    true
  end

  (* ficha 4 ex 5 - mudar de diretoria *)
  else if args.(0) = "cd" then begin
    let destino =
      if Array.length args < 2 || args.(1) = "~" || args.(1) = "$HOME" then
        Sys.getenv "HOME"
      else
        args.(1)
    in

    try
      Unix.chdir destino;
      true
    with
    | Unix.Unix_error (err, _, _) ->
        prerr_endline (destino ^ ": " ^ Unix.error_message err);
        true
  end

  (* ficha 4 ex 6 - copiar ficheiro *)
  else if args.(0) = "socp" then begin
    if Array.length args >= 3 then begin
      try
        socp args.(1) args.(2);
        true
      with
      | Unix.Unix_error (err, _, _) ->
          prerr_endline (Unix.error_message err);
          true
    end else begin
      print_endline "Sintaxe incorreta: uso: socp fonte destino";
      true
    end
  end

  (* comando externo *)
  else
    false
