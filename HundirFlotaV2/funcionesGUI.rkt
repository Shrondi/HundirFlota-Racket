#lang s-exp lang/plt-pretty-big


(provide dibujar-juego)
(provide empezar-partida)
(provide aumentar/disminuir-interfaz)

(require "gui/ventana.rkt")
(require "gui/paneles.rkt")
(require "gui/mensajes.rkt")
(require "gui/textos.rkt")
(require "gui/opciones.rkt")
(require "gui/canvas.rkt")
(require "gui/botones.rkt")
(require "gui/temporizadores.rkt")
(require "funcionesGenerar.rkt")
(require "funcionesDibujar.rkt")
(require "funcionesLimpiar.rkt")
(require "macros.rkt")
(require "funciones.rkt")
(require "estructuras.rkt")
(require "funcionesLogica.rkt")


(define (dibujar-juego)
  
;;(send ventana-principal begin-container-sequence)
  
  ;; El translate hace que la cuadricula se vea mejor
  ;;(send (send tablero-jugador get-dc) translate 0.1 0.1)

  
  ;; -> ENCABEZADO
  ;;---------------------------------------------------
  (send ventana-principal add-child panel-encabezado)
  
  (send panel-encabezado add-child boton-aumentar)
  (send panel-encabezado add-child mensaje-tamaño)
  (send panel-encabezado add-child boton-disminuir)

  (send panel-encabezado add-child panel-estado)
  
      ;; * Mensaje:
       (send panel-estado add-child mensaje-estado)
      ;;---------------------------------------------------
  (send panel-encabezado add-child boton-reiniciar)
  (send boton-reiniciar show #f)
  (send panel-encabezado add-child boton-ayuda)
 
  
  ;; -> PANEL PRINCICPAL
  ;;---------------------------------------------------
  (send ventana-principal add-child panel-principal)

  ;; * Panel principal jugador
  (send panel-principal add-child panel-vertical-principal-jugador)
  
  (send panel-vertical-principal-jugador add-child panel-horizontal-disparos-CPU)
  
  ;; * Estadisticas
  (send panel-horizontal-disparos-CPU add-child texto-estadisticas-CPU)
    
  (send panel-horizontal-disparos-CPU add-child boton-historial-CPU)
  (send boton-historial-CPU show #f)

  
  ;; * Tablero jugador:
  (send panel-vertical-principal-jugador add-child panel-tablero-jugador)

        ;; ** Canvas auxiliar:
       (send panel-tablero-jugador add-child canvas-jugador-auxiliar)
       (send canvas-jugador-auxiliar show #f)
  
       ;; ** Panel horizontal:
       (send panel-tablero-jugador add-child panel-horizontal-jugador)
  
             (send panel-horizontal-jugador add-child panel-vertical-secundario-jugador)
                 (send panel-vertical-secundario-jugador add-child boton-anclar/desanclar-jugador)
  
                  ;; *** Estado barcos:
                  (send panel-vertical-secundario-jugador add-child estado-barcos-jugador)

   
             ;; *** Numeros fila:
             (send panel-horizontal-jugador add-child numeros-fila-jugador)
             ;; *** Panel vertical:
             (send panel-horizontal-jugador add-child panel-vertical-jugador)
                    ;; **** Letras columna:
                    (send panel-vertical-jugador add-child letras-columna-jugador)
                    ;; **** Tablero:
                    (send panel-vertical-jugador add-child tablero-jugador)
                    ;; ***** Nombre tablero
                    (send panel-vertical-jugador add-child mensaje-nombre-tablero-jugador)

   ;; * Panel principal CPU
  (send panel-principal add-child panel-vertical-principal-CPU)

  (send panel-vertical-principal-CPU add-child panel-horizontal-disparos-jugador)

  ;; * Estadisticas
  (send panel-horizontal-disparos-jugador add-child texto-estadisticas-jugador)
  (send panel-horizontal-disparos-jugador add-child boton-historial-jugador)
  (send boton-historial-jugador show #f)

    
  
  ;; * Tablero CPU:
  (send panel-vertical-principal-CPU add-child panel-tablero-CPU)
       ;; ** Panel horizontal:
       (send panel-tablero-CPU add-child panel-horizontal-CPU)
             ;; *** Numeros fila:
             (send panel-horizontal-CPU add-child numeros-fila-CPU)
             ;; *** Panel vertical:
             (send panel-horizontal-CPU add-child panel-vertical-CPU)
                    ;; **** Letras columna:
                    (send panel-vertical-CPU add-child letras-columna-CPU)
                    ;; **** Tablero:
                    (send panel-vertical-CPU add-child tablero-CPU)
                    ;; ***** Nombre tablero
                    (send panel-vertical-CPU add-child mensaje-nombre-tablero-CPU)
  
       (send panel-horizontal-CPU add-child panel-vertical-secundario-CPU)
                  (send panel-vertical-secundario-CPU add-child boton-anclar/desanclar-CPU)
             ;; *** Estado barcos:
             (send panel-vertical-secundario-CPU add-child estado-barcos-CPU)

  
  
       ;; ** Canvas auxiliar:
       (send panel-tablero-CPU add-child canvas-CPU-auxiliar)
  ;;---------------------------------------------------
  
  
  (send ventana-principal add-child panel-horizontal-pie)
  
  (send panel-horizontal-pie add-child conjunto-panel-generar)
  (send conjunto-panel-generar add-child panel-horizontal-botones-generar)
  (send panel-horizontal-botones-generar add-child boton-flota-aleatoria)
  (send panel-horizontal-botones-generar add-child boton-barco-aleatorio)


  (send panel-horizontal-pie add-child conjunto-panel-opciones-archivador)
  (send conjunto-panel-opciones-archivador add-child panel-horizontal-botones-opciones-archivador)
  (send panel-horizontal-botones-opciones-archivador add-child boton-guardar-tablero)
  (send panel-horizontal-botones-opciones-archivador add-child boton-archivador)
  
  (send panel-horizontal-pie add-child boton-limpiar-tablero)
  
  
  (send panel-horizontal-pie add-child conjunto-panel-CPU)
      (send panel-horizontal-ajustes-CPU add-child elecciones-dificultad-CPU)
      (send panel-horizontal-ajustes-CPU add-child panel-vertical-tiempos-espera)

  (send panel-horizontal-pie add-child boton-confirmar-tablero)
  
  

  
;;(send ventana-principal end-container-sequence)
  )

(define (crear-texto-estadisticas editor-texto-jugador editor-texto-CPU texto-disparos texto-disparos-agua texto-disparos-tocado  texto-disparos-hundido)
  
    (define (cambiar-color-texto-estadisticas color editor-texto cadena)
    
      (define style-delta (make-object style-delta% 'change-normal-color))
      (send style-delta set-delta-foreground color)
  
      (define pos (send editor-texto find-string cadena 'forward 0))
      (send editor-texto change-style style-delta pos (+ pos (string-length cadena) 3))

      )

    (define texto-CPU (send editor-texto-CPU get-editor))
    (define texto-jugador (send editor-texto-jugador get-editor))
  
    (send texto-CPU insert (string-append texto-disparos " 0" texto-disparos-agua " 0" texto-disparos-tocado " 0" texto-disparos-hundido " 0"))
    (send texto-jugador insert (string-append texto-disparos " 0" texto-disparos-agua " 0" texto-disparos-tocado " 0" texto-disparos-hundido " 0"))

    (cambiar-color-texto-estadisticas "Blue" texto-jugador texto-disparos-agua)
    (cambiar-color-texto-estadisticas "Blue" texto-CPU texto-disparos-agua)

    (cambiar-color-texto-estadisticas "Red" texto-jugador texto-disparos-tocado)
    (cambiar-color-texto-estadisticas "Red" texto-CPU texto-disparos-tocado)

    (cambiar-color-texto-estadisticas "Purple" texto-jugador texto-disparos-hundido)
    (cambiar-color-texto-estadisticas "Purple" texto-CPU texto-disparos-hundido)

    )


(define (empezar-partida)

  (generar-flota-aleatoriamente-CPU)
  
  (crear-texto-estadisticas texto-estadisticas-jugador texto-estadisticas-CPU texto-disparos texto-disparos-agua texto-disparos-tocado texto-disparos-hundido)

  (send boton-historial-jugador show #t)
  (send boton-historial-CPU show #t)
  (send boton-reiniciar show #t)

  ;; Se limpia el tablero y se vuelve a redibujar para eliminar los sombreados
  (limpiar-canvas-tablero (send tablero-jugador get-dc))
  (dibujar-flota-barcos (send tablero-jugador get-dc) flota-barcos-jugador)
  
 (send ventana-principal delete-child panel-horizontal-pie)

  (send tablero-jugador enable #f)
  
  (if (turno-inicial-jugador?) (turno-jugador! #t) (turno-jugador! #f))

  (dibujar-flota-disponible (send estado-barcos-jugador get-dc) barcos-plantilla)

  (send temporizador-cuenta-atras start 1000)

  (newline) (newline) (newline)
  (display "FLOTA BARCOS JUGADOR") (newline)
  (mostrar-matriz flota-barcos-jugador)

  (display "FLOTA BARCOS CPU") (newline)
  (mostrar-matriz flota-barcos-CPU)

  )


(define (aumentar/disminuir-interfaz step)

    (cambiar-tamaño! step)

  ;; TABLEROS
  (send tablero-jugador min-width anchura-tablero)
  (send tablero-jugador min-height altura-tablero)

  (send tablero-CPU min-width anchura-tablero)
  (send tablero-CPU min-height altura-tablero)

  ;; AUXILIARES
  (send canvas-jugador-auxiliar min-width anchura-tablero)
  (send canvas-jugador-auxiliar min-height altura-tablero)

  (send canvas-CPU-auxiliar min-width anchura-tablero)
  (send canvas-CPU-auxiliar min-height altura-tablero)

  ;; LETRAS
  (send letras-columna-jugador min-height cell-height)
  (send letras-columna-jugador min-width anchura-tablero)
                   
  (send letras-columna-CPU min-height cell-height)
  (send letras-columna-CPU min-width anchura-tablero)
                   

  ;; Numeros
  (send numeros-fila-jugador min-height (+ altura-tablero cell-height))
  (send numeros-fila-CPU min-height (+ altura-tablero cell-height))

  ;; Flota estado
  (send estado-barcos-jugador min-height altura-tablero)
  (send estado-barcos-CPU min-height altura-tablero)

  (send mensaje-nombre-tablero-CPU min-height cell-height)
  (send mensaje-nombre-tablero-jugador min-height cell-height)

  ;; Nombre tablero

  (send ventana-principal refresh)
  )







