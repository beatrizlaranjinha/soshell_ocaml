(* ficha P9 - obter informacao de um ficheiro usando stat *)
let stat_file filename =
  Unix.stat filename

(* ficha P9 ex 1 - mostrar o maior de dois ficheiros *)
let maior f1 f2 =
  try
    (* obter informacao dos dois ficheiros *)
    let s1 = stat_file f1 in
    let s2 = stat_file f2 in

    (* escolher o maior *)
    let nome, tamanho =
      if s1.Unix.st_size >= s2.Unix.st_size then
        (f1, s1.Unix.st_size)
      else
        (f2, s2.Unix.st_size)
    in

    (* converter para KB *)
    let kb = float_of_int tamanho /. 1024.0 in

    (* mostrar resultado *)
    Printf.printf
      "Maior ficheiro: %s (%.2f KB)\n%!"
      nome
      kb

  with
  (* tratar erros *)
  | Unix.Unix_error (err, funcao, arg) ->
      prerr_endline
        (funcao ^ "(" ^ arg ^ "): "
        ^ Unix.error_message err)

(* ficha P9 ex 2 - adicionar permissao de execucao ao dono *)
let setx filename =
  try
    (* obter permissoes atuais *)
    let st = stat_file filename in

    (* ativar bit de execucao do dono *)
    let novo_modo =
      st.Unix.st_perm lor 0o100
    in

    (* aplicar novas permissoes *)
    Unix.chmod filename novo_modo;

    Printf.printf
      "Permissao de execucao adicionada ao dono: %s\n%!"
      filename

  with
  (* tratar erros *)
  | Unix.Unix_error (err, funcao, arg) ->
      prerr_endline
        (funcao ^ "(" ^ arg ^ "): "
        ^ Unix.error_message err)

(* ficha P9 ex 3 - remover permissao de leitura ao grupo e outros *)
let removerl filename =
  try
    (* obter permissoes atuais *)
    let st = stat_file filename in

    (* mascara dos bits de leitura do grupo e outros *)
    let mask =
      0o040 lor 0o004
    in

    (* desligar os bits da mascara *)
    let novo_modo =
      st.Unix.st_perm land (lnot mask)
    in

    (* aplicar novas permissoes *)
    Unix.chmod filename novo_modo;

    Printf.printf
      "Permissao de leitura removida ao grupo e aos outros: %s\n%!"
      filename

  with
  (* tratar erros *)
  | Unix.Unix_error (err, funcao, arg) ->
      prerr_endline
        (funcao ^ "(" ^ arg ^ "): "
        ^ Unix.error_message err)

(* ficha P9 extensao - formatar data da ultima modificacao *)
let format_time timestamp =
  let tm =
    Unix.localtime timestamp
  in

  Printf.sprintf
    "%04d-%02d-%02d %02d:%02d:%02d"
    (tm.Unix.tm_year + 1900)
    (tm.Unix.tm_mon + 1)
    tm.Unix.tm_mday
    tm.Unix.tm_hour
    tm.Unix.tm_min
    tm.Unix.tm_sec

(* ficha P9 ex 4 - listagem rapida de ficheiros *)
let sols pasta_opt =

  (* usar diretoria atual por defeito *)
  let pasta =
    match pasta_opt with
    | Some p -> p
    | None -> "."
  in

  try
    (* abrir diretoria *)
    let dir =
      Unix.opendir pasta
    in

    (* percorrer entradas da diretoria *)
    let rec loop () =
      match Unix.readdir dir with

      (* entrada encontrada *)
      | nome ->

          (* construir caminho completo *)
          let caminho =
            if pasta = "." then
              nome
            else
              Filename.concat pasta nome
          in

          begin
            try
              (* obter informacao do ficheiro *)
              let st =
                Unix.stat caminho
              in

              (* mostrar nome, inode, tamanho e data *)
              Printf.printf
                "%-30s inode=%-10d tamanho=%-8d modificado=%s\n%!"
                nome
                st.Unix.st_ino
                st.Unix.st_size
                (format_time st.Unix.st_mtime)

            with
            (* tratar erros do stat *)
            | Unix.Unix_error (err, funcao, arg) ->
                prerr_endline
                  (funcao ^ "(" ^ arg ^ "): "
                  ^ Unix.error_message err)
          end;

          loop ()

      (* fim da diretoria *)
      | exception End_of_file ->
          Unix.closedir dir
    in

    loop ()

  with
  (* tratar erros da diretoria *)
  | Unix.Unix_error (err, funcao, arg) ->
      prerr_endline
        (funcao ^ "(" ^ arg ^ "): "
        ^ Unix.error_message err)
