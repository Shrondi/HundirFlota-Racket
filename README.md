# Proyecto Hundir la Flota

**Autor:** Carlos Lucena Robles  
**Asignatura:** Programación Declarativa  
**Curso:** 2023 - 2024  
**Universidad:** Universidad de Córdoba  
**Grado:** 4º de Ingeniería Informática  

---

## Descripción

Proyecto realizado para la asignatura de Programación Declarativa basado en el juego "Hundir la Flota" utilizando programación declarativa e interfaces gráficas en Racket.

---

## Versiones

### Versión 1: HundirFlotaV1
- Incluye caracteres Unicode (puede que algunos iconos no sean visibles dependiendo de la configuración del sistema operativo).
- Incluye una imagen con transparencia usada durante el cambio de turno que podría aparecer como opaca en algunos sistemas operativos. No afecta a la jugabilidad, solo es un efecto visual.

### Versión 2: HundirFlotaV2
- No incluye los caracteres Unicode que son sustituidos por texto.
- No incluye la imagen con transparencia mostrada durante el cambio de turno.

---

## Ejecución
### Desde el intérprete de Racket
1. Abrir el archivo `HundirFlotaVX/main.rkt` (siendo X el número de la versión 1 o 2) con el intérprete DrRacket (versión mínima 8.4).
2. Seleccionar la opción _"Determine language from source"_.
3. (Opcional) Para una ejecución más eficiente:
   - Ir a **Choose Language > Show Details**.
   - Activar **No debugging or profiling**.
   - Desmarcar la casilla **Preserve Stacktrace**.
   Esto mejorará el rendimiento y reducirá el consumo de memoria.
4. Pulsar sobre Run para que la aplicación empiece a ejecutarse.

### Desde la aplicación compilada.
Para crear un ejecutable, dentro del intérprete se encuentra la opción **Racket > Create Executable**. Esto permitirá generar un archivo instalable en otras máquinas, mejorando además la eficiencia al no depender del intérprete.

---

## Estructura del repositorio

```bash
HundirFlotaVX/             # Raíz del proyecto
|-- archivo-tableros/      # Archivos generados de tableros
|-- gui/                   # Elementos de la interfaz
|   |-- botones.rkt
|   |-- canvas.rkt
|   |-- dialogos.rkt
|   |-- mensajes.rkt
|   |-- opciones.rkt
|   |-- paneles.rkt
|   |-- temporizadores.rkt
|   |-- textos.rkt
|   |-- ventana.rkt
|-- funcionesCallback/      # Funciones de los elementos gráficos
|   |-- callbackBotones.rkt
|   |-- callbackCanvas.rkt
|   |-- callbackDialogos.rkt
|   |-- callbackOpciones.rkt
|   |-- callbackTemporizadores.rkt
|   |-- callbackVentanas.rkt
|-- funciones.rkt           # Funciones generales
|-- funcionesGUI.rkt        # Funciones específicas de la GUI
|-- turno.rkt               # Función para cambiar el turno
|-- funcionesLimpiar.rkt    # Limpieza de canvases
|-- funcionesColocar.rkt    # Lógica para la colocación de barcos
|-- funcionesDibujar.rkt    # Dibujado en el canvas
|-- funcionesDisparar.rkt   # Lógica de disparo
|-- funcionesGenerar.rkt    # Generación aleatoria de la colocación de barcos
|-- funcionesLogica.rkt     # Lógica principal del juego
|-- imagenes/               # Recursos gráficos
|-- ayuda/                  # Archivos de ayuda
|-- main.rkt                # Archivo principal del programa
|-- estructuras.rkt         # Definición de estructuras principales
|-- macros.rkt              # Macros globales

Latex                       # Código LaTeX usado para generar la presentación
Presentacion_HundirFlota.pdf
