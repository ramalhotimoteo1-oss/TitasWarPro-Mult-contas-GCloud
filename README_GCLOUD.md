# TitasWarPro — Google Cloud SSH (Tutorial Completo)

Versão adaptada do TitansWarPro-Mult-contas para rodar em instância **SSH do Google Cloud**
(Debian/Ubuntu) sem desligar quando você fechar o terminal.

---

## ✅ O que foi adaptado

| Mudança | Motivo |
|---|---|
| Removido `termux-wake-lock` | Comando exclusivo do Termux/Android |
| Adicionado `install_gcloud.sh` | Instala dependências no Debian/Ubuntu |
| Adicionado `screen_play.sh` | Mantém o bot rodando após desconectar o SSH |
| Todos os scripts originais preservados | Lógica do jogo intacta |

---

## 🚀 Passo a Passo

### 1. Conectar na instância

```bash
# Via Google Cloud Console → SSH   OU
gcloud compute ssh nome-da-instancia
```

---

### 2. Clonar / enviar os arquivos

Opção A — enviar via SCP o zip:
```bash
gcloud compute scp TitasWarPro-Mult-contas-main.zip nome-da-instancia:~
```

Opção B — clonar direto na instância:
```bash
git clone https://github.com/ramalhotimoteo1-oss/TitasWarPro-Mult-contas.git ~/twm
```

Descompactar se usou o zip:
```bash
cd ~
unzip TitasWarPro-Mult-contas-main.zip
mv TitasWarPro-Mult-contas-main twm
cd twm
```

---

### 3. Instalar dependências

```bash
chmod +x install_gcloud.sh
./install_gcloud.sh
```

Isso instala: `curl`, `wget`, `git`, `screen`, `tmux`, `dos2unix`, etc.

---

### 4. Dar permissão a todos os scripts

```bash
chmod +x *.sh
dos2unix *.sh 2>/dev/null || true
```

---

### 5. Cadastrar suas contas

```bash
./setup.sh
```

Siga o menu interativo:
- Opção `2` → Adicionar conta
- Escolha o servidor (1 = BR)
- Digite usuário e senha

As contas ficam salvas em `accounts.conf`.

---

### 6. Iniciar o bot (com screen — NÃO para ao fechar SSH)

```bash
./screen_play.sh
```

Isso abre o bot dentro de uma sessão **screen** chamada `twm`.  
Você pode fechar o terminal tranquilamente — o bot continua rodando.

Para reconectar ao painel depois:
```bash
screen -r twm
```

Para sair do painel **sem parar o bot**: pressione `Ctrl+A` depois `D`

---

### 7. Comandos do dia a dia

```bash
# Reconectar ao painel visual
screen -r twm

# Ver log de uma conta específica
tail -f ~/.twm/BR_SeuNick/twm.log

# Listar sessões screen ativas
screen -ls

# Parar todos os workers
./stop.sh

# Parar a sessão screen também
screen -S twm -X quit
```

---

## 🔁 Reiniciar após reboot da VM

Se a VM reiniciar, o screen e os workers param. Para religar:

```bash
cd ~/twm
./screen_play.sh
```

**Opcional — iniciar automaticamente no boot:**

```bash
crontab -e
```

Adicione a linha:
```
@reboot sleep 30 && cd /home/SEU_USUARIO/twm && screen -dmS twm sh play.sh
```

---

## 🛠️ Solução de problemas

| Problema | Solução |
|---|---|
| `command not found: screen` | `sudo apt-get install screen` |
| `command not found: curl` | `sudo apt-get install curl` |
| Sessão screen já existe | `screen -S twm -X quit` e reinicie |
| Login falhou no setup | IP do GCloud pode ser bloqueado pelo servidor — salve mesmo assim, o bot funciona |
| Worker com status ERRO | `tail -f ~/.twm/TAG_NICK/twm.log` para ver o motivo |

---

## 📁 Estrutura de arquivos

```
~/twm/
├── accounts.conf          ← suas contas (criado pelo setup.sh)
├── install_gcloud.sh      ← instalar dependências (rodar 1x)
├── screen_play.sh         ← INICIAR o bot (use este!)
├── play.sh                ← orquestrador principal
├── worker.sh              ← gerencia cada conta
├── twm.sh                 ← lógica da conta individual
├── setup.sh               ← cadastrar/remover contas
└── stop.sh                ← parar tudo

~/.twm/
├── BR_NickDaConta/
│   ├── twm.log            ← log da conta
│   ├── cookie.txt         ← sessão HTTP
│   └── config.cfg         ← configurações da conta
└── status/
    ├── BR_Nick.status     ← estado atual
    └── BR_Nick.pid        ← PID do worker
```
