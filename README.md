# Umbralia: Ecos del Tiempo · v83

Juego de acción y supervivencia para navegador: explora siete mundos, construye defensas, combina armas y mejoras y enfréntate a jefes con mecánicas propias. Incluye campaña, Caos normal, Caos infinito y el duelo contra **Tu otro yo**. Para computadora y celular.

## Publicar o actualizar en GitHub Pages

1. Descomprime el ZIP y sube **su contenido** a la raíz del repositorio: `index.html`, `config.js`, `.nojekyll`, `README.md` y la carpeta completa `assets`.
2. Reemplaza los archivos anteriores, incluida la música. Conserva la dirección del juego y los datos del navegador para mantener tus partidas y trofeos. Antes de actualizar, exporta tus partidas como precaución.
3. En **Settings → Pages → Deploy from a branch**, elige **main** y **/(root)** y guarda. Abre el enlace cuando termine el despliegue.
4. El título y la insignia del menú deben mostrar **v83**. Si ves otra versión, recarga sin caché.

No necesita instalación ni compilación. El JavaScript y los estilos están integrados en `index.html`. Prueba local: `python3 -m http.server 8000` y abre `http://localhost:8000`.

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

## Clasificaciones en línea · v83

En el menú, **Clasificaciones · Ranked** permite consultar Campaña, Caos e Infinito en Normal, Hardcore y Masoquista. Los modos con final se ordenan por tiempo; Infinito por mayor batallón superado y después por menor tiempo. Solo se muestran marcas verificadas y temporadas activas o cerradas.

**Estado: preparación.** Las categorías y la base de lectura están creadas. Todavía no existe un validador del motor del juego ni se aceptan partidas competitivas. El interruptor de nueva partida aparece deshabilitado, y las partidas casuales y sus guardados mantienen su funcionamiento.

La configuración pública de Supabase usa una clave publicable, no una contraseña ni una clave administrativa. F12 puede mostrar esta configuración sin conceder permisos de escritura en el ranking. Consulta [SECURITY.md](SECURITY.md) para conocer las protecciones y el trabajo pendiente.

Los archivos `supabase/sql/` documentan cambios ya aplicados al proyecto. No los ejecutes de nuevo sobre la misma base: se conservan para revisión y reproducción en un proyecto de pruebas.

Pruebas: `node --test tests/ranked.test.cjs` y `node scripts/check-client-secrets.cjs`. No hay dependencias de Node para estas comprobaciones ni nuevas bibliotecas descargadas por el navegador.
