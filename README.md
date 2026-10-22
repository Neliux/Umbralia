# Umbralia: Ecos del Tiempo · v92

Juego de acción y supervivencia para navegador: explora siete mundos, construye defensas, combina armas y mejoras y enfréntate a jefes con mecánicas propias. Incluye campaña, Caos normal, Caos infinito y el duelo contra **Tu otro yo**. Para computadora y celular.

## Publicar o actualizar en GitHub Pages

1. Descomprime el ZIP y sube **su contenido** a la raíz del repositorio: `index.html`, `config.js`, `.nojekyll`, `README.md` y la carpeta completa `assets`.
2. Reemplaza los archivos anteriores, incluida la música. Conserva la dirección del juego y los datos del navegador para mantener tus partidas y trofeos. Antes de actualizar, exporta tus partidas como precaución.
3. En **Settings → Pages → Deploy from a branch**, elige **main** y **/(root)** y guarda. Abre el enlace cuando termine el despliegue.
4. El título y la insignia del menú deben mostrar **v92**. Si ves otra versión, recarga sin caché.

No necesita instalación ni compilación. El motor está en `index.html` y los módulos de cuentas y clasificación están en `assets/ranked/`. Prueba local: `python3 -m http.server 8000` y abre `http://localhost:8000`.

## Cambios de v92

- La Pelota Roja comenta pistas ordinarias del navegador y el correo de la sesión iniciada, solo en pantalla. Su cara se deforma progresivamente al perder vida y prolongarse el combate.
- En Caos local, los jefes derrotados quedan inmóviles 0,5 s, explotan con la cámara centrada en ellos y abren la recompensa 1 s después. La cámara vuelve al jugador antes de elegir. El jefe final de Caos normal conduce a la victoria tras la misma escena.
- Mejoras de Caos normal e infinito hasta nivel 3, con evoluciones en los niveles 2 y 3. Los guardados anteriores se adaptan y las exclusivas siguen siendo únicas.
- Gato explosivo: un gato cada 10 s, 50 de daño y radio 85; nivel 2 cada 8 s, 75 y radio 110; nivel 3 dos gatos cada 6 s, 100 por gato y radio 140.
- Satélite de pulso: 20 de daño cada 8 s en radio 120; nivel 2, 30 cada 6 s en radio 150 y ralentización; nivel 3, 45 cada 4 s en radio 190, limpieza de 6 proyectiles y aturdimiento breve.
- Las reglas competitivas actuales permanecen vinculadas a su verificador anterior.

## Cambios de v91

- Pelota Roja más aterradora: ojos hundidos, pupilas estrechas, grietas y una sonrisa de dientes irregulares. También se muestra en gráficos simples y Caos.
- Los cambios de oración del final se retrasan un segundo respecto de v90, conservando la sincronización con el reloj del audio.

## Cambios de v90

- Corregidas las tres defensas del sexto mundo: los minijefes incidentales ya no ocultan el núcleo y no se mezclan con el encuentro final. Se reparan también guardados anteriores de esta zona.
- El núcleo crece y respira tras cada defensa; al completar la tercera se transforma en el jefe.
- Final con pantalla negra, pétalos, destellos dorados, texto y el audio proporcionado. «Quiero más…» abre el séptimo mundo tras un destello rojo. La escena se puede saltar.
- Una bomba por oleada de campaña en Masoquista: 40 de vida; tras 4 s desarrolla patas, pasa a 100 de vida y corre hacia el jugador. Su contacto quita el 50 % de la vida máxima.
- Se conservan los guardados y trofeos existentes. Ranked conserva las reglas actuales del servidor; estas mecánicas nuevas corresponden a la campaña local.

## Cambios de v82

- **Recomendable** encima de la tarjeta de campaña y **Beta** encima de Caos.
- El guardián del primer mundo de campaña tiene **20% menos vida**, **20% menos daño** y sus recargas avanzan un 20% más despacio: aproximadamente **25% más tiempo entre ataques**. Tiene una breve espera inicial antes de disparar. El ajuste se aplica una sola vez también a jefes ya guardados. No reduce las estadísticas de ese jefe en Caos ni las del Vacío.
- El jugador puede **reparar el núcleo durante un jefe de campaña** acercándose y pulsando **Interactuar / E**. Se conservan el coste y las esperas de reparación: 3 s en Fácil/Normal, 5 s en Hardcore y 6 s en Masoquista. Un núcleo ausente no puede repararse. La excepción no desbloquea reparaciones generales de estructuras durante combate.
- El Beyblade solo concede su velocidad de giro **mientras está ejecutando el ataque**, no por llevarlo equipado. Se conservan 9 de daño base por pulso y 4,2 s de recarga.
- Corregida una causa reproducible de la ventana de error de Caos: el escudo eliminaba proyectiles dentro de un recorrido por índices y dejaba referencias inválidas. Los recorridos usan instantáneas, comprueban que el proyectil siga activo y lo eliminan por identidad. También se protege el recorrido de enemigos ante bajas encadenadas.
- La recuperación automática de errores de **Caos infinito** carga su propia partida. El límite de un intento por batallón también distingue modo y partida; no sustituye Infinito por Caos normal.
- Las primeras misiones muestran cantidades y pasos concretos: **Interactuar / E**, **Crafteo / C → Armas**, **Construir / B → EXPANDIR ISLA**, y **Crafteo → Bengala**. Las partidas anteriores conservan su progreso de tutorial.
- **EXPANDIR ISLA** tiene una tarjeta destacada, botón grande, nivel de ampliación y coste visible. Conserva sus precios y requisitos.
- Aserradero, cultivos, mina, fábrica de hierro y mercado producen **12% más rápido**: su intervalo se divide entre 1,12. La fábrica de diamantes conserva su intervalo de 22 segundos.
- Los 19 audios son **idénticos a los de v81**, con sus rutas originales. Se mantienen partidas, récords y trofeos.

## Caos normal e infinito

Al iniciar Caos eliges arma, dificultad y después **normal o infinito**.

| Regla | Normal | Infinito |
| --- | --- | --- |
| Duración | 30 oleadas | Sin final |
| Vidas | Una | Una |
| Jefes | Cada 3 oleadas; Pelota Roja al final | Cada tercer batallón; aleatorios y pueden repetirse |
| Pelota Roja | Jefe final | Nunca aparece |
| Recompensa de jefe | Una mejora a elegir | Una mejora a elegir |
| Cantidad de opciones | 3 en Fácil/Normal; 2 en Hardcore/Masoquista | Igual |
| Cambiar de arma | Arma inicial | Botón **Elegir armas** debajo de los datos del jugador entre batallones |
| Registro | Marca y trofeos existentes | Mejor batallón **superado**, separado por dificultad, encima de los trofeos |

Infinito empieza más suave y aumenta progresivamente la resistencia, el daño y el ritmo de los enemigos. Los refuerzos especiales de dificultad de los jefes siguen activos. Sus grupos, efectos y aliados mantienen límites para evitar acumulaciones sin control.

El botón de armas aparece al despejar el batallón y elegir la mejora si corresponde. Abrir la selección pausa el juego. Cambiar de arma conserva recargas y mejoras; no reinicia las ultis. El siguiente batallón empieza tras la espera habitual si no abres la selección.

Infinito no concede los trofeos de completar Caos normal. Las condiciones existentes del modo Masoquista y de los trofeos se conservan.

### Mejoras de Infinito

Las mejoras generales tienen **5 niveles**. Además del aumento habitual, los niveles 3 y 5 añaden evoluciones. Las **exclusivas de arma se eligen una sola vez por partida**. No se añadieron exclusivas nuevas.

| Mejora | Evolución de nivel 3 | Evolución de nivel 5 |
| --- | --- | --- |
| Filo imposible | Eco cada 4 impactos | Mayor radio del eco |
| Corazón tenaz | Segundo aliento cura 25% de vida máxima | Cura 32% y limpia proyectiles cercanos |
| Pies de relámpago | Las estelas ralentizan sin necesitar Escarcha | Correr limpia proyectiles cercanos periódicamente |
| Reloj roto | Descarga periódica que recupera recargas | Descarga más potente |
| Salto entre grietas | Onda de empuje al completar el dash | La onda limpia proyectiles |
| Burbuja de emergencia | Curación cuando se rompe | Breve invulnerabilidad adicional |
| Robo de vida | Bajas con vida completa conceden defensa temporal | La defensa dura más |
| Nova | Mayor radio | Más radio y pulsos más frecuentes |
| Regeneración | Curación adicional fuera de peligro | Pequeña curación incluso con veneno |
| Orbes | Órbita más amplia | Onda periódica de daño |
| Robot | Tres compañeros; mejora de resistencia en nivel 4 | Más resistencia, mejores tiros y reconstrucción en 20 s |
| Ráfaga de velocidad | Se activa cada 4 bajas | Cada 3 bajas |
| Descargas enlazadas | Cada 3 impactos | Cada 2 impactos |
| Escarcha de aliados | Aturdimiento breve a enemigos livianos | Aturdimiento más fuerte, con límite por objetivo |
| Batería de aliados | Impactos aliados recuperan también el básico | Cada 10 impactos curan y eliminan un proyectil cercano |
| Cosecha de vida | Cada 5 bajas ralentizan cerca | También cura robots |

Hay sinergias entre aliados, curación, estelas, control de enemigos y recarga. Los orbes se limitan a seis y los robots a tres: subir niveles no genera aliados ilimitados. Cuando faltan mejoras elegibles aparecen suministros de curación, recarga o mantenimiento, que no tienen niveles. Se conserva la protección de **0,5 segundos** contra pulsaciones accidentales al elegir.

## Tu otro yo y balance

- El modo del átomo se llama directamente **Tu otro yo**, sin referencias narrativas a abrir o cerrar archivos. Conserva su isla tecnológica y su acceso directo.
- La fase negra, por debajo del 15% de vida, acelera movimientos, esquivas y ataques y añade ráfagas. La música se reproduce un **8% más rápido** durante esa fase y recupera su velocidad normal al terminar.
- La conversación final tiene ocho preguntas con tres respuestas cada una, humor y un rival más arrogante. Reacciona al arma equipada y a cada respuesta. Las preguntas de matemáticas e historia se conservan con un tono más ligero.
- **Beyblade: 9 de daño base por pulso y recarga de 4,2 s**, antes 4,4 s. El valor se aplica al impacto real y a los datos del arma.
- Se conservan los demás cambios de v80: reparaciones de todas las estructuras en Fácil/Normal fuera de combate, guardado reforzado, cosméticos, campaña y balance anterior.

## Guardar, continuar y trasladar partidas

Campaña, Caos normal y Caos infinito tienen **tres guardados independientes**. El duelo no sobrescribe ninguno. Las partidas anteriores de campaña y Caos siguen siendo compatibles; una partida antigua de Caos continúa como **Caos normal**.

El guardado automático mantiene sus comprobaciones, copia temporal, respaldo y suma de verificación. Un estado inválido no reemplaza el guardado anterior. **Continuar** busca una copia válida si el archivo principal está dañado. Si falla guardar y salir, la partida permanece abierta para exportarla. Morir en Caos termina esa partida y evita recuperarla automáticamente desde un respaldo.

En **Copias de partida** puedes exportar campaña, Caos normal y **Caos infinito**. También puedes exportar la partida abierta desde Ajustes. Para recuperar un `.json`, vuelve al menú, importa la copia y pulsa el botón de continuar correspondiente. Se detecta su modo y se valida antes de escribir.

Los récords y trofeos se conservan localmente al crear otra partida. Exportar una partida exporta ese mundo, no todos los ajustes, récords o trofeos del navegador. Cambiar de dominio, navegador o dispositivo no traslada esos datos automáticamente. Borrar los datos del navegador puede eliminar las partidas y sus respaldos; conserva copias exportadas fuera del navegador.

## Música incluida

| Archivo en `assets/music` | Uso |
| --- | --- |
| `menu.mp3` | Menú |
| `world1.mp3` a `world5.mp3` | Exploración de cada mundo |
| `world6.mp3` | Ambiente del Vacío |
| `campaign_wave.mp3` | Oleadas de campaña |
| `campaign_boss.mp3` | Jefes de campaña |
| `void_boss.mp3` | Jefe del sexto mundo |
| `secret_boss.mp3` | Jefe del séptimo mundo |
| `chaos_wave.mp3` | Oleadas de Caos normal |
| `chaos_boss.mp3` | Nueva música de jefes de Caos normal: `Modocaos_jefes(1).mp3` |
| `chaos_final.mp3` | Pelota Roja en Caos normal |
| `infinite_wave.mp3` | `Infinito_oleadas.mp3` |
| `infinite_boss1.mp3` | `Infinito_Jefes1.mp3` |
| `infinite_boss2.mp3` | `Infinito_Jefes2.mp3` |
| `infinite_boss3.mp3` | `Infinito_Jefes3.mp3` |
| `lost_file_boss.mp3` | Duelo contra Tu otro yo; se conserva el nombre técnico para compatibilidad |

Incluye **19 MP3**. En cada encuentro de jefe de Infinito se elige una de sus tres pistas al azar; la elección se conserva durante el combate y al continuar. No cambia al abrir una ventana ni en cada fotograma.

Los audios del paquete se comprimieron a 64 kbps; las cuatro pistas nuevas de Infinito a 56 kbps, para mantener el ZIP por debajo de 25 MB. No se recortaron intencionalmente las canciones ni se modificaron los archivos originales proporcionados. No cambies los nombres ni las carpetas. Un solo reproductor evita que se mezclen músicas. Se repiten en bucle; la suavidad de la unión depende también del audio original.

Activa el sonido en ajustes e interactúa con la página para autorizar la reproducción. Los audios conservan las condiciones de uso de sus autores.

## Sugerencias y errores

Activa **Settings → General → Features → Issues** en GitHub. El botón de reportes prepara el contenido; el jugador debe publicarlo, no se envía automáticamente. En `config.js` puedes indicar la URL de tu repositorio o un formulario externo. Para GitHub Pages estándar, el repositorio se detecta automáticamente.

## Verificación de v82

En v81 se comprobaron arranque y sintaxis, 90 batallones consecutivos, ausencia de la Pelota Roja en Infinito, final del Caos normal, límites y elección de mejoras, cambio de armas, simulación de todos los jefes elegibles y efectos, guardado independiente, continuación por encima del batallón 30, respaldo ante corrupción, rechazo de estados inválidos y carga de una partida generada con el código v80. También se revisaron las ramas de diálogo, fase negra, reproducción acelerada y restablecimiento del tempo, rutas y decodificación de los audios e integridad del ZIP.

En v82 se reprodujo y verificó la corrección del fallo de proyectiles con escudos en ambos modos de Caos, incluidos proyectiles especiales. Se probaron los cambios de velocidad, reparación, daño del primer jefe, generadores, misiones, continuidad desde v81 y recuperación de Infinito. También se ejecutaron 108 combinaciones de jefes/armas/modos y 26 escenarios con grupos densos de enemigos, mejoras y armas distintas, sin excepciones en esas simulaciones.

Las pruebas de lógica usan un entorno de navegador simulado y renderizado Canvas nativo. **No sustituyen una partida manual en un navegador o teléfono real**: prueba los controles, el audio y el cambio de orientación en tus dispositivos antes de anunciar la versión.

## Cuentas y Rankeds · BETA

El menú tiene tres páginas: **Cuentas ← Inicio → Rankeds**. Puedes deslizar horizontalmente o usar los botones superiores. En Cuentas puedes registrarte, entrar y recuperar tu contraseña con correo electrónico; Gmail funciona como cualquier otro correo. No se solicita la contraseña del correo. Google OAuth no está habilitado en el proyecto.

Al crear un mundo, **Jugar para Rankeds · BETA** inicia un intento nuevo con cuenta y conexión. El cronómetro se pausa en los menús. Solo se publican resultados derivados de la reproducción de controles en el servidor. Continuar un guardado es una partida local y no reanuda el intento competitivo. Consulta [SECURITY.md](SECURITY.md).

### Configuración de los correos de cuenta

En el proyecto Supabase **Umbralia-ranked → Authentication → URL Configuration**, establece:

- Site URL: `https://neliux.github.io/Umbralia/`
- Redirect URLs: añade exactamente `https://neliux.github.io/Umbralia/`

Este ajuste es necesario para que los enlaces de confirmación y recuperación vuelvan al juego. La conexión disponible permite trabajar con la base de datos, pero no editar esta configuración de Auth. El registro exige confirmar el correo. Comprueba un registro real y una recuperación tras configurar estas direcciones. No hemos enviado correos de prueba a terceras personas. Para abrir el registro a muchos jugadores, configura un proveedor SMTP propio y los controles de abuso desde Supabase; el envío incluido tiene límites.

Las cuentas usan Supabase Auth. La contraseña se envía por HTTPS directamente a Auth y no se guarda en el juego. El SDK conserva la sesión en el navegador para permitir seguir conectado; cerrar sesión no borra mundos locales. **La cuenta no sincroniza ni respalda los mundos.**

### Balance de la versión anterior (v84)

- Faro de impulso: radio 210 → **270**.
- Auto: bolas de fuego 32 → **28**; choque y protección se conservan.
- Laptop: básicos **25 / 38 / 22 / 17 / 47**, según el modo. Dominio sin cambios.

Se mantienen los nombres de las claves de guardado y se aceptan versiones anteriores. Se conservan los 19 audios originales del repositorio.

### Desarrollo y comprobaciones

GitHub Pages sirve directamente los archivos incluidos. No requiere instalar Node en producción.

```sh
npm ci
npm run build
npm test
```

`src/accounts.js` es la fuente del módulo de cuentas; `assets/ranked/accounts.js` es el bundle listo para el navegador. Las versiones de las dependencias están fijadas en `package-lock.json`. No añadas contraseñas ni claves administrativas a `config.js`.

Los archivos `supabase/sql/` documentan migraciones ya aplicadas. No los ejecutes otra vez en la misma base.

## Casa de gatos y balance de v85

La **Casa de gatos** se desbloquea en expansión 3. Máximo tres casas: cada una invoca un gato cada cinco segundos, hasta tres gatos vivos propios. Cada gato tiene 28 de vida, hace 4 de daño cada 0,9 s y busca enemigos cerca de su casa. Caminan, atacan y duermen al terminar el combate. La pérdida de un gato deja un espacio para el siguiente; destruir o vender su casa retira sus compañeros. Casas y gatos se guardan con el mundo. En gráficos simples sus poses no usan la oscilación ni los trazos de ataque.

Tridente, Empanada, Gaia y Guantes tienen descuentos: sus costes existentes de madera/piedra quedan entre 1800 y 2000 después de los modificadores de dificultad; el hierro baja un 10%. No se añaden recursos que no estaban en la receta. Los demás materiales se conservan.

El Obelisco pasa de radio 84 a 97; el fuego del auto baja de 28 a 24 y la Empanada gigante de 18 a 14 por pulso. La descripción del robot es más breve.

Las pruebas de esta versión cubren intervalos, límites, combate, descanso, daño recibido, persistencia y precios en las cuatro dificultades. El cronómetro de Ranked sigue siendo una prueba local no verificada: la actualización de gatos no activa la competición oficial. La configuración de retorno de Auth y el servidor de simulación verificada siguen pendientes; no se sustituyen por una aceptación de puntuaciones del navegador.

## Gatos dorados y acertijo · v89

Los gatos tienen **42 de vida y 6 de daño**. La casa tiene **340 de vida base** y gana experiencia con las bajas de sus propios gatos. Mejora con **4, 9 y 16 bajas acumuladas**, con detalles dorados y estrellas. La primera mejora aumenta la vida de los gatos a **54**; la segunda aumenta su velocidad de **72 a 90**; la tercera permite **4 gatos vivos por casa**, manteniendo el máximo de tres casas. Las mejoras afectan a los compañeros existentes y a los nuevos. Los gatos tienen siluetas redondeadas más sencillas; mantienen las poses de caminar, atacar y dormir. Los guardados antiguos se adaptan una sola vez, conservando la proporción de vida.

En el mundo 4, validar los valores del altar y acertar cada nota inicia una defensa. Utiliza el número de oleada actual, sin fijarlo a un ejemplo ni reiniciar la progresión. Debes terminar esa oleada antes de avanzar en el acertijo; el Director espera a que termine la última defensa.

Todos los generadores, incluido el de diamantes, producen **un 20% más rápido**: su tiempo de ciclo se divide entre 1,2. La cantidad generada por ciclo no cambia.

Se mantienen los audios y los límites actuales de la beta de Rankeds. La confirmación/recuperación por correo sigue requiriendo configurar las URLs indicadas arriba; no se ha confirmado una sesión administrativa en el navegador.

## Actualización v87

- Rankeds BETA: inicio autenticado, registro de controles, cola privada y reproducción del motor en GitHub Actions antes de publicar la mejor marca. Nueve clasificaciones separadas por modo y dificultad; el cronómetro se pausa en menús. Puede tardar varios minutos. Ver `SECURITY.md` para límites y operación.
- Casa de gatos desde expansión 2; gatos con 54 de vida y 8 de daño, 70 de vida en la primera mejora. Las tres mejoras añaden detalles dorados a los gatos.
- Expansión de dominio de Laptop con anillos, pulsos y paneles adicionales, sin cambiar su daño ni recarga.
- Más insectos decorativos según las mejoras del núcleo, hasta cinco. Se esconden en recursos o estructuras antes de desaparecer. Gráficos simples elimina insectos y luciérnagas.
- Las músicas mantienen las mismas rutas y archivos. Guardados y trofeos anteriores siguen siendo compatibles.

### Servicio competitivo

La función `ranked-api` de Supabase controla sesiones y bloques; `supabase/sql/verified87.sql` contiene la migración interna. `.github/workflows/ranked-verify.yml` reproduce la cola con identidad OIDC, sin guardar claves administrativas en GitHub. `server/engines/manifest.json` fija el motor admitido. El frontend no requiere compilación para jugar. Para desarrollar los módulos: `npm ci`, `npm run build`, `npm test`.

El correo de confirmación y recuperación debe estar configurado en Supabase Auth (Site URL: `https://neliux.github.io/Umbralia/`, mismo destino en Redirect URLs). El SMTP predeterminado de Supabase puede restringir destinatarios; el envío público requiere un proveedor de correo configurado. No se incluyen credenciales SMTP en este repositorio.

## Parche v88

El robot de Caos normal e infinito sigue combatiendo incluso por debajo del 25% de vida; vuelve a luchar inmediatamente si un guardado lo dejó en retirada. Conserva su daño, vida y reaparición. En campaña mantiene su comportamiento de mantenimiento y retirada. Las puertas abren sus hojas al acercarte y las cierran al alejarte, sin cambiar colisiones ni estadísticas.

La nueva regla de robots se guarda en los metadatos del intento competitivo como `rules88`. El protocolo de reproducción sigue siendo `87-replay-v1`: el verificador conserva la lógica anterior cuando falta ese indicador, para aceptar intentos iniciados antes del parche. No se reinician la temporada, los récords ni los mundos.

## Parche v89

- Gatos con 68 de vida y 10 de daño; la primera mejora da 88 de vida. Regeneran 3 de vida por segundo únicamente mientras duermen, hasta su máximo. Las heridas se conservan proporcionalmente al actualizar y los gatos derrotados no resucitan.
- Corregido el registro de pausa de Caos al pulsar el indicador superior: antes no se incluía entre los controles, lo que podía invalidar una partida legítima. Se registran también pérdidas de foco y liberaciones del puntero. Los movimientos del cursor sobre botones sin función de arrastre ya no llenan el registro.
- Rankeds muestra el estado del último intento de la cuenta y el motivo de rechazo. Los fallos internos del servicio vuelven a la cola, sin rechazar automáticamente la partida. GitHub puede retrasar la ejecución del verificador.
- Los registros antiguos sin una acción de pausa no pueden reconstruirse con exactitud y no se aprueban manualmente. Los cambios de gatos usan metadatos `rules89`; los intentos anteriores conservan sus estadísticas. Se mantienen los nueve rankings, los mundos y los 19 audios.
