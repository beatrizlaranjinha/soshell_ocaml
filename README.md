# shell em ocaml

implementação de uma shell simples em ocaml para a unidade curricular de sistemas operativos.

requisitos: ocaml, dune, biblioteca unix, biblioteca threads, biblioteca str

---

compilar

```bash
dune build
```

executar

```bash
dune exec soshell_ocaml
```

para sair

```bash
sair
```

---

## comandos básicos

```bash
obterinfo
quemsoueu
pwd
ls -l
echo ola
comando_que_nao_existe
```

---

## alterar o prompt

```bash
PS1=MINHASHELL>
PS1=\h>
PS1=SOSHELL>
```

---

## mudança de diretório

```bash
cd ..
pwd
cd /tmp
cd -
cd
cd ~
cd $HOME
cd pasta_que_nao_existe
```

---

## preparar ficheiro de teste

```bash
echo primeira linha > origem.txt
echo segunda linha >> origem.txt
echo terceira linha >> origem.txt
cat origem.txt
```

---

## cópia de ficheiros com socp

```bash
socp origem.txt copia.txt
cat copia.txt
diff origem.txt copia.txt
```

---

## foreground e background

```bash
sleep 3
sleep 10 &
ps
```

---

## redirecionamentos

```bash
ls > lista.txt
cat lista.txt
echo primeira > append.txt
echo segunda >> append.txt
cat append.txt
cat < origem.txt
wc -l < origem.txt
cat < origem.txt > destino.txt
diff origem.txt destino.txt
ls ficheiro_inexistente 2> erros.txt
cat erros.txt
cat < origem.txt > resultado.txt 2> erros_resultado.txt
cat resultado.txt
```

---

## pipes

```bash
ls | wc -l
cat origem.txt | wc -l
cat /etc/passwd | grep root
cat /etc/passwd | grep sh | wc -l
ls -l | grep .ml | wc -l
cat < origem.txt | wc -l
cat origem.txt | wc -l > total.txt
cat total.txt
cat < origem.txt | grep linha | wc -l > total_filtrado.txt
cat total_filtrado.txt
cat origem.txt | wc -l &
ls |
| wc
ls | | wc
```

---

## operações sobre ficheiros

```bash
echo pequeno > pequeno.txt
yes linha | head -n 1000 > grande.txt
maior pequeno.txt grande.txt
ls -l pequeno.txt
setx pequeno.txt
ls -l pequeno.txt
chmod 644 pequeno.txt
removerl pequeno.txt
ls -l pequeno.txt
sols
sols .
sols /tmp
```

---

## threads

```bash
aviso mensagem 2
socpthread origem.txt copia_thread.txt
diff origem.txt copia_thread.txt
infoCopias
```
