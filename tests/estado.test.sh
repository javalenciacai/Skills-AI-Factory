#!/usr/bin/env bash
# Pruebas de scripts/estado.sh: una línea de entrada por caso, una línea de
# salida esperada. No depende de red ni de otras herramientas.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT/skills/director-proyecto/scripts/estado.sh"
fallos=0

assert_eq() {
  local nombre="$1" esperado="$2" obtenido="$3"
  if [ "$esperado" = "$obtenido" ]; then
    echo "OK: $nombre"
  else
    echo "FALLO: $nombre"
    echo "  esperado: $esperado"
    echo "  obtenido: $obtenido"
    fallos=$((fallos + 1))
  fi
}

# Caso del happy path documentado en CLAUDE.md.
D1=$(mktemp -d); mkdir -p "$D1/estado"
echo "LISTO|prueba" > "$D1/estado/t1"
out1=$("$SCRIPT" "$D1")
assert_eq "LISTO -> POR_LEER" "t1 LISTO 0m POR_LEER prueba" "$out1"
rm -rf "$D1"

# Estado desconocido reciente: se trata como ENVIADO, sin alerta todavía.
D2=$(mktemp -d); mkdir -p "$D2/estado"
echo "RECIBt2O|x" > "$D2/estado/t2"
out2=$(ACK_SEG=999999 "$SCRIPT" "$D2")
assert_eq "estado desconocido reciente -> sin alerta" "t2 RECIBt2O 0m - x" "$out2"
rm -rf "$D2"

# Estado desconocido "viejo" (archivo con fecha de modificación forzada al
# pasado, para no depender del reloj): mismo tratamiento que ENVIADO, así que
# dispara SIN_ACK igual que un ENVIADO sin acusar.
D3=$(mktemp -d); mkdir -p "$D3/estado"
echo "RECIBt2O|x" > "$D3/estado/t3"
touch -d '@0' "$D3/estado/t3" 2>/dev/null || touch -t 197001010000 "$D3/estado/t3"
out3=$(ACK_SEG=0 "$SCRIPT" "$D3")
campos3=$(echo "$out3" | awk '{print $1, $2, $4, $5}')
assert_eq "estado desconocido + viejo -> SIN_ACK" "t3 RECIBt2O SIN_ACK x" "$campos3"
rm -rf "$D3"

if [ "$fallos" -eq 0 ]; then
  echo "estado.test.sh: todo OK"
  exit 0
else
  echo "estado.test.sh: $fallos fallo(s)"
  exit 1
fi
