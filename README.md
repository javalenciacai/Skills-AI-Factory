# Skills-AI-Factory

Catálogo de skills para agentes de código (Claude Code, Codex, Cursor, OpenCode y cualquier agente compatible con el formato `SKILL.md`). Cada skill vive en `skills/<nombre>/` y se instala con una sola orden.

## Instalación

Instalar todas las skills del catálogo:

```bash
npx skills add javalenciacai/Skills-AI-Factory
```

Instalar una skill concreta para un agente concreto (ejemplo: Claude Code), disponible en todos los proyectos:

```bash
npx skills add javalenciacai/Skills-AI-Factory --skill director-proyecto -a claude-code -g
```

Sin `-g` la skill se instala solo en el proyecto actual. Catálogo en línea: <https://skills.sh/javalenciacai/Skills-AI-Factory>.

## Skills disponibles

| Skill | Qué hace |
|-------|----------|
| [`director-proyecto`](skills/director-proyecto/) | Convierte al agente en director de proyecto que solo orquesta: abre cada rol en un panel del multiplexor, elige el modelo por tarea, sigue un proceso de entrega en 4 fases, exige acuse de recibo (ACK) y deja todo cerrado y limpio. |

## Estructura

```
Skills-AI-Factory/
├── skills/
│   └── <nombre>/
│       ├── SKILL.md        # obligatorio: frontmatter name + description, y las instrucciones
│       ├── README.md       # documentación de la skill
│       ├── references/     # detalle que SKILL.md referencia
│       ├── scripts/        # utilidades que la skill ejecuta
│       └── evals/          # casos de prueba
├── instalar.ps1            # instalación local en Windows (enlace o copia)
├── empaquetar.ps1          # genera dist\<nombre>.skill
├── CLAUDE.md               # contexto para trabajar el catálogo con un agente
└── PENDIENTES.md           # lo que falta validar y mejorar
```

## Instalación local en Windows (desarrollo)

```powershell
.\instalar.ps1            # enlaza skills\director-proyecto en %USERPROFILE%\.claude\skills
.\instalar.ps1 -Copia     # copia en lugar de enlazar
.\empaquetar.ps1          # genera dist\director-proyecto.skill
```

## Añadir una skill nueva

1. Crear `skills/<nombre>/SKILL.md` con frontmatter `name` (minúsculas y guiones) y `description` (máximo 1024 caracteres).
2. Mantener `SKILL.md` por debajo de 500 líneas; el detalle va en `references/`.
3. Añadir la fila en la tabla de arriba.

## Licencia

MIT.
