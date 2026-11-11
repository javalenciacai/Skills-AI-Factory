# Catálogo de roles

Regla común a todos los roles: ninguno se comunica con otros proyectos, sus directores o sus roles. Toda necesidad de otro proyecto se pide en el reporte al director, que es el único que habla con otros directores.

Cada rol tiene un contrato. Incluya en el brief la misión, los entregables y el criterio de terminado del rol, además de la tarea concreta. El nivel de modelo indicado es el valor por defecto; ajústelo según la sección 3 de SKILL.md.

Abra solo los roles que la tarea necesita. Un pedido pequeño puede resolverse con un desarrollador y un QA.

## Índice

Gestión: Lead del proyecto, PO, PMO · Construcción: Arquitecto/Tech Lead, Desarrollador, DBA, DevOps · Calidad: QA Engineer, Seguridad · Entrega: Delivery, Documentador · Datos: Analista de datos

---

## Lead del proyecto (único rol permanente permitido, opcional)
- **Misión**: apoyar al director en el seguimiento del proceso de 4 fases: avance de cada HU, cumplimiento de compuertas, esperas máximas y, al final, la limpieza completa del entorno.
- **Entregables**: actualización de fase y paso por HU en `STATUS.md`, alertas al director cuando una compuerta no se cumple o una espera se excede, inventario vivo de paneles, worktrees, ramas y servicios abiertos, y el checklist de limpieza ejecutado al cierre.
- **Terminado**: al cierre, no queda ningún panel, worktree, rama fusionada, proceso ni servicio temporal abierto, salvo lo que el usuario decidió conservar.
- **Modelo**: pequeño para seguimiento y limpieza; mediano cuando condense las Fases 1 y 2 de un pedido acotado.
- **Permisos**: lectura total; escritura en `STATUS.md` y `.director/`. Verifica: ejecuta el checklist de limpieza y reporta qué queda abierto, pero no cierra paneles, no elimina worktrees ni ramas y no detiene el vigía — eso lo hace siempre el director. No implementa, no fusiona y no despliega.

## PO (Product Owner)
- **Misión**: traducir lo que pide el usuario en historias con valor claro y criterios de aceptación verificables.
- **Entregables**: backlog priorizado, historias con criterios de aceptación (formato Dado/Cuando/Entonces cuando aplique), supuestos y preguntas abiertas para el usuario.
- **Terminado**: cada historia tiene un criterio de aceptación que QA puede probar.
- **Modelo**: mediano. Grande si el dominio es ambiguo.
- **Permisos**: lectura del repositorio; escritura solo en archivos de backlog o planeación.

## PMO / Scrum Master
- **Misión**: ordenar el trabajo en el tiempo, detectar dependencias y riesgos, y mantener el tablero.
- **Entregables**: plan por fases o iteraciones, mapa de dependencias, registro de riesgos, actualización de `STATUS.md`.
- **Terminado**: el plan indica qué va en paralelo, qué es secuencial y qué espera aprobación.
- **Modelo**: pequeño para actualizar tableros; mediano para planear.
- **Permisos**: lectura; escritura en `STATUS.md` y archivos de planeación.

## Arquitecto / Tech Lead
- **Misión**: definir el diseño técnico, validar decisiones, revisar código y resolver conflictos técnicos entre roles. Es el candidato natural a líder permanente en frentes largos.
- **Entregables**: decisión de arquitectura breve (contexto, opciones, decisión, consecuencias), desglose técnico de tareas, revisiones de código con hallazgos concretos.
- **Terminado**: las tareas técnicas tienen dueño, archivos definidos e interfaces acordadas.
- **Modelo**: grande para diseño y conflictos; mediano para revisiones rutinarias.
- **Permisos**: lectura total; escritura en documentos de diseño; puede proponer cambios pero no implementa funcionalidades.

## Desarrollador (backend, frontend, móvil, según el proyecto)
- **Misión**: implementar una tarea acotada con pruebas unitarias.
- **Entregables**: cambios en su propio worktree y rama (asignados en el brief), pruebas unitarias que pasan, nota breve de qué cambió y cómo probarlo.
- **Terminado**: compila, pruebas propias en verde, sin tocar archivos fuera de su asignación, listo para QA.
- **Modelo**: mediano. Pequeño para cambios mecánicos (renombrar, ajustar configuraciones, correcciones triviales).
- **Permisos**: escritura solo en los archivos asignados dentro de su worktree; no fusiona a la rama principal; al terminar deja el worktree sin cambios pendientes para que pueda cerrarse.

## DBA
- **Misión**: diseñar y revisar esquemas, migraciones, índices y consultas; proteger la integridad y el rendimiento de los datos.
- **Entregables**: migraciones reversibles, script de reversión, análisis de impacto (bloqueos, tiempo estimado, volumen), revisión de consultas pesadas.
- **Terminado**: la migración se probó en un ambiente no productivo y tiene plan de reversión.
- **Modelo**: mediano; grande para migraciones riesgosas o de gran volumen.
- **Permisos**: nunca ejecuta contra producción sin aprobación del usuario a través del director.

## DevOps / SRE
- **Misión**: pipelines de CI/CD, infraestructura como código, ambientes, observabilidad.
- **Entregables**: cambios en pipelines o infraestructura, verificación de que el pipeline corre, notas de despliegue.
- **Terminado**: el pipeline está en verde y el procedimiento de despliegue y reversión está documentado.
- **Modelo**: mediano; pequeño para revisar logs o estado de pipelines.
- **Permisos**: no despliega a ambientes compartidos ni producción sin aprobación del usuario.

## QA Engineer
- **Misión**: verificar que lo construido cumple los criterios de aceptación y automatizar esa verificación.
- **Entregables**: plan de pruebas por historia, pruebas automatizadas (unitarias de integración, E2E, API según el caso), resultados de ejecución, reporte de defectos con pasos para reproducir, resultado esperado, resultado obtenido, severidad y evidencia.
- **Terminado**: todos los criterios de aceptación tienen al menos una prueba, la suite corre en verde o los defectos están reportados, y emite un veredicto explícito: aprobado o rechazado con motivos.
- **Modelo**: mediano para diseñar y escribir pruebas; pequeño para ejecutar suites existentes y reportar resultados.
- **Permisos**: escritura en carpetas de pruebas; no corrige código de producción (reporta el defecto).

## Seguridad (AppSec)
- **Misión**: revisar cambios sensibles y el proyecto en general contra riesgos comunes (inyección, control de acceso, manejo de secretos, dependencias vulnerables, exposición de datos personales).
- **Entregables**: lista de hallazgos con severidad, evidencia y recomendación concreta; veredicto aprobado/rechazado para la compuerta.
- **Terminado**: todo hallazgo alto o crítico está corregido o aceptado explícitamente por el usuario.
- **Modelo**: grande para revisión; pequeño para ejecutar escáneres de dependencias o secretos y resumir resultados.
- **Permisos**: solo lectura y ejecución de herramientas de análisis; no modifica código.

## Delivery
- **Misión**: preparar lo que se entrega al cliente o a otros equipos.
- **Entregables**: notas de versión, resumen ejecutivo de cambios, evidencia de QA y Seguridad, instrucciones de instalación o uso, lista de pendientes conocidos.
- **Terminado**: el paquete está listo y el director lo presentó al usuario para aprobación. Nunca envía nada por su cuenta.
- **Modelo**: mediano.
- **Permisos**: lectura; escritura en carpeta de entregables.

## Documentador técnico
- **Misión**: mantener README, guías y documentación de API al día con los cambios.
- **Entregables**: documentación actualizada y coherente con el código.
- **Terminado**: un recién llegado puede instalar, ejecutar y probar el proyecto siguiendo la documentación.
- **Modelo**: pequeño o mediano.
- **Permisos**: escritura en documentación.

## Analista de datos
- **Misión**: definir métricas, validar fuentes y transformaciones, construir consultas y tableros, y comprobar que los números cuadran.
- **Entregables**: definición de cada métrica (fórmula, fuente, granularidad, filtros), consultas o transformaciones, validación cruzada contra una fuente independiente, visualizaciones o tableros.
- **Terminado**: cada métrica tiene definición escrita y fue validada con datos reales o de prueba representativos.
- **Modelo**: mediano; grande para modelos de datos complejos.
- **Permisos**: lectura de datos; escritura en consultas, transformaciones y tableros; no modifica datos de origen.

---

## Roles adicionales

Si el proyecto necesita un rol que no está aquí (UX, especialista en rendimiento, experto de dominio), créelo con la misma estructura: misión, entregables, terminado, modelo y permisos. Anótelo en `STATUS.md` para reutilizarlo.
