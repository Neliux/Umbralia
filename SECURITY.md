# Rankeds BETA · v87

Las marcas se calculan reproduciendo los controles en el servidor. El navegador no puede publicar tiempos, vida, recursos ni oleadas como resultados verificados. La partida utiliza una semilla del servidor, simulación a 30 pasos/s y una versión congelada del motor. El cronómetro mide tiempo de juego y se detiene en los menús. Un guardado local nunca se convierte en una partida oficial.

## Límites de seguridad

- La URL y la clave **publishable** de `config.js` son públicas por diseño. F12 también permite ver el token de la propia sesión; no concede permisos administrativos.
- La contraseña de PostgreSQL y las claves administrativas no se guardan en GitHub ni se envían al navegador. La función Edge utiliza su credencial interna de Supabase.
- RLS y permisos impiden a `anon` y `authenticated` escribir récords o acceder a `ranked_private`. Las operaciones internas solo las puede invocar `service_role`.
- La API verifica el JWT y el usuario con Supabase Auth. Cada operación de jugador comprueba propietario; las secuencias son consecutivas, limitadas e idempotentes. No se confía en `user_metadata`.
- GitHub Actions obtiene un JWT OIDC temporal. La API comprueba firma, emisor, audiencia, ID del repositorio, rama, workflow y tipo de evento. Un fork o un pull request no puede actuar como verificador. No hay una contraseña permanente del servidor en Actions.
- El verificador compara el hash del motor, reproduce los eventos sin red y rechaza códigos, cambios de reglas y finales que no cumplan la categoría. El disparador SQL exige partida verificada y temporada compatible.
- Los alias se muestran como texto. No se publican correos, UUID de cuenta ni controles.

## Operación y limitaciones

La cola se revisa al desplegar y aproximadamente cada diez minutos; GitHub puede retrasar tareas programadas. Una marca puede tardar varios minutos en aparecer. La beta limita intentos y tamaño/duración de las reproducciones para controlar abuso. Una desconexión breve reintenta los bloques; cerrar la pestaña antes de enviarlos puede perder el intento competitivo, pero no borra el mundo local. No hay reanudación competitiva desde Continuar.

Esto verifica las reglas y el resultado de la simulación, pero **no demuestra que juegue una persona** ni impide automatización de controles, bots o herramientas externas. No es una garantía de ausencia de vulnerabilidades. Un servicio dedicado permitiría verificación inmediata y controles operativos más amplios.

La configuración de correo, proveedor SMTP, URLs de confirmación/recuperación y protección contra contraseñas filtradas se administra en Supabase Auth. No se deben desactivar confirmaciones como sustituto de configurar el correo.

Ejecutar `npm test`. Si se cambia el motor competitivo, actualizar el archivo congelado, su manifiesto, el identificador de versión y la temporada; no mezclar versiones. Los secretos publicados por accidente deben revocarse, aunque se eliminen del último commit.
