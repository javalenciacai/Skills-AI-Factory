#!/usr/bin/env bash
# Resumen barato del estado de las delegaciones. Una línea por tarea.
# Uso: estado.sh <ruta-absoluta-.director> [--todo]
# Archivos: <dir>/estado/<id>        -> "ESTADO|nota"  (ENVIADO, RECIBIDO, EN_CURSO, LISTO, BLOQUEADO, LEIDO)
#           <dir>/estado/<id>.plazo  -> minutos máximos sin latido (opcional, por defecto 15)
# Alertas: SIN_ACK (ENVIADO sin acuse tras ACK_SEG), SILENCIO (sin latido tras el plazo), POR_LEER (LISTO/BLOQUEADO sin leer)
# Estado no reconocido: se trata como ENVIADO (dispara SIN_ACK tras ACK_SEG).
set -u
DIR="${1:?ruta de .director}"; TODO="${2:-}"
ACK_SEG="${ACK_SEG:-120}"; PLAZO_DEF="${PLAZO_MIN:-15}"
now=$(date +%s); shopt -s nullglob
for f in "$DIR"/estado/*; do
  case "$f" in *.plazo) continue;; esac
  id=$(basename "$f"); IFS='|' read -r est nota < "$f" || true
  m=$(stat -c %Y "$f" 2>/dev/null || stat -f %m "$f"); edad=$(( now - m ))
  plazo=$PLAZO_DEF; [ -f "$f.plazo" ] && plazo=$(cat "$f.plazo")
  alerta="-"
  case "$est" in
    ENVIADO) [ "$edad" -gt "$ACK_SEG" ] && alerta="SIN_ACK";;
    RECIBIDO|EN_CURSO) [ "$edad" -gt $(( plazo*60 )) ] && alerta="SILENCIO";;
    LISTO|BLOQUEADO) alerta="POR_LEER";;
    LEIDO) [ "$TODO" = "--todo" ] || continue;;
    # Un estado no reconocido (típicamente un error de tipeo del rol al
    # escribir el archivo) se trata como ENVIADO: un acuse mal escrito sigue
    # siendo un acuse faltante, y el director necesita verlo igual.
    *) [ "$edad" -gt "$ACK_SEG" ] && alerta="SIN_ACK";;
  esac
  printf '%s %s %sm %s %s\n' "$id" "$est" "$(( edad/60 ))" "$alerta" "${nota:0:60}"
done
