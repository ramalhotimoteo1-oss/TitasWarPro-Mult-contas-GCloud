#!/bin/sh
# screen_play.sh — Inicia o TWM Multi-contas dentro de uma sessão screen
# Isso garante que o bot continue rodando após você desconectar do SSH
#
# USO:
#   ./screen_play.sh           -> inicia normalmente
#   ./screen_play.sh -cl       -> modo coliseum
#   screen -r twm              -> reconectar ao painel
#   screen -ls                 -> listar sessões ativas

SESSION="twm"

_dir=$(dirname "$0")
TWMDIR=$(cd "$_dir" && pwd)
unset _dir

RUN="${1:--boot}"

# Verifica se screen está instalado
if ! command -v screen > /dev/null 2>&1; then
    printf "ERRO: 'screen' não encontrado.\n"
    printf "Instale com: sudo apt-get install screen\n"
    exit 1
fi

# Verifica se já existe uma sessão com esse nome
if screen -ls | grep -q "\.${SESSION}[[:space:]]"; then
    printf "AVISO: Já existe uma sessão screen chamada '%s'.\n" "$SESSION"
    printf "Para reconectar: screen -r %s\n" "$SESSION"
    printf "Para matar e reiniciar: screen -S %s -X quit  e depois rode novamente.\n" "$SESSION"
    exit 0
fi

printf "Iniciando TWM dentro de screen (sessão: %s)...\n" "$SESSION"
printf "Para reconectar depois de desconectar o SSH:\n"
printf "   screen -r %s\n\n" "$SESSION"

# Inicia screen desanexado executando play.sh
screen -dmS "$SESSION" sh "$TWMDIR/play.sh" "$RUN"

sleep 2

if screen -ls | grep -q "\.${SESSION}[[:space:]]"; then
    printf "[OK] Sessão '%s' iniciada com sucesso!\n" "$SESSION"
    printf "\nComandos úteis:\n"
    printf "  Reconectar ao painel:   screen -r %s\n" "$SESSION"
    printf "  Ver logs de uma conta:  tail -f ~/.twm/BR_SeuNick/twm.log\n"
    printf "  Parar tudo:             ./stop.sh\n"
    printf "  Sair do painel (sem parar): Ctrl+A  depois  D\n"
else
    printf "[ERRO] Sessão não iniciou. Verifique erros acima.\n"
    exit 1
fi
