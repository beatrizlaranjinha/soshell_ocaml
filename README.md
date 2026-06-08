Shell em OCaml

Implementação de uma shell simples em OCaml para a unidade curricular de Sistemas Operativos.

Requisitos

* OCaml
* Dune
* Biblioteca `Unix`
* Biblioteca `Threads`
* Biblioteca `Str`

 Compilar

+

```bash
dune build
```

## Executar

```bash
dune exec soshell_ocaml
```

Para sair da shell:

```bash
sair
```

---

# Testes principais

Os comandos seguintes devem ser executados dentro da SoShell.

## 1. Comandos básicos

```bash
obterinfo
```

```bash
quemsoueu
```

```bash
pwd
```

```bash
ls -l
```

```bash
echo ola
```

Teste de comando inexistente:

```bash
comando_que_nao_existe
```

A shell deve apresentar um erro sem terminar.

---

## 2. Alterar o prompt

```bash
PS1=MINHASHELL>
```

Teste com hostname:

```bash
PS1=\h>
```

Repor o prompt:

```bash
PS1=SOSHELL>
```

---

## 3. Mudança de diretório

```bash
cd ..
```

```bash
pwd
```

```bash
cd /tmp
```

```bash
cd -
```

```bash
cd
```

```bash
cd ~
```

```bash
cd $HOME
```

Teste de erro:

```bash
cd pasta_que_nao_existe
```

---

## 4. Preparar ficheiro de teste

```bash
echo primeira linha > origem.txt
```

```bash
echo segunda linha >> origem.txt
```

```bash
echo terceira linha >> origem.txt
```

```bash
cat origem.txt
```

---

## 5. Cópia de ficheiros com `socp`

```bash
socp origem.txt copia.txt
```

```bash
cat copia.txt
```

```bash
diff origem.txt copia.txt
```

Se os ficheiros forem iguais, o comando `diff` não apresenta qualquer saída.

---

## 6. Foreground e background

Foreground:

```bash
sleep 3
```

A shell deve ficar bloqueada durante três segundos.

Background:

```bash
sleep 10 &
```

O prompt deve reaparecer imediatamente.

```bash
ps
```

---

# Redirecionamentos

## Saída para ficheiro

```bash
ls > lista.txt
```

```bash
cat lista.txt
```

## Acrescentar ao ficheiro

```bash
echo primeira > append.txt
```

```bash
echo segunda >> append.txt
```

```bash
cat append.txt
```

## Entrada a partir de ficheiro

```bash
cat < origem.txt
```

```bash
wc -l < origem.txt
```

## Entrada e saída

```bash
cat < origem.txt > destino.txt
```

```bash
diff origem.txt destino.txt
```

## Redirecionamento de erros

```bash
ls ficheiro_inexistente 2> erros.txt
```

```bash
cat erros.txt
```

## Vários redirecionamentos

```bash
cat < origem.txt > resultado.txt 2> erros_resultado.txt
```

```bash
cat resultado.txt
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

## Pipes múltiplos

```bash
cat /etc/passwd | grep sh | wc -l
```

```bash
ls -l | grep .ml | wc -l
```

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
cat < origem.txt | grep linha | wc -l > total_filtrado.txt
```

```bash
cat total_filtrado.txt
```

## Pipeline em background

```bash
cat origem.txt | wc -l &
```

O prompt deve reaparecer imediatamente.

## Pipes inválidos

```bash
ls |
```

```bash
| wc
```

```bash
ls | | wc
```

A shell deve indicar erro de sintaxe sem terminar.

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

## Mostrar o maior ficheiro

```bash
maior pequeno.txt grande.txt
```

## Adicionar permissão de execução ao dono

```bash
ls -l pequeno.txt
```

```bash
setx pequeno.txt
```

```bash
ls -l pequeno.txt
```

## Remover leitura ao grupo e aos outros

```bash
chmod 644 pequeno.txt
```

```bash
removerl pequeno.txt
```

```bash
ls -l pequeno.txt
```

## Listagem rápida

```bash
sols
```

```bash
sols .
```

```bash
sols /tmp
```

A listagem apresenta o nome, inode, tamanho e data de modificação dos ficheiros.

---

# Threads

## Teste de aviso

```bash
aviso mensagem 2
```

A mensagem deve aparecer após aproximadamente dois segundos.

## Cópia com thread

```bash
socpthread origem.txt copia_thread.txt
```

```bash
diff origem.txt copia_thread.txt
```

## Informação das cópias

```bash
infoCopias
```

---

