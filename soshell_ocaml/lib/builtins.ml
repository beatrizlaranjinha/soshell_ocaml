(* prompt da shell *)
let prompt = ref "SOSHELL> "

(* ficha 4 suplementar - guardar diretoria anterior *)
let previous_dir = ref None

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

    let novo =
      String.sub args.(0) 4 (String.length args.(0) - 4)
    in

    let hostname = Unix.gethostname () in

    let novo =
      Str.global_replace
        (Str.regexp "\\\\h")
        hostname
        novo
    in

    prompt := novo;

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
    let atual = Sys.getcwd () in

    let destino =
      match Array.to_list args with
      | [_] -> Sys.getenv "HOME"
      | [_; "~"] -> Sys.getenv "HOME"
      | [_; "$HOME"] -> Sys.getenv "HOME"
      | [_; "-"] ->
          begin
            match !previous_dir with
            | Some dir -> dir
            | None -> atual
          end
      | _ :: dir :: _ -> dir
      | _ -> Sys.getenv "HOME"
    in

    try
      Unix.chdir destino;
      previous_dir := Some atual;
      print_endline (Sys.getcwd ());
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

      (* ficha P8 ex 2 - aviso bloqueante *)
      else if args.(0) = "avisoTeste" then begin
        match Array.to_list args with
        | [_; msg; tempo] ->
            begin
              match int_of_string_opt tempo with
              | Some t ->
                  Threads.aviso msg t;
                  true
              | None ->
                  print_endline "Erro: tempo deve ser um numero inteiro";
                  true
            end
        | _ ->
            print_endline "Uso: avisoTeste mensagem tempo";
            true
      end

      (* ficha P8 ex 3a - aviso mau em thread *)
      else if args.(0) = "avisomau" then begin
        match Array.to_list args with
        | [_; _msg; tempo] ->
            begin
              match int_of_string_opt tempo with
              | Some _ ->
                  Threads.avisomau args;
                  true
              | None ->
                  print_endline "Erro: tempo deve ser um numero inteiro";
                  true
            end
        | _ ->
            print_endline "Uso: avisomau mensagem tempo";
            true
      end

      (* ficha P8 ex 3b - aviso correto em thread *)
      else if args.(0) = "aviso" then begin
        match Array.to_list args with
        | [_; msg; tempo] ->
            begin
              match int_of_string_opt tempo with
              | Some t ->
                  Threads.aviso_thread msg t;
                  true
              | None ->
                  print_endline "Erro: tempo deve ser um numero inteiro";
                  true
            end
        | _ ->
            print_endline "Uso: aviso mensagem tempo";
            true
      end

      (* ficha P8 ex 4 - copiar ficheiro numa thread *)
      else if args.(0) = "socpthread" then begin
        match Array.to_list args with
        | [_; fonte; destino] ->
            Threads.socpthread fonte destino 1024;
            true
        | [_; fonte; destino; blksize] ->
            begin
              match int_of_string_opt blksize with
              | Some n when n > 0 ->
                  Threads.socpthread fonte destino n;
                  true
              | _ ->
                  print_endline "Erro: blksize deve ser um inteiro positivo";
                  true
            end
        | _ ->
            print_endline "Uso: socpthread fonte destino [blksize]";
            true
      end

      (* ficha P8 ex 4c - listar copias terminadas *)
      else if args.(0) = "infoCopias" then begin
        Threads.info_copias ();
        true
      end

      (* ficha P9 ex 1 - mostrar o maior de dois ficheiros *)
      else if args.(0) = "maior" then begin
        match Array.to_list args with
        | [_; f1; f2] ->
            Fileutils.maior f1 f2;
            true
        | _ ->
            print_endline "Uso: maior ficheiro1 ficheiro2";
            true
      end

      (* ficha P9 ex 2 - adicionar permissao de execucao ao dono *)
      else if args.(0) = "setx" then begin
        match Array.to_list args with
        | [_; ficheiro] ->
            Fileutils.setx ficheiro;
            true
        | _ ->
            print_endline "Uso: setx ficheiro";
            true
      end

      (* ficha P9 ex 3 - remover leitura ao grupo e aos outros *)
      else if args.(0) = "removerl" then begin
        match Array.to_list args with
        | [_; ficheiro] ->
            Fileutils.removerl ficheiro;
            true
        | _ ->
            print_endline "Uso: removerl ficheiro";
            true
      end

      (* ficha P9 ex 4 - listagem rapida *)
      else if args.(0) = "sols" then begin
        match Array.to_list args with
        | [_] ->
            Fileutils.sols None;
            true
        | [_; pasta] ->
            Fileutils.sols (Some pasta);
            true
        | _ ->
            print_endline "Uso: sols [diretoria]";
            true
      end

      (* comando externo *)
      else
        false
