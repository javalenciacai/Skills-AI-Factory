# Detección del entorno

Ejecute estos pasos al inicio de la sesión. El objetivo es saber cómo abrir paneles, cómo lanzar agentes en ellos y con qué modelos, sin preguntarle al usuario.

## 1. Multiplexor activo

Revise primero si la sesión actual ya corre dentro de un multiplexor; ese es el que debe usar.

```bash
env | grep -E '^(TMUX|ZELLIJ|WEZTERM_PANE|KITTY_WINDOW_ID|WMUX|ORCA|HERDR)' || true
echo "TERM_PROGRAM=$TERM_PROGRAM"
```

Si no hay ninguno activo, revise cuáles están instalados:

```bash
for c in tmux zellij wezterm kitty wmux orca herdr screen; do command -v "$c" >/dev/null && echo "disponible: $c"; done
```

Prioridad: el multiplexor activo; si no hay, el primero disponible que soporte crear paneles y enviarles texto. Si no hay ninguno, no delegue: aplique la regla obligatoria de SKILL.md (relanzar dentro de un multiplexor o instalar uno).

Registre el identificador de su propio panel para no usarlo nunca como destino:

```bash
echo "panel del director: ${TMUX_PANE:-${WEZTERM_PANE:-desconocido}}"
```

## 2. Aprender a operar el multiplexor (obligatorio en cada sesión)

Cada multiplexor trabaja distinto, así que este paso se hace siempre, incluso con multiplexores conocidos.

Obtenga la versión (`<comando> --version` o `-V`) y la ayuda (`<comando> --help`, y luego la de los subcomandos que parezcan relevantes: `action`, `cli`, `pane`, `agent`, `workspace` o similares). Con eso responda:

- ¿Cómo se crea un panel y cómo se obtiene su identificador?
- ¿Se puede lanzar un proceso directamente al crear el panel, o hay que enviarlo como texto después?
- ¿Cómo se envía texto o una tecla Enter a un panel específico?
- ¿Cómo se lee la salida de un panel (captura de pantalla, volcado a archivo, historial)?
- ¿Cómo se titula y cómo se cierra?
- ¿Cómo se crea una agrupación visible (pestaña, ventana, espacio de trabajo) y cómo se titula?
- ¿Cómo se abre un panel con un directorio de trabajo específico (el del worktree)?
- ¿Cómo se aplica una distribución ordenada (mosaico u otra) a los paneles de una agrupación?
- ¿Cómo se asegura que lo creado quede visible en la sesión que mira el usuario y no desacoplado u oculto?
- ¿Cómo se envía una línea al panel del director desde otro panel (notificación nativa o envío de texto)? Lo usa el vigía.
- ¿Cómo se lee solo el final de la salida de un panel (últimas 20 o 30 líneas), para diagnósticos baratos? Si el multiplexor devuelve la lectura como JSON (por ejemplo, Orca: `terminal read` entrega el texto en un campo `tail`), lea solo ese campo y solo sus últimas líneas; nunca el volcado completo del búfer.
- ¿Tiene funciones propias para agentes (lanzarlos, ver su estado, notificar al terminar, espacios de trabajo)? Si las tiene, úselas en lugar de simular con envío de texto, salvo cuando no admita las restricciones de permisos del rol (ver sección 3).

Tabla de orientación para los más comunes (verifique siempre contra la ayuda de la versión instalada):

| Operación | tmux | zellij | wezterm |
|---|---|---|---|
| Crear | `tmux split-window -h -P -F '#{pane_id}'` (o `new-window -n nombre`) | `zellij action new-pane --name nombre` | `wezterm cli split-pane` (devuelve id) |
| Enviar | `tmux send-keys -t ID 'texto' Enter` | `zellij action write-chars 'texto'` | `wezterm cli send-text --pane-id ID 'texto'` |
| Leer (solo diagnóstico) | `tmux capture-pane -p -t ID -S -30` | `zellij action dump-screen archivo` | `wezterm cli get-text --pane-id ID` |
| Cerrar | `tmux kill-pane -t ID` | `zellij action close-pane` | `wezterm cli kill-pane --pane-id ID` |
| Titular | `tmux select-pane -t ID -T rol:tarea` | `--name` al crear | `wezterm cli set-tab-title` |
| Agrupación por worktree | `tmux new-window -n 'HU · wt' -c RUTA` (en la sesión actual, no en otra desacoplada) | `zellij action new-tab --name 'HU · wt' --cwd RUTA` | `wezterm cli spawn --cwd RUTA` (nueva pestaña) |
| Panel en el worktree | `tmux split-window -t VENTANA -c RUTA` | `zellij action new-pane --cwd RUTA` | `wezterm cli split-pane --cwd RUTA` |
| Distribución | `tmux select-layout -t VENTANA tiled` | layouts de zellij (`--layout`) | divisiones al crear |

Fila adicional para Orca, con los comandos verificados el 2026-11-11 contra Orca CLI 1.4.253 (vuelva a verificarlos en cada sesión, como exige el paso 4 de esta sección; una versión más nueva puede cambiar la sintaxis):

| Operación | orca |
|---|---|
| Crear | `orca terminal create --worktree current --title "<rol>:<tarea>" --shell git-bash [--command ...] --json` |
| Enviar | `orca terminal send --terminal <h> --text '<texto>' --enter --json` |
| Leer (solo diagnóstico) | `orca terminal read --terminal <h> --screen --json` (texto en el campo `tail`) |
| Esperar | `orca terminal wait --terminal <h> --for exit` (o `--for tui-idle`) `--timeout-ms <N> --json` |
| Cerrar | `orca terminal close --terminal <h> --json` |
| Agrupación por worktree | nativa: `--worktree <selector>` en la creación, sin paso aparte |
| Aviso al panel del director | `orca terminal send --terminal <panel-director> --text '{msg}' --enter` |

Para multiplexores que no estén en la tabla (wmux, herdr u otros), no suponga nada: todo sale de su ayuda. Si la ayuda no basta para alguna operación, dígaselo al usuario y pregúntele cómo la hace él antes de delegar.

Anote los comandos verificados junto con la versión. En una sesión posterior sirven como punto de partida, pero se vuelven a verificar con el panel de prueba antes de usarlos.

Haga una prueba rápida: cree un panel, confirme que su identificador es distinto al del director y que aparece visible en la sesión del usuario, envíe `echo listo`, lea la salida y ciérrelo. Si falla, revise la sintaxis con `--help` e informe al usuario; no pase a subagentes sin su autorización expresa.

## 3. Harness y modelos

```bash
for c in claude codex gemini opencode aider; do command -v "$c" >/dev/null && echo "harness: $c"; done
```

Use por defecto el mismo harness en el que corre el director. Use otro solo si el usuario lo pide o si el proyecto ya lo usa.

La skill no nombra modelos concretos: trabaja con tres niveles de capacidad (pequeño, mediano, grande; ver sección 3 de SKILL.md) y usted los traduce una vez por sesión a los modelos reales del harness. Para construir el mapeo:

1. Liste los modelos que el harness ofrece (`<harness> --help`, buscando `--model` o equivalente; si el harness tiene un comando o menú para listar modelos, úselo). Si el proyecto o la organización ya tiene un ruteo de modelos escrito (por ejemplo, un archivo de configuración con niveles por rol), respételo en lugar de deducirlo.
2. Asigne a **pequeño** el modelo más barato y rápido de la familia, a **mediano** el modelo de trabajo habitual y a **grande** el más capaz. Si la familia tiene menos de tres tamaños, repita un modelo en dos niveles y diferéncielos por esfuerzo de razonamiento.
3. Si el harness expone el esfuerzo de razonamiento como opción aparte (`--effort`, `--thinking`, `--reasoning` o similar), anote cómo se fija: bajo para lo mecánico, medio para construir, alto para diseñar, revisar o depurar.
4. Verifique el mapeo lanzando un panel de prueba con cada nivel y confirmando que el modelo arranca; escriba el resultado en `STATUS.md`, sección "Entorno" (nivel → modelo → opción de esfuerzo).

Cómo lanzar un rol con el modelo elegido (verifique con `--help` si la versión instalada difiere):

- Modo interactivo: `<harness> --model <modelo-del-nivel> [opción de esfuerzo]`, con la línea que apunta al brief como primer mensaje.
- Tareas mecánicas: use el modo no interactivo del harness (`-p`, `--print`, `exec` o equivalente), redirigiendo la salida a un archivo en `.director/reportes/`; el panel sigue siendo visible y termina solo.

Si el harness permite restringir herramientas o permisos al lanzar (por ejemplo, el flag de herramientas permitidas del harness), úselo según los permisos del rol en `roles.md`. **Las restricciones de permisos del rol tienen prioridad sobre el lanzamiento nativo de agentes del multiplexor.** Si la función nativa del multiplexor para lanzar agentes no admite pasarle esas restricciones, no la use para ese rol: lance el harness con sus flags de permisos dentro de un panel simple, con `--command` (ejemplo en Orca: `orca terminal create --worktree current --title "<rol>:<tarea>" --shell git-bash --command "<harness> --allowedTools ... --model ..."`).

Cuidado con los flags variádicos: opciones como `--allowedTools` en algunos harnesses consumen todo lo que sigue en la línea, incluido el mensaje o el prompt. Coloque la línea que apunta al brief **antes** de ese tipo de flags, o ciérrelos explícitamente con `--` antes de agregar el mensaje. Verifique el orden correcto con el panel de prueba de la sección 2 antes de usarlo en una delegación real.

## 4. Subagentes: solo con autorización expresa

Los subagentes corren dentro del panel del director, así que por regla no se usan. La única excepción es que el usuario lo autorice de forma explícita en la conversación, sabiendo que el director dejará de estar disponible mientras trabajen. Aun así, mantenga los briefs, los reportes y el límite de concurrencia.

## 5. Vigía y comando de aviso

El vigía (`scripts/vigia.sh` de esta skill) necesita un comando para enviar una línea al panel del director. Averígüelo y pruébelo durante la verificación inicial:

- Si el multiplexor tiene notificaciones nativas dirigidas a un panel o agente, úselas.
- Si no, use el envío de texto al panel del director. Ejemplo en tmux: `tmux send-keys -t <panel-director> '{msg}' Enter`.

Lance el vigía en un panel pequeño y visible del grupo `director`, sin harness (es solo shell):

```bash
DIRECTOR_AVISO="<comando verificado con {msg}>" <ruta-skill>/scripts/vigia.sh <ruta-absoluta-.director> 30
```

Pruébelo creando un estado de prueba (`echo "LISTO|prueba" > <.director>/estado/prueba`) y confirmando que la línea `[vigia] prueba POR_LEER` llega a su panel; luego borre el archivo. Si no hay forma de avisar al panel del director, lance el vigía sin `DIRECTOR_AVISO` (mostrará las novedades en su propio panel) y apóyese en `scripts/estado.sh` cada vez que el usuario escriba.

Umbrales ajustables por variables de entorno: `ACK_SEG` (120 segundos para el acuse) y `PLAZO_MIN` (15 minutos sin latido por defecto; por tarea, con el archivo `estado/<id>.plazo`). Para detenerlo: `touch <.director>/estado/.parar`.

Si el multiplexor ofrece una espera nativa de costo cero (por ejemplo, `orca terminal wait --for exit|tui-idle`, o `tmux wait-for`), puede usarla como complemento del vigía cuando el usuario pidió no recibir confirmaciones intermedias: espera a que un panel termine o quede inactivo sin gastar tokens del director. Nunca la use en lugar de los archivos de ACK: esa espera nativa solo observa el panel, no reemplaza el acuse ni el reporte escrito.

## 5.1 Otros directores

Todos los directores usan la misma ubicación compartida en la máquina para encontrarse y escribirse:

```
~/.directores/
├── registro/<proyecto>.md      # un archivo por director activo
└── buzon/<proyecto>/           # mensajes recibidos por ese director
    └── <fecha-hora>-<origen>-<tipo>.md
```

Al iniciar:

1. Cree su archivo en `~/.directores/registro/` con: nombre del proyecto, ruta del repositorio, multiplexor, identificador de su panel (y sesión o pestaña), fecha de inicio. Cree su carpeta en `buzon/` si no existe.
2. Liste `registro/` para saber qué otros directores están activos. Si un registro tiene un panel que ya no existe en el multiplexor, considérelo inactivo y no le escriba al panel (solo al buzón).
3. Revise su buzón por mensajes pendientes de sesiones anteriores.

Para enviar un mensaje: escriba el archivo en `buzon/<proyecto-destino>/` con la plantilla de mensaje entre directores y, si el otro director está en el mismo multiplexor y su panel existe, envíele un aviso de una línea a su panel (por ejemplo, `[director:<origen>] mensaje nuevo en su buzón: <asunto>`). Nunca envíe texto a un panel que no sea el de un director registrado.

Al leer un mensaje, deje de inmediato el acuse en el buzón del remitente (formato en `plantillas.md`), muévalo a `buzon/<proyecto>/leidos/` y registre su estado en `STATUS.md`. Al enviar, anote la hora límite de acuse; si no llega, reenvíe el aviso una vez e informe a su usuario.

Al cerrar la sesión, elimine su archivo de `registro/`; su buzón se conserva.

Si el usuario o la organización usa otra vía para comunicar directores (un canal, un repositorio compartido), úsela en lugar de esta, manteniendo la regla de que solo los directores se comunican entre proyectos.

## 6. Registro en STATUS.md

Escriba en `STATUS.md`, sección "Entorno": multiplexor usado, panel del director, comandos verificados (paneles, agrupaciones por worktree, distribución y aviso al director), harness y mapeo de niveles de modelo (pequeño, mediano, grande → modelo real y opción de esfuerzo).
