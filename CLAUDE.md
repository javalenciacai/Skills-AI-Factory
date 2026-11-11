# Contexto del proyecto

Este repositorio es un catálogo de skills para agentes de código, publicado en GitHub (`javalenciacai/Skills-AI-Factory`) e instalable con `npx skills add javalenciacai/Skills-AI-Factory`. Cada skill vive en `skills/<nombre>/` con su `SKILL.md`; skills.sh descubre ese layout automáticamente. Hoy contiene una skill: `director-proyecto`. El trabajo aquí es mejorarla, probarla, empaquetarla y añadir skills nuevas. Idioma de trabajo: español neutro y profesional.

## Qué hace la skill

Convierte al agente en director de proyecto que solo orquesta. Sus reglas obligatorias, que no deben debilitarse al editar:

1. Cada rol trabaja en otro panel del multiplexor, nunca en el del director ni como subagente.
2. Los paneles quedan visibles y organizados por worktree.
3. Entre proyectos solo hablan los directores; todos cargan las mismas reglas.
4. Todo trabajo sigue el proceso de 4 fases (Idea, DoR, DoD, Entrega) y sus compuertas. SDD es opcional.
5. Al inicio de cada sesión se aprende y verifica cómo trabaja el multiplexor detectado.
6. Toda delegación y todo mensaje entre directores tiene acuse de recibo (ACK); un vigía en shell supervisa.
7. Se cuida el gasto de tokens: briefs y reportes por archivo, sin leer pantallas; la espera la hace el vigía.
8. Al terminar, todo queda cerrado y limpio (paneles, worktrees, ramas fusionadas, vigía, registro).

Otras decisiones de diseño: la skill es genérica (no nombra empresas ni proyectos); máximo un rol permanente además del director (Lead del proyecto); el modelo se elige por nivel (pequeño, mediano, grande) según la tarea; las acciones riesgosas requieren aprobación del usuario.

## Convenciones al editar

- `SKILL.md` debe mantenerse por debajo de 500 líneas; el detalle va en `references/`.
- La `description` del frontmatter no puede superar 1024 caracteres.
- Los scripts son `bash` con finales de línea LF (ver `.gitattributes`).
- Si cambia una regla, revise que no contradiga a las demás y actualice plantillas, checklist de limpieza y casos de prueba.
- Tras cada cambio: ejecutar `.\empaquetar.ps1` y probar con al menos un caso de `evals/`.

## Cómo probar los scripts

```bash
D=/tmp/prueba/.director; mkdir -p $D/estado
echo "LISTO|prueba" > $D/estado/t1
skills/director-proyecto/scripts/estado.sh $D      # debe mostrar: t1 LISTO 0m POR_LEER prueba
```

## Estado actual

Ver `PENDIENTES.md`.
