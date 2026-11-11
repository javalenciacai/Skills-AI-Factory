#!/usr/bin/env bash
# Vigía: supervisa las delegaciones sin gastar tokens. Corre en un panel visible del grupo "director".
# Solo avisa al director cuando hay una novedad (SIN_ACK, SILENCIO, POR_LEER); mientras todo va bien, no dice nada.
# Uso: DIRECTOR_AVISO='<comando con {msg}>' vigia.sh <ruta-absoluta-.director> [intervalo_seg]
#   Ejemplo tmux: DIRECTOR_AVISO="tmux send-keys -t %0 '{msg}' Enter"
#   Sin DIRECTOR_AVISO solo imprime en su propio panel.
# Se detiene al crear <dir>/estado/.parar
set -u
DIR="${1:?ruta de .director}"; INT="${2:-30}"
AQUI="$(cd "$(dirname "$0")" && pwd)"; MEMO="$DIR/estado/.avisados"
mkdir -p "$DIR/estado"; : > "$MEMO"; rm -f "$DIR/estado/.parar"
echo "[vigia] activo sobre $DIR cada ${INT}s"
while [ ! -f "$DIR/estado/.parar" ]; do
  while read -r id est edad alerta nota; do
    [ -z "${id:-}" ] && continue; [ "$alerta" = "-" ] && continue
    clave="$id:$est:$alerta"
    grep -qxF "$clave" "$MEMO" && continue
    echo "$clave" >> "$MEMO"
    msg="[vigia] $id $alerta ($est, ${edad})"
    echo "$(date +%H:%M:%S) $msg"
    if [ -n "${DIRECTOR_AVISO:-}" ]; then eval "${DIRECTOR_AVISO//\{msg\}/$msg}" || echo "[vigia] no pude avisar al director"; fi
  done < <("$AQUI/estado.sh" "$DIR")
  sleep "$INT"
done
echo "[vigia] detenido"
