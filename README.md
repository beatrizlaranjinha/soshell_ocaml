# SoShell em OCaml

Implementação de uma shell simples em OCaml para a unidade curricular de Sistemas Operativos.



# Compilação

Na raiz do projeto:

```bash
dune build
```

---

# Execução

```bash
dune exec soshell_ocaml
```

Para sair:

```bash
sair
```

---

# Testes principais

Os comandos seguintes devem ser executados dentro da SoShell.

---

## Comandos básicos

```bash
obterinfo
```

Mostra a versão da SoShell.

```bash
quemsoueu
```

Mostra o utilizador atual.

```bash
pwd
```

Mostra a diretoria atual.

```bash
ls
```

Lista os ficheiros.

```bash
ls -l
```

Lista os ficheiros com detalhes.

```bash
echo ola
```

Teste de comando inexistente:

```bash
comando_que_nao_existe
```

A shell deve apresentar erro sem terminar.

---

## Alteração do prompt

Mudar o prompt:

```bash
PS1=MINHASHELL>
```

Usar o hostname:

```bash
PS1=\h>
```

Voltar ao prompt original:

```bash
PS1=SOSHELL>
```

---

## Mudança de diretoria

Subir uma diretoria:

```bash
cd ..
```

Verificar:

```bash
pwd
```

Ir para `/tmp`:

```bash
cd /tmp
```

Voltar à diretoria anterior:

```bash
cd -
```

Ir para a diretoria pessoal:

```bash
cd
```

```bash
cd ~
```

```bash
cd $HOME
```

Testar diretoria inexistente:

```bash
cd pasta_que_nao_existe
```

---

# Criação de ficheiros de teste

Criar ficheiro de origem:

```bash
echo primeira linha > origem.txt
```

Adicionar mais conteúdo:

```bash
echo segunda linha >> origem.txt
```

```bash
echo terceira linha >> origem.txt
```

Confirmar:

```bash
cat origem.txt
```

---

# Cópia de ficheiros com `socp`

Copiar ficheiro:

```bash
socp origem.txt copia.txt
```

Ver conteúdo:

```bash
cat copia.txt
```

Comparar ficheiros:

```bash
diff origem.txt copia.txt
```

Se não aparecer nada, os ficheiros são iguais.

Testar erro:

```bash
socp ficheiro_inexistente.txt copia.txt
```

Testar sintaxe incorreta:

```bash
socp origem.txt
```

---

# Cópia de ficheiros com threads

Criar uma cópia numa thread:

```bash
socpthread origem.txt copia_thread.txt
```

Esperar um momento:

```bash
sleep 1
```

Verificar conteúdo:

```bash
cat copia_thread.txt
```

Comparar ficheiros:

```bash
diff origem.txt copia_thread.txt
```

Indicar tamanho de bloco:

```bash
socpthread origem.txt copia_thread2.txt 2048
```

Esperar:

```bash
sleep 1
```

Comparar:

```bash
diff origem.txt copia_thread2.txt
```

Mostrar histórico das cópias:

```bash
infoCopias
```

Teste de bloco inválido:

```bash
socpthread origem.txt copia_thread.txt 0
```

```bash
socpthread origem.txt copia_thread.txt abc
```

---

# Avisos

## Aviso bloqueante

```bash
avisoTeste mensagem 3
```

A shell fica bloqueada durante 3 segundos.

## Aviso incorreto com thread

```bash
avisomau teste 3
```

A shell mostra o prompt imediatamente e a mensagem aparece depois.

Teste de erro:

```bash
avisomau teste abc
```

```bash
avisomau teste
```

## Aviso correto com thread

```bash
aviso mensagem 3
```

A shell continua disponível e a mensagem aparece depois de 3 segundos.

---

# Foreground

```bash
sleep 3
```

A shell deve ficar bloqueada durante 3 segundos.

---

# Background

```bash
sleep 10 &
```

A shell deve mostrar imediatamente algo semelhante a:

```text
[background] pid 12345
```

Confirmar processo:

```bash
ps
```

Confirmar que a shell continua disponível:

```bash
echo shell continua disponivel
```

Outro teste:

```bash
ls &
```

---

# Redirecionamentos

## Redirecionamento de saída `>`

```bash
ls > lista.txt
```

```bash
cat lista.txt
```

Substituir conteúdo:

```bash
echo novo conteudo > lista.txt
```

```bash
cat lista.txt
```

---

## Redirecionamento em modo append `>>`

```bash
echo primeira > texto.txt
```

```bash
echo segunda >> texto.txt
```

```bash
echo terceira >> texto.txt
```

```bash
cat texto.txt
```

---

## Redirecionamento de entrada `<`

```bash
cat < texto.txt
```

```bash
wc -l < texto.txt
```

```bash
wc -c < texto.txt
```

---

## Redirecionamento de erro `2>`

```bash
ls ficheiro_inexistente 2> erros.txt
```

```bash
cat erros.txt
```

---

## Vários redirecionamentos

```bash
cat < texto.txt > copia_texto.txt
```

```bash
cat copia_texto.txt
```

```bash
diff texto.txt copia_texto.txt
```

```bash
cat < texto.txt >> copia_texto.txt 2> erros2.txt
```

---

## Redirecionamento em background

```bash
ls > lista_background.txt &
```

```bash
sleep 1
```

```bash
cat lista_background.txt
```

---

# Pipes

## Pipe simples

```bash
ls | wc -l
```

```bash
cat origem.txt | wc -l
```

```bash
cat /etc/passwd | grep root
```

```bash
ls -l | grep .ml
```

---

## Pipes múltiplos

```bash
cat /etc/passwd | grep sh | wc -l
```

```bash
ls -l | grep .ml | wc -l
```

```bash
cat origem.txt | grep linha | wc -l
```

---

## Pipes com redirecionamentos

```bash
cat < origem.txt | wc -l
```

```bash
cat origem.txt | wc -l > total.txt
```

```bash
cat total.txt
```

```bash
cat < origem.txt | grep linha > linhas_filtradas.txt
```

```bash
cat linhas_filtradas.txt
```

```bash
cat < origem.txt | grep linha | wc -l > total_filtrado.txt
```

```bash
cat total_filtrado.txt
```

---

## Pipeline em background

```bash
cat origem.txt | wc -l &
```

```bash
ls | wc -l &
```

---

## Erros de sintaxe em pipes

```bash
ls |
```

```bash
| wc
```

```bash
ls | | wc
```

A shell deve apresentar erro sem terminar.

---

# Calculadora

## Soma

```bash
calc 10 + 5
```

## Subtração

```bash
calc 10 - 3
```

## Multiplicação

```bash
calc 4 * 5
```

## Divisão

```bash
calc 10 / 2
```

## Potência

```bash
calc 2 ^ 8
```

## Decimais

```bash
calc 2.5 + 3.7
```

## Número negativo

```bash
calc -5 + 2
```

## Divisão por zero

```bash
calc 10 / 0
```

## Operador inválido

```bash
calc 10 % 3
```

---

# Calculadora de bits

## AND

```bash
bits 12 & 10
```

Resultado esperado:

```text
Resultado bits 12 & 10 = 8
```

## OR

```bash
bits 12 | 10
```

Resultado esperado:

```text
Resultado bits 12 | 10 = 14
```

## XOR

```bash
bits 12 ^ 10
```

Resultado esperado:

```text
Resultado bits 12 ^ 10 = 6
```

## Deslocamento à direita

```bash
bits 8 >> 1
```

Resultado esperado:

```text
Resultado bits 8 >> 1 = 4
```

## Deslocamento à esquerda

```bash
bits 2 << 3
```

Resultado esperado:

```text
Resultado bits 2 << 3 = 16
```

---

# Epsilon da máquina

```bash
epsilon
```

Mostra o epsilon da biblioteca e o valor calculado.

---

# Verificação de ficheiros JPEG

A imagem pode estar na raiz do projeto ou noutra pasta.

Se estiver na pasta `bin`:

```bash
isjpeg bin/lena.jpg
```

Resultado esperado:

```text
bin/lena.jpg is a JPEG file
```

Testar um ficheiro que não é JPEG:

```bash
isjpeg bin/main.ml
```

Resultado esperado:

```text
bin/main.ml is NOT a JPEG file
```

Testar ficheiro inexistente:

```bash
isjpeg nao_existe.jpg
```

---

# Operações sobre ficheiros

## Criar ficheiros de tamanhos diferentes

```bash
echo pequeno > pequeno.txt
```

No macOS:

```bash
yes linha | head -n 1000 > grande.txt
```

---

## Mostrar o maior ficheiro

```bash
maior pequeno.txt grande.txt
```

---

## Adicionar execução ao dono

Ver permissões:

```bash
ls -l pequeno.txt
```

Adicionar execução:

```bash
setx pequeno.txt
```

Confirmar:

```bash
ls -l pequeno.txt
```

---

## Remover leitura ao grupo e aos outros

Preparar permissões:

```bash
chmod 644 pequeno.txt
```

Confirmar:

```bash
ls -l pequeno.txt
```

Remover leitura:

```bash
removerl pequeno.txt
```

Confirmar:

```bash
ls -l pequeno.txt
```

---

## Listagem rápida

Diretoria atual:

```bash
sols
```

```bash
sols .
```

Outra diretoria:

```bash
sols /tmp
```

Diretoria inexistente:

```bash
sols pasta_que_nao_existe
```

A listagem mostra:

* nome;
* inode;
* tamanho;
* data da última modificação.

---

# Histórico

A shell não possui histórico geral de comandos.

Existe apenas histórico das cópias realizadas com `socpthread`.

Para consultar:

```bash
infoCopias
```

---

# Executáveis auxiliares

## Simulação de pipe

```bash
dune exec pipe_sim
```

Executa uma simulação equivalente a:

```bash
ls -l -a | wc -c
```

## Programa de threads

```bash
dune exec threads
```

Cria vários domínios e espera que o utilizador carregue em Enter.

---

# Limpeza dos ficheiros de teste

Depois de sair da SoShell:

```bash
sair
```

Executar no terminal normal:

```bash
rm -f \
origem.txt \
copia.txt \
copia_thread.txt \
copia_thread2.txt \
lista.txt \
lista_background.txt \
texto.txt \
copia_texto.txt \
erros.txt \
erros2.txt \
total.txt \
total_filtrado.txt \
linhas_filtradas.txt \
pequeno.txt \
grande.txt
```

Limpar ficheiros compilados:

```bash
dune clean
```

---

# Verificação final

```bash
dune build
```

```bash
git status
```

---

# Comandos principais da SoShell

| Comando      | Função                           |
| ------------ | -------------------------------- |
| `sair`       | Termina a shell                  |
| `obterinfo`  | Mostra a versão                  |
| `PS1=`       | Altera o prompt                  |
| `quemsoueu`  | Mostra o utilizador              |
| `cd`         | Muda de diretoria                |
| `socp`       | Copia ficheiros                  |
| `socpthread` | Copia ficheiros com thread       |
| `infoCopias` | Mostra o histórico das cópias    |
| `avisoTeste` | Aviso bloqueante                 |
| `avisomau`   | Aviso com thread incorreta       |
| `aviso`      | Aviso com thread correta         |
| `epsilon`    | Calcula o epsilon                |
| `calc`       | Calculadora normal               |
| `bits`       | Calculadora de bits              |
| `isjpeg`     | Verifica se um ficheiro é JPEG   |
| `maior`      | Mostra o maior ficheiro          |
| `setx`       | Adiciona execução ao dono        |
| `removerl`   | Remove leitura ao grupo e outros |
| `sols`       | Lista uma diretoria              |
