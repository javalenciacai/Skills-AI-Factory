# director-proyecto

Skill para agentes de código que convierte al agente en **director de proyecto**: solo orquesta, nunca ejecuta. Abre cada rol en un panel visible del multiplexor de terminal, elige el modelo según la tarea, sigue un proceso de entrega en 4 fases, exige acuse de recibo (ACK) en cada delegación y deja todo cerrado y limpio al terminar.

## Estructura

```
director-proyecto/
├── skills/director-proyecto/      # la skill (esto es lo que se instala)
│   ├── SKILL.md                   # comportamiento del director y reglas obligatorias
│   ├── references/
│   │   ├── entorno.md             # detección y aprendizaje del multiplexor, vigía, otros directores
│   │   ├── roles.md               # catálogo de roles con su contrato
│   │   ├── plantillas.md          # brief, reporte, STATUS.md, mensajes entre directores, checklist
│   │   └── proceso-4-fases.md     # Ruta de Entrega: Idea, DoR, DoD, Entrega
│   ├── scripts/
│   │   ├── estado.sh              # una línea por delegación: estado, antigüedad, alerta
│   │   └── vigia.sh               # supervisa sin gastar tokens y avisa al director
│   └── evals/                     # casos de prueba de la skill
├── instalar.ps1                   # instala la skill en el perfil del usuario
├── empaquetar.ps1                 # genera dist\director-proyecto.skill
├── CLAUDE.md                      # contexto para seguir trabajando la skill con un agente
└── PENDIENTES.md                  # lo que falta validar y mejorar
```

## Requisitos

- Un multiplexor de terminal (tmux, zellij, wezterm, wmux, orca, herdr u otro). La skill lo detecta y aprende a usarlo al inicio de cada sesión.
- Un harness de agente (por ejemplo, Claude Code).
- `bash` disponible para los scripts `estado.sh` y `vigia.sh`. En Windows: Git Bash o WSL.
- `git`, para los worktrees paralelos.

## Instalación (Windows, PowerShell)

```powershell
cd C:\james\director-proyecto
.\instalar.ps1            # crea un enlace: los cambios en el proyecto se reflejan de inmediato
.\instalar.ps1 -Copia     # o copia los archivos en lugar de enlazar
```

La skill queda en `%USERPROFILE%\.claude\skills\director-proyecto`. Para instalarla solo en un proyecto, cópiela en `<proyecto>\.claude\skills\`.

## Uso

Dentro de una sesión del multiplexor, abra el agente en el proyecto que quiere dirigir y pida, por ejemplo:

> Actúa como director de este proyecto. Necesito …

## Empaquetar

```powershell
.\empaquetar.ps1          # genera dist\director-proyecto.skill
```

## Pruebas

Los casos están en `skills/director-proyecto/evals/`. Con Claude Code, desde la carpeta de la skill: `claude plugin eval .` (consume modelo).
