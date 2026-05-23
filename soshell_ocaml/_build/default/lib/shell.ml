(* ficha 4 - executar uma linha escrita pelo utilizador *)
let executar_linha linha =
  let args = Parser.parse linha in

  (* verificar linha vazia *)
  if Array.length args = 0 then
    ()

  (* verificar comandos embutidos *)
  else if Builtins.builtin args then
    ()

  (* verificar comandos com pipe *)
  else if Pipes.contains_pipe args >= 0 then
    Pipes.executar args

  (* executar comando externo normal *)
  else
    Executor.execute args
