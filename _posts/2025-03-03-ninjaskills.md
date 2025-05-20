---
title: "TryHackMe: Ninja Skills"
description: ""
author: c3n0r4
categories: [challenges, easy]
tags: [linux, find, regex, xargs, grep, stat, sha1sum]
render_with_liquid: false
---

Este desafio tem como objetivo analisar um conjunto de arquivos presentes no sistema. Você deverá responder a uma série de perguntas com base nas propriedades e no conteúdo dos seguintes arquivos: `8V2L`, `bny0`, `c4ZX`, `D8B3`, `FHl1`, `oiMO`, `PFbD`, `rmfX`, `SRSq`, `uqyw`, `v2Vb`, `X1Uy`. O foco é encontrar as respostas de forma *rápida* e *eficiente*.

Antes de iniciar o desafio, conectei-me à máquina disponibilizada via `ssh` e realizei uma busca para identificar o caminho absoluto de cada um dos arquivos listados.

```console
┌──(c3n0r4㉿kali)-[~/tryhackme/room/ninjaskills]
└─$ ssh new-user@10.10.72.186
new-user@10.10.72.186's password: 
Last login: Mon Mar 19 13:16:01 2025 from ip-10-6-47-63.eu-west-1.compute.internal
████████╗██████╗ ██╗   ██╗██╗  ██╗ █████╗  ██████╗██╗  ██╗███╗   ███╗███████╗
╚══██╔══╝██╔══██╗╚██╗ ██╔╝██║  ██║██╔══██╗██╔════╝██║ ██╔╝████╗ ████║██╔════╝
   ██║   ██████╔╝ ╚████╔╝ ███████║███████║██║     █████╔╝ ██╔████╔██║█████╗  
   ██║   ██╔══██╗  ╚██╔╝  ██╔══██║██╔══██║██║     ██╔═██╗ ██║╚██╔╝██║██╔══╝  
   ██║   ██║  ██║   ██║   ██║  ██║██║  ██║╚██████╗██║  ██╗██║ ╚═╝ ██║███████╗
   ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝
        Let the games begin!

[new-user@ip-10-10-72-186 ~]$ find / -type f -regex '.*/\(8V2L\|bny0\|c4ZX\|D8B3\|FH11\|oiMO\|PFbD\|rmfx\|SRSq\|uqyw\|v2Vb\|X1Uy\)$' -print 2>/dev/null > list-arq.txt
```

Caminhos dos arquivos gravados pela execução do comando acima.
```
/mnt/D8B3
/mnt/c4ZX
/var/log/uqyw
/opt/PFbD
/opt/oiMO
/etc/8V2L
/etc/ssh/SRSq
/home/v2Vb
/X1Uy
```
{: file='list-arq.txt'}

## Task 1 - Ninja Skills

> Quais dos arquivos acima são de propriedade do grupo _best-group_ (digite a resposta separada por espaços em ordem alfabética)

```console
[new-user@ip-10-10-72-186 ~]$ xargs -d '\n' -a list-arq.txt stat --format '%n %G' | grep best-group
/mnt/D8B3 best-group
/home/v2Vb best-group
```

> Qual desses arquivos contém um endereço _IP_?

```console
[new-user@ip-10-10-72-186 ~]$ xargs -d '\n' -a list-arq.txt grep -HoE '([0-9]{1,3}\.){3}[0-9]{1,3}'
/opt/oiMO:1.1.1.1
```

> Qual arquivo tem o _hash SHA1_ de 9d54da7584015647ba052173b84d45e8007eba94

```console
[new-user@ip-10-10-72-186 ~]$ xargs -d '\n' -a list-arq.txt sha1sum | grep 9d54da7584015647ba052173b84d45e8007eba94
9d54da7584015647ba052173b84d45e8007eba94  /mnt/c4ZX
```
> Qual proprietário do arquivo tem um _ID 502_?

```console
[new-user@ip-10-10-72-186 ~]$ xargs -d '\n' -a list-arq.txt stat --format '%n %u'| grep 502
/X1Uy 502
```

> Qual arquivo é executável por _todos_?

```console
[new-user@ip-10-10-72-186 ~]$ xargs -d '\n' -a list-arq.txt ls -la | grep "^-..x..x..x"
-rwxrwxr-x 1 new-user   new-user   13545 Oct 23  2019 /etc/8V2L
```

> Qual arquivo contém _230 linhas_?

```console
[new-user@ip-10-10-72-186 ~]$ xargs -d '\n' -a list-arq.txt wc -l | grep 230
[new-user@ip-10-10-72-186 ~]$ xargs -d '\n' -a list-arq.txt wc -l
   209 /mnt/D8B3
   209 /mnt/c4ZX
   209 /var/log/uqyw
   209 /opt/PFbD
   209 /opt/oiMO
   209 /etc/8V2L
   209 /etc/ssh/SRSq
   209 /home/v2Vb
   209 /X1Uy
  1881 total
```
Todos os 9 arquivos listados possuem exatamente 209 linhas, o que é um pouco incomum, mas ainda aceitável. No entanto, como todos esses arquivos já haviam sido utilizados em outras respostas exceto o `bny0`, resolvi testá-lo como possível resposta para esta questão. Funcionou corretamente, por isso optei por deixar essa pergunta por último no processo de resolução.


