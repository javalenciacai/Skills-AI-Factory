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

# ENVIADO viejo (más antiguo que ACK_SEG): dispara SIN_ACK, aún sin acuse.
D4=$(mktemp -d); mkdir -p "$D4/estado"
echo "ENVIADO|brief enviado" > "$D4/estado/t4"
touch -d '@0' "$D4/estado/t4" 2>/dev/null || touch -t 197001010000 "$D4/estado/t4"
out4=$(ACK_SEG=0 "$SCRIPT" "$D4")
campos4=$(echo "$out4" | awk '{print $1, $2, $4}')
assert_eq "ENVIADO viejo -> SIN_ACK" "t4 ENVIADO SIN_ACK" "$campos4"
rm -rf "$D4"

# RECIBIDO con plazo de 1 minuto y mtime muy en el pasado: dispara SILENCIO.
D5=$(mktemp -d); mkdir -p "$D5/estado"
echo "RECIBIDO|entendido" > "$D5/estado/t5"
echo "1" > "$D5/estado/t5.plazo"
touch -d '@0' "$D5/estado/t5" 2>/dev/null || touch -t 197001010000 "$D5/estado/t5"
out5=$("$SCRIPT" "$D5")
campos5=$(echo "$out5" | awk '{print $1, $2, $4}')
assert_eq "RECIBIDO + plazo vencido -> SILENCIO" "t5 RECIBIDO SILENCIO" "$campos5"
rm -rf "$D5"

# BLOQUEADO siempre dispara POR_LEER, igual que LISTO.
D6=$(mktemp -d); mkdir -p "$D6/estado"
echo "BLOQUEADO|falta acceso" > "$D6/estado/t6"
out6=$("$SCRIPT" "$D6")
campos6=$(echo "$out6" | awk '{print $1, $2, $4}')
assert_eq "BLOQUEADO -> POR_LEER" "t6 BLOQUEADO POR_LEER" "$campos6"
rm -rf "$D6"

# LEIDO: oculto por defecto, visible (sin alerta) con --todo.
D7=$(mktemp -d); mkdir -p "$D7/estado"
echo "LEIDO|cerrado" > "$D7/estado/t7"
out7=$("$SCRIPT" "$D7")
assert_eq "LEIDO oculto sin --todo" "" "$out7"
out7todo=$("$SCRIPT" "$D7" --todo)
campos7todo=$(echo "$out7todo" | awk '{print $1, $2, $4}')
assert_eq "LEIDO visible con --todo, sin alerta" "t7 LEIDO -" "$campos7todo"
rm -rf "$D7"

if [ "$fallos" -eq 0 ]; then
  echo "estado.test.sh: todo OK"
  exit 0
else
  echo "estado.test.sh: $fallos fallo(s)"
  exit 1
fi
