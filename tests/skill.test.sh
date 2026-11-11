#!/usr/bin/env bash
# Pruebas de forma sobre skills/director-proyecto: frontmatter, tamaño del
# SKILL.md y que no se cuelen nombres de modelo de un proveedor concreto.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_MD="$ROOT/skills/director-proyecto/SKILL.md"
fallos=0

check() {
  local nombre="$1" ok="$2"
  if [ "$ok" -eq 0 ]; then
    echo "OK: $nombre"
  else
    echo "FALLO: $nombre"
    fallos=$((fallos + 1))
  fi
}

rc=0; grep -q '^name: director-proyecto$' "$SKILL_MD" || rc=1
check "frontmatter name: director-proyecto" "$rc"

desc_len=$(awk '/^description:/{sub(/^description: /,""); print length($0)}' "$SKILL_MD")
rc=0; { [ -n "$desc_len" ] && [ "$desc_len" -le 1024 ]; } || rc=1
check "description <= 1024 caracteres (actual: ${desc_len:-?})" "$rc"

lineas=$(wc -l < "$SKILL_MD")
rc=0; [ "$lineas" -lt 500 ] || rc=1
check "SKILL.md < 500 líneas (actual: $lineas)" "$rc"

# Nombres concretos de modelo por proveedor están prohibidos; nombres de
# familia (Anthropic, OpenAI, Google, MiniMax, ...) sí están permitidos.
if grep -riE 'haiku|sonnet|opus|gpt-[0-9]|gemini-[0-9]|minimax-m[0-9]|llama-?[0-9]|deepseek-|qwen[0-9]' "$ROOT/skills" >/dev/null; then
  check "sin nombres de modelo de proveedor en skills/" 1
else
  check "sin nombres de modelo de proveedor en skills/" 0
fi

# La palabra "Claude" como marca tampoco debe colarse: la skill es
# agnóstica de harness. Se excluyen tres usos legítimos que no son una
# mención de marca: el nombre de archivo `CLAUDE.md` (convención de
# contexto, igual que `AGENTS.md`), la ruta de instalación real de
# skills (`.claude\skills` / `.claude/skills`) y las listas neutrales de
# binarios de harness que mencionan varios proveedores a la vez (se
# detectan porque esa misma línea también nombra `codex` y `gemini`).
claude_hits=$(grep -rwi 'claude' "$ROOT/skills" \
  | grep -viE 'claude\.md' \
  | grep -viE '\.claude[\\/]skills' \
  | grep -v -i 'codex' )
if [ -n "$claude_hits" ]; then
  check "sin menciones de Claude como marca en skills/" 1
else
  check "sin menciones de Claude como marca en skills/" 0
fi

if [ "$fallos" -eq 0 ]; then
  echo "skill.test.sh: todo OK"
  exit 0
else
  echo "skill.test.sh: $fallos fallo(s)"
  exit 1
fi
