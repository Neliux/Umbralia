# Ranked: límites y protección

El proyecto tiene una **beta de cuentas, interfaz y cronómetro local**. El menú permite consultar nueve clasificaciones, pero ninguna acepta partidas todavía. La temporada está en borrador; el interruptor BETA activa únicamente un intento de prueba sin verificar. No existe un endpoint que acepte tiempos o apruebe récords enviados por jugadores.

## Información pública

`config.js` contiene la URL del proyecto y una **publishable key** (`sb_publishable_…`). Ambos valores son públicos por diseño: pueden verse con F12 o en GitHub. No son la contraseña de PostgreSQL ni una clave administrativa. Ocultar o minificar JavaScript no proporciona seguridad a la base de datos.

El navegador solo puede leer categorías, temporadas y columnas públicas de los récords. Los identificadores internos de usuario, las partidas, semillas, pruebas y eventos permanecen privados. La función `ranked_leaderboard` tiene derechos de invocador, aplica RLS y no escribe datos.

## Secretos

Nunca se deben añadir al frontend, a `config.js`, a HTML, a un ZIP público, a un workflow o al historial Git:

- Contraseña de PostgreSQL o URL de conexión que la incluya.
- Claves `sb_secret_…`, credenciales administrativas o JWT con rol `service_role`.
- Tokens de acceso a Supabase o GitHub.

Las credenciales del futuro validador se configurarán en el alojamiento del servidor. El cliente no las recibirá. Este cambio no solicita, copia ni guarda contraseñas de la base de datos.

## Defensa de la base

- RLS en todas las tablas creadas.
- Sin permisos de escritura para `anon` o `authenticated` en categorías, temporadas o récords.
- Sin acceso de clientes al esquema `ranked_private`, y con políticas explícitas de denegación.
- Lectura pública limitada a alias y métricas de clasificación, sin UUID de cuenta.
- Un disparador rechaza récords de partidas no verificadas o de una temporada/categoría inactiva.
- Una clave pública no permite convertir una partida en verificada ni activar categorías.

## Pendiente antes de activar Ranked

La base y la consulta de tablas **no constituyen un sistema antitrampas completo**. Para habilitar partidas faltan:

1. Un motor de simulación validable fuera del navegador, con aleatoriedad y pasos de tiempo controlados.
2. Un servicio que verifique identidad, acciones, recargas, recursos, progresión, finalización y tiempo, con límites de solicitudes y sesiones.
3. Registro de partidas y reconexiones controlado por el servidor; no se importarán guardados locales como intentos oficiales.
4. Completar la configuración de redirecciones de Auth y probar confirmación, recuperación, controles de registros automatizados y abuso. Los formularios y la sesión de Auth ya están integrados.
5. Pruebas de manipulación, repeticiones de peticiones, acceso entre cuentas y recuperación ante fallos.
6. Un despliegue revisado del validador y una temporada vinculada a su versión y a la del juego.

No basta con quitar FedericoAlonso del menú ni firmar una puntuación calculada por el navegador. Las nueve categorías deben rechazar su uso y aceptar únicamente resultados derivados de la simulación verificada.

No cambies `ranked_enabled` o el estado de la temporada para saltar esta etapa: el cliente de esta versión no implementa un inicio competitivo y los controles de base no sustituyen al validador.

## Comprobaciones

Ejecuta `node --test tests/ranked.test.cjs` y `node scripts/check-client-secrets.cjs`. La comprobación de secretos detecta formatos conocidos; no demuestra por sí sola que un proyecto sea seguro.

Si alguna credencial privada se publica accidentalmente, debe revocarse o rotarse en su proveedor. Borrarla del último commit no la elimina de versiones anteriores ni invalida copias ya realizadas.
