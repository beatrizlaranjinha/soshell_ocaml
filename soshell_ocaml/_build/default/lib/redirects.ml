open Unix

(* ficha P6 - redirecionar stdin a partir de um ficheiro *)
let rstdin filename =
  let fd_in = openfile filename [O_RDONLY] 0 in
  dup2 fd_in stdin;
  close fd_in

(* ficha P6 - redirecionar stdout para um ficheiro *)
let rstdout filename =
  let fd_out = openfile filename [O_WRONLY; O_CREAT; O_TRUNC] 0o600 in
  dup2 fd_out stdout;
  close fd_out

(* ficha P6 - redirecionar stdout em modo append *)
let rappend filename =
  let fd_out = openfile filename [O_WRONLY; O_CREAT; O_APPEND] 0o600 in
  dup2 fd_out stdout;
  close fd_out

(* ficha P6 - redirecionar stderr para um ficheiro *)
let rstderr filename =
  let fd_err = openfile filename [O_WRONLY; O_CREAT; O_TRUNC] 0o600 in
  dup2 fd_err stderr;
  close fd_err

(* ficha P6 - aplicar redirecionamentos *)
let rec redirects args =
  let len = Array.length args in

  if len < 3 then
    args
  else
    match args.(len - 2) with
    | ">" ->
        rstdout args.(len - 1);
        redirects (Array.sub args 0 (len - 2))

    | ">>" ->
        rappend args.(len - 1);
        redirects (Array.sub args 0 (len - 2))

    | "<" ->
        rstdin args.(len - 1);
        redirects (Array.sub args 0 (len - 2))

    | "2>" ->
        rstderr args.(len - 1);
        redirects (Array.sub args 0 (len - 2))

    | _ ->
        args
