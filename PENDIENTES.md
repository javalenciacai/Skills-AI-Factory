# Pendientes

## Por validar en un entorno real
- [ ] Ejecutar la skill dentro de cada multiplexor que se use (tmux, wmux, orca, herdr, etc.) y confirmar que el director aprende y verifica los comandos al inicio.
- [ ] Confirmar el comando de aviso del vigía hacia el panel del director en cada multiplexor.
- [ ] Probar `estado.sh` y `vigia.sh` en Windows (Git Bash y WSL). Evaluar si conviene una versión en PowerShell.
- [ ] Correr los tres casos de `evals/` con agentes reales y revisar los resultados.
- [ ] Probar la comunicación entre dos directores (registro, buzón y acuse en `~/.directores/`).

## Ideas de mejora
- [ ] Casos de prueba para ACK faltante, rol en silencio y limpieza de worktrees.
- [ ] Caso de prueba para solicitud entre directores que requiere aprobación del usuario.
- [ ] Ajustar los umbrales por defecto (ACK 120 s, silencio 15 min) con datos de uso real.
- [ ] Registrar el costo por nivel de modelo para medir el ahorro frente a una sola sesión.
