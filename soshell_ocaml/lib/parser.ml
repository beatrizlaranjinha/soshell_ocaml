(* ficha 4 - separar a linha em argumentos *)
let parse linha =
  linha
  |> String.trim
  |> String.split_on_char ' '
  |> List.filter (fun s -> s <> "")
  |> Array.of_list
