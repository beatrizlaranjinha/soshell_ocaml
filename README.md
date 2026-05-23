Shell em OCaml


O projeto aborda conceitos fundamentais como a gestão de processos, concorrência através de threads, manipulação de descritores de ficheiros e comunicação inter-processos (pipes).

---

## Funcionalidades Principais

*  **Execução de comandos externos** (com procura na variável de ambiente `$PATH`).
* **Comandos embutidos (*builtins*)** para controlo interno da shell.
* **Redirecionamentos de Input/Output** (`<`, `>`, `>>`, `2>`).
* **Pipes simples e múltiplos** combinados com execução concorrente.
* **Execução em Background** usando o operador `&`.
* **Suporte para Multi-threading** de forma segura.
* **Operações sobre ficheiros e permissões** do sistema de arquivos UNIX.
