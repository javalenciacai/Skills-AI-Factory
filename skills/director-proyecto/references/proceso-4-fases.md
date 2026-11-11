# Proceso obligatorio: Ruta de Entrega en 4 fases

Todo trabajo que orqueste el director recorre estas cuatro fases, en orden, por cada Historia de Usuario (HU). El objetivo es ir de la idea a producción en 4 a 6 días hábiles para una HU bien dimensionada.

Tres fuerzas recorren todo el proceso: **Producto** (qué se quiere y para quién), **Técnica** (cómo se construye) y **Calidad** (cómo se comprueba). En cada paso se indica cuál lidera.

Reglas generales:

- Las **compuertas** (⛩) nunca se saltan. Una HU no avanza de fase sin cumplir la compuerta de salida.
- Los pasos marcados **(opcional)** pueden omitirse; si los omite, anote el motivo en `STATUS.md`.
- **SDD es opcional.** Donde el proceso dice "especificar con SDD", puede usarse cualquier enfoque que deje propuesta, especificación, diseño y tareas escritos y versionados antes de codificar (un framework SDD, plantillas del equipo, documentos de diseño). Lo obligatorio es el resultado, no la herramienta.
- **Una HU a la vez** por frente de trabajo: se termina una antes de activar la siguiente.
- **Paralelizar lo que no depende**: los pasos marcados ∥ corren en paneles simultáneos.
- **Colaboración por archivo**: cuando un paso reúne a varias fuerzas (shaping, tres amigos, story mapping), los roles no conversan entre paneles. Un rol redacta y los demás aportan o revisan por escrito sobre el mismo archivo, en turnos que el director coordina. Así se conserva el aporte de las tres fuerzas sin multiplicar el gasto.
- Las decisiones que el proceso asigna a dirección, negocio o cliente (la apuesta, aceptar bugs menores, despliegue a producción, aceptación) las toma **el usuario**: el director las presenta y espera.

Mapeo de fuerzas a roles del director: Producto = PO (funcional); Técnica = Tech Lead y Desarrolladores (con DBA y DevOps según el caso); Calidad = QA Engineer (con Seguridad según el caso). El Lead del proyecto supervisa el avance entre fases.

---

## Fase 1 · Dando forma a la idea — presupuesto ≤ 1 día por slice

Lidera Producto; Técnica y Calidad acompañan. Convierte una necesidad en una apuesta concreta y en HUs pequeñas listas para refinar (metodología Shape Up adaptada a ciclos cortos).

| Paso | Rol (modelo) | Salida |
|---|---|---|
| 1. Shaping: problema, apetito en días, solución en trazos gruesos, riesgos (rabbit holes) y no-goes | PO + Tech Lead (grande); QA pregunta cómo se comprobará | Documento de shaping |
| 2. Prototipo funcional básico (opcional): navegable, sin código de producción, para confirmar que se entendió | PO (mediano) | Prototipo enlazado al shaping y ajustes |
| 3. ⛩ Pitch y apuesta: problema, apetito, solución, riesgos, no-goes; ataque en modo red team | PO redacta (mediano); **decide el usuario** | Pitch aprobado con apetito |
| 4. Story mapping: actividades, pasos del usuario, HUs priorizadas y línea del primer slice | PO + Tech Lead + QA (mediano) | Mapa de historias y HUs creadas |
| 5. ⛩ Dimensionar: ninguna HU de más de 1–2 días de desarrollo; las grandes se parten | Tech Lead (mediano) | HUs del slice ≤ 2 días |
| 6. Example mapping (opcional): reglas, ejemplos y preguntas abiertas por HU; o escenarios Dado/Cuando/Entonces directos | QA lidera (mediano) | Reglas, ejemplos, escenarios iniciales |

**Compuerta de salida:** apuesta aprobada por el usuario y todas las HUs del slice de ≤ 2 días.

## Fase 2 · Definition of Ready (DoR) — presupuesto ≤ 1 día

Las tres fuerzas en equilibrio. Garantiza que la HU esté lista antes de escribir código. Los pasos 2 a 6 son una sola "sesión de alistamiento": el director abre los paneles en paralelo y los coordina como una sesión, no como una secuencia de esperas.

| Paso | Rol (modelo) | Salida |
|---|---|---|
| 1. Activar la HU y registrar la fecha (inicia el **lead time**) | Lead del proyecto o PMO (pequeño) | HU activa con fecha de inicio |
| 2. Revisión funcional: entender la HU desde el negocio y listar dudas | Desarrollador asignado (mediano) | Preguntas funcionales; las de negocio van al usuario |
| 3. Tres amigos + especificación: completar escenarios, notas técnicas y de calidad; crear propuesta, spec y diseño (SDD u otro enfoque) | PO + Tech Lead + QA (grande para diseño) | HU completa; propuesta, spec y diseño versionados |
| 4. Complementar la HU con la spec (opcional): corregir lo que el agente entendió mal, detectar inconsistencias HU ↔ spec | Tres amigos (mediano) | HU enriquecida y enlazada al diseño |
| 5. ∥ Revisión de la HU contra INVEST y checklist DoR por un revisor independiente | QA (mediano), en panel distinto al que escribió la HU | Informe del revisor y HU corregida |
| 6. ⛩ Validar checklist DoR + INVEST y mover a Ready | QA lidera (pequeño para pre-marcar evidencia) | HU en Ready con evidencia por ítem |

**Checklist DoR mínimo:** cumple INVEST y el informe del revisor está resuelto; escenarios completos y criterios verificables; propuesta, spec y diseño enlazados y revisados; estimación, dependencias y datos de prueba definidos.

## Fase 3 · Definition of Done (DoD) — presupuesto 2–3 días

Lideran Técnica y Calidad; Producto acompaña. Construir, probar y estabilizar la HU. Es la fase donde más se pierde por esperas: el director paraleliza, fija esperas máximas y evita filas de ambientes.

| Paso | Rol (modelo) | Salida |
|---|---|---|
| 1. ∥ Casos de prueba antes de codificar: positivos, negativos, borde y no funcionales | QA (mediano) | Casos en el plan de pruebas + exportación |
| 2. ∥ Tareas a partir de spec, diseño y casos; cada tarea nombra el caso que la valida (test-first si el proyecto usa TDD) | Tech Lead o Desarrollador (mediano) | Lista de tareas versionada |
| 3. Leer las tareas e implementar en su worktree (inicia el **cycle time**) | Desarrollador(es) (mediano) | Código y pruebas en la rama de la HU |
| 4. Verificación contra la spec por un agente independiente | QA o Tech Lead en otro panel (mediano; grande si es crítico) | Informe de cumplimiento de la spec |
| 5. Levantar localmente y recorrer los casos principales entre QA y desarrollo | QA + Desarrollador (pequeño para ejecutar) | Evidencia de verificación local |
| 6. ∥ Pruebas de mutación: buscar que muera el 100 % de los mutantes | QA (mediano) | Reporte de mutación y ajustes |
| 7. ∥ Revisión del diff por un revisor independiente; corregir todo lo reportado | Tech Lead o Seguridad (grande si toca seguridad o datos) | Diff limpio |
| 8. Volver a probar si hubo ajustes | QA (pequeño) | Confirmación de que la rama sigue funcionando |
| 9. Crear el Pull Request vinculado a la HU | Desarrollador (pequeño) | PR abierto |
| 10. Esperar y corregir los harnesses del PR: análisis estático, secretos, vulnerabilidades, linter, cobertura, mutación | Desarrollador (mediano) | PR con verificaciones en verde |
| 11. ⛩ Aprobación del líder técnico (espera máxima 4 horas hábiles). **La fusión requiere aprobación del usuario.** | Tech Lead (grande) | PR aprobado; fusión tras visto bueno del usuario |
| 12. Despliegue a desarrollo y smoke test | DevOps (pequeño/mediano) | Ambiente de desarrollo estable y evidencia |
| 13. Promover a testing sin hacer fila (ambiente efímero si es posible) | DevOps + QA (pequeño) | Cambios en testing |
| 14. Pruebas fuertes en testing: todos los casos, bugs con severidad 1–4, retest; parar si hay bloqueantes | QA (mediano); bugs de severidad 3–4 los decide el usuario | Plan ejecutado, bugs cerrados o aceptados |
| 15. ⛩ Regresión automatizada y selectiva por área de riesgo | QA (pequeño para ejecutar) | Reporte de regresión aprobado |

**Compuerta de salida (DoD):** spec verificada, casos ejecutados en verde, mutación y revisión del diff resueltas, PR aprobado y fusionado con visto bueno del usuario, regresión aprobada.

## Fase 4 · Entrega al cliente — presupuesto ≤ 1 día

Lidera Técnica; Producto y Calidad acompañan.

| Paso | Rol (modelo) | Salida |
|---|---|---|
| 1. Ventana de despliegue (diaria de lunes a jueves, nunca viernes) y confirmación de la regresión | Tech Lead + QA (pequeño) | Fecha de despliegue propuesta |
| 2. Plan de reversión antes de desplegar, por plantilla según el tipo de cambio | Tech Lead + DevOps (mediano; DBA si hay datos) | Plan de rollback documentado |
| 3. ⛩ Aprobación y despliegue a producción. **Requiere aprobación explícita del usuario.** | DevOps ejecuta tras el visto bueno (mediano) | Versión en producción |
| 4. ⛩ Prueba de aceptación en producción y release notes. La HU se considera **entregada** al pasar esta prueba. | QA + PO (mediano); Delivery prepara notas | Aceptación aprobada; release note listo (su envío al cliente lo aprueba el usuario) |
| 5. Monitoreo posterior (hypercare) en paralelo con la HU siguiente; no bloquea la entrega | DevOps/SRE + QA (pequeño) | Ventana cerrada sin incidentes severidad 1–2 |
| 6. Documentación, cierre de la HU y registro de métricas (lead time y cycle time) | Documentador + Lead del proyecto (pequeño) | HU cerrada con fechas y documentación |

---

## Aceleradores que el director aplica

- HUs de 1 a 2 días de desarrollo (compuerta de la Fase 1).
- Una HU a la vez por frente; se mide por HUs terminadas.
- Esperas máximas: revisión de PR en menos de 4 horas hábiles; dudas funcionales en menos de 2 horas.
- Sesiones en vez de secuencias: toda la Fase 2 como una sola sesión con paneles en paralelo.
- Paralelizar lo que no depende: casos y tareas a la vez; mutación y revisión del diff juntas; hypercare mientras empieza la HU siguiente.
- Ambientes sin fila: efímeros por HU o PR cuando sea posible.
- Regresión automatizada y selectiva en cada promoción; completa en horario nocturno.

## Trabajo pequeño

Las cuatro fases aplican siempre. En un cambio acotado (por ejemplo, actualizar documentación o una corrección puntual) la profundidad se ajusta: la Fase 1 puede ser un párrafo con el problema y el criterio de terminado, la Fase 2 un checklist DoR breve en el brief, la Fase 3 la implementación con su verificación independiente y la Fase 4 la aceptación y el cierre. Lo que no se ajusta: las compuertas, la verificación por un rol distinto al que hizo el trabajo y las aprobaciones del usuario.
