(* ficha P8 - funcao aviso bloqueante *)
let aviso msg tempo =
  let rec espera = function
    | t when t <= 0 -> ()
    | t ->
        Unix.sleep 1;
        espera (t - 1)
  in
  espera tempo;
  prerr_endline ("Aviso: " ^ msg)

(* ficha P8 - avisomau, passa os argumentos diretamente *)
let avisomau args =
  ignore
    (Thread.create
       (fun () ->
         match Array.to_list args with
         | _ :: msg :: tempo :: _ ->
             aviso msg (int_of_string tempo)
         | _ ->
             prerr_endline "Uso: avisomau mensagem tempo")
       ())

(* ficha P8 - estrutura segura para aviso *)
type aviso_t = {
  msg : string;
  tempo : int;
}

(* ficha P8 - aviso correto numa thread separada *)
let aviso_thread msg tempo =
  let dados = { msg; tempo } in
  ignore
    (Thread.create
       (fun () ->
         aviso dados.msg dados.tempo)
       ())

(* ficha P8 - registo das copias efetuadas *)
let max_logs = 100
let logs = Array.make max_logs ""
let log_index = ref 0
let log_mutex = Mutex.create ()

(* ficha P8 - formatar data e hora *)
let data_atual () =
  let t = Unix.time () |> Unix.localtime in
  Printf.sprintf "%04d-%02d-%02d %02d:%02d:%02d"
    (t.Unix.tm_year + 1900)
    (t.Unix.tm_mon + 1)
    t.Unix.tm_mday
    t.Unix.tm_hour
    t.Unix.tm_min
    t.Unix.tm_sec

(* ficha P8 - executar funcao com mutex *)
let with_mutex mutex f =
  Mutex.lock mutex;
  Fun.protect
    ~finally:(fun () -> Mutex.unlock mutex)
    f

(* ficha P8 - adicionar informacao sobre uma copia *)
let adicionar_log ficheiro =
  with_mutex log_mutex (fun () ->
      let pos = !log_index mod max_logs in
      logs.(pos) <- data_atual () ^ " " ^ ficheiro;
      incr log_index)

(* ficha P8 - copiar ficheiro com tamanho de bloco variavel *)
let copiar_ficheiro fonte destino blksize =
  let in_fd = Unix.openfile fonte [Unix.O_RDONLY] 0 in
  let out_fd =
    Unix.openfile destino
      [Unix.O_WRONLY; Unix.O_CREAT; Unix.O_TRUNC]
      0o644
  in

  let buffer = Bytes.create blksize in

  let rec copiar () =
    match Unix.read in_fd buffer 0 blksize with
    | 0 -> ()
    | n ->
        ignore (Unix.write out_fd buffer 0 n);
        copiar ()
  in

  Fun.protect
    ~finally:(fun () ->
      Unix.close in_fd;
      Unix.close out_fd)
    copiar;

  adicionar_log destino

(* ficha P8 - copiar ficheiro numa thread separada *)
let socpthread fonte destino blksize =
  ignore
    (Thread.create
       (fun () ->
         try
           copiar_ficheiro fonte destino blksize
         with
         | Unix.Unix_error (err, _, _) ->
             prerr_endline ("Erro na copia: " ^ Unix.error_message err)
         | Invalid_argument _ ->
             prerr_endline "Erro: tamanho do bloco invalido")
       ())

(* ficha P8 - listar informacao das copias *)
let info_copias () =
  with_mutex log_mutex (fun () ->
      let total = min !log_index max_logs in
      Array.to_list logs
      |> List.filter (fun s -> s <> "")
      |> List.filteri (fun i _ -> i < total)
      |> List.iter print_endline)
