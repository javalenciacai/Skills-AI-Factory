# Plantillas

## 1. Brief de delegación

Escriba el brief en `<.director>/briefs/<id>.md` y envíe al panel (siempre distinto al del director) una sola línea: `Lee <ruta absoluta>/briefs/<id>.md y ejecútalo.` Use siempre la ruta absoluta de `.director`, porque el rol puede estar en otro worktree. Sea específico en archivos y criterios: eso es lo que permite usar modelos más pequeños.

```markdown
# Rol: <rol> — Tarea: <id-corto>

## Tu contrato
<misión, entregables y criterio de terminado del rol, en tres líneas tomadas de roles.md>
Eres un rol, no el director: no cargues la skill de director, no abras paneles, no delegues y no converses con otros roles.

## Acuse y latidos (obligatorio)
Archivo de estado: `<ruta absoluta de .director>/estado/<id>` (una sola línea, se sobrescribe).
1. Antes de cualquier otra cosa, escribe el acuse: `echo "RECIBIDO|<en una frase, qué entendiste que debes hacer>" > <archivo de estado>`
2. Al terminar cada paso de tu plan, deja un latido: `echo "EN_CURSO|paso <n> de <m>: <qué sigue>" > <archivo de estado>`. Plazo máximo sin latido: <N> minutos.
3. Al terminar o bloquearte, primero escribe el reporte y después: `echo "LISTO|<resultado en una frase>" > <archivo de estado>` (o `BLOQUEADO|<motivo>`).

## Objetivo
<una o dos frases: qué debe quedar hecho>

## Contexto mínimo
Lee primero `.director/contexto.md`.
<solo rutas: decisiones previas, archivos relevantes, reportes de otros roles; no pegues contenido>

## Alcance
- Puedes modificar: <archivos o carpetas>
- No toques: <archivos o carpetas>
- Rama / worktree: <nombre>

## Criterios de aceptación
- <criterio verificable 1>
- <criterio verificable 2>

## Restricciones
<estándares del proyecto, tecnologías obligatorias, límites de tiempo o costo>
No fusiones a la rama principal, no despliegues, no ejecutes migraciones ni envíes nada a terceros: si la tarea lo requiere, detente y repórtalo.
No contactes a otros proyectos, sus directores ni sus roles, ni toques sus paneles, worktrees o archivos: si necesitas algo de otro proyecto, pídelo en tu reporte.

## Reporte
Cuando termines o te bloquees, escribe tu reporte en `<ruta absoluta de .director>/reportes/<id>.md` con el formato de abajo, en 20 líneas como máximo, y marca el estado `LISTO` o `BLOQUEADO`. El director recibe el aviso automáticamente; no escribas nada más y espera.
```

## 2. Reporte de rol

```markdown
# Reporte <id> — <rol> — <modelo>
**Estado**: terminado | bloqueado | parcial
**Resultado**: <qué se hizo, en 2-4 líneas>
**Evidencia**: <pruebas ejecutadas y resultado, archivos cambiados, comandos para verificar>
**Riesgos**: <lo que podría fallar o quedó frágil>
**Pendientes / preguntas**: <lo que falta o necesita decisión>
**Veredicto** (solo QA y Seguridad): aprobado | rechazado — <motivo>
```

## 3. STATUS.md

Existe siempre, en `.director/STATUS.md` (ignorado por git; si el usuario quiere versionarlo, va en la raíz). Para una tarea de un solo rol basta con "Entorno", "Objetivo actual" y "Recursos abiertos"; el resto de secciones se agrega cuando hay varios roles o más de una sesión.

```markdown
# Estado del proyecto

## Entorno
- Multiplexor: <X> — panel del director: <id>
- Comandos: crear `<...>`, enviar `<...>`, leer `<...>`, cerrar `<...>`
- Harness: <...> — niveles: pequeño=<...>, mediano=<...>, grande=<...>

## Objetivo actual
<frase> — Terminado cuando: <criterio>

## HUs en curso
| HU | Fase | Paso actual | Compuerta pendiente | Lead time desde | Cycle time desde |
|----|------|-------------|---------------------|-----------------|------------------|

## Tablero
| ID | HU | Fase | Tarea | Rol | Modelo | Depende de | Estado | Panel |
|----|----|------|-------|-----|--------|------------|--------|-------|

## Coordinación con otros proyectos
| Fecha | Dirección | Proyecto | Tipo | Asunto | Estado | Bloquea a |
|-------|-----------|----------|------|--------|--------|-----------|
<!-- dirección: enviada / recibida; tipo: solicitud / respuesta / aviso; estado: enviada sin acuse / acusada / aceptada / en curso / resuelta / rechazada / llevada al usuario -->

## Recursos abiertos (se vacía al cierre)
| Tipo | Identificador | Rol / HU | Abierto | Cerrar cuando |
|------|---------------|----------|---------|---------------|
<!-- tipos: agrupación (pestaña/ventana por worktree), panel, worktree, rama, servidor local, contenedor, ambiente efímero -->

## Esperando aprobación del usuario
- <acción, riesgo, desde cuándo>

## Decisiones
- <fecha> — <decisión> — <quién la tomó>

## Lecciones aprendidas
- <qué funcionó o no en briefs, roles o modelos>
```

## 4. Mensaje entre directores

```markdown
# <solicitud | respuesta | aviso> — <asunto corto>
**De**: director de <proyecto-origen>
**Para**: director de <proyecto-destino>
**Fecha**: <AAAA-MM-DD HH:MM>
**En respuesta a**: <archivo del mensaje original, si aplica>

**Qué se necesita / qué se informa**: <2-4 líneas>
**Por qué**: <HU o compuerta afectada en el proyecto origen>
**Fecha requerida**: <cuándo bloquea, si aplica>
**Acuse esperado antes de**: <hora>
**Criterio de aceptación**: <cómo se sabrá que está resuelto>
**Requiere aprobación de usuario**: <sí/no y de cuál proyecto>
```

Solo los directores escriben y leen estos mensajes. Una respuesta indica: aceptada (con fecha estimada), rechazada (con motivo) o llevada al usuario.

Acuse de recibo: al leer un mensaje, el destinatario deja de inmediato en el buzón del remitente un archivo `<fecha-hora>-<origen>-acuse.md` con una línea: `ACUSE de <archivo original> — recibido por director de <proyecto>, respuesta estimada: <cuándo>`. El acuse no es la respuesta.

## 5. Checklist de limpieza al cierre

```markdown
- [ ] Todas las delegaciones en `LEIDO` (`scripts/estado.sh` no muestra tareas abiertas)
- [ ] Vigía detenido y su panel cerrado
- [ ] Mensajes de otros directores acusados y respondidos
- [ ] Paneles efímeros cerrados y agrupaciones por worktree eliminadas (comparar con "Recursos abiertos")
- [ ] Ningún proceso de rol corriendo en segundo plano
- [ ] Worktrees de la sesión eliminados (`git worktree list` solo muestra el principal y los que el usuario decidió conservar); `git worktree prune` ejecutado
- [ ] Ramas locales ya fusionadas eliminadas; ramas sin fusionar reportadas al usuario
- [ ] Servidores locales, contenedores y ambientes efímeros detenidos
- [ ] Temporales y briefs eliminados; `.director/` solo con STATUS.md, contexto.md y reportes a conservar
- [ ] Tabla "Recursos abiertos" vacía o con justificación por fila
- [ ] Solicitudes entre proyectos respondidas o canceladas; directores involucrados avisados del cierre
- [ ] Registro propio retirado de `~/.directores/registro/` (al terminar la sesión)
- [ ] Panel del Lead del proyecto cerrado (último paso)
```

## 6. Resumen de estado para el usuario

Úselo cuando el usuario pregunte por el avance. Breve, para leer en segundos.

```markdown
**Objetivo**: <frase> — HU <id> en Fase <n>, paso <m> — avance <x de y tareas>

| Panel | Rol | Modelo | Tarea | Estado |
|-------|-----|--------|-------|--------|

**Bloqueos**: <ninguno | lista>
**Otros proyectos**: <solicitudes pendientes enviadas/recibidas | ninguna>
**Necesito su decisión sobre**: <ninguna | lista>
**Siguiente paso**: <qué viene>
```
