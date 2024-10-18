#lang s-exp lang/plt-pretty-big

(provide callback-boton-iniciar-partida
         callback-boton-ayuda
         callback-boton-salir
         callback-habilitar-boton-reiniciar
         callback-boton-flota-aleatoria
         callback-boton-barco-aleatorio
         callback-boton-limpiar-tablero
         callback-boton-confirmar-tablero
         callback-boton-archivador
         callback-boton-guardar-fichero
         callback-boton-guardar-tablero
         callback-boton-disminuir
         callback-boton-aumentar
         callback-boton-historial-jugador
         callback-boton-historial-CPU
         callback-boton-anclar/desanclar-jugador
         callback-boton-anclar/desanclar-CPU
         callback-boton-espera-inicial
         callback-boton-espera-disparos
         callback-boton-nueva-partida
         callback-boton-reiniciar
         callback-boton-mostrar-tablero-CPU)


(require racket/string)
(require racket/system)

(require "../ventana.rkt")
(require "../paneles.rkt")
(require "../botones.rkt")
(require "../opciones.rkt")
(require "../canvas.rkt")
(require "../dialogos.rkt")
(require "../mensajes.rkt")
(require "../textos.rkt")
(require "../temporizadores.rkt")
(require "../../funcionesDibujar.rkt")
(require "../../funcionesGenerar.rkt")
(require "../../funcionesLimpiar.rkt")
(require "../../funcionesGUI.rkt")
(require "../../funciones.rkt")
(require "../../funcionesLogica.rkt")
(require "../../macros.rkt")
(require "../../estructuras.rkt")


(define (callback-boton-iniciar-partida b e)
  (send ventana-principal delete-child panel-menu)
  
  (dibujar-juego)
  )

(define (callback-habilitar-boton-reiniciar)
(send boton-reiniciar enable #t)
  )

(define (callback-boton-salir b e)

  (send ventana-principal on-close)

  )

(define (callback-boton-ayuda b e)
  (process "xdg-open ayuda/ayuda.html")
  )

(define (callback-boton-flota-aleatoria b e)

  (send boton-barco-aleatorio enable #f)
  (generar-flota-aleatoriamente (send tablero-jugador get-dc) (send estado-barcos-jugador get-dc) flota-barcos-jugador barcos-plantilla)
  (send boton-confirmar-tablero enable #t)
  (send boton-guardar-tablero enable #t)
 
  )


(define (callback-boton-barco-aleatorio b e)

  (generar-barco-aleatoriamente (send tablero-jugador get-dc) (send estado-barcos-jugador get-dc) flota-barcos-jugador barcos-plantilla)
  (botones-tablero-formado)
  )


(define (callback-boton-limpiar-tablero b e)

  (send boton-barco-aleatorio enable #t)
  (send boton-confirmar-tablero enable #f)
  (send boton-guardar-tablero enable #f)
  (limpiar-tablero (send tablero-jugador get-dc) (send estado-barcos-jugador get-dc) flota-barcos-jugador barcos-plantilla)


  )

(define (callback-boton-confirmar-tablero b e)
  (empezar-partida)
  )

(define (callback-boton-archivador b e)
          
  (cond
    ((= (length (obtener-rutas-ficheros-tableros ruta-archivador-tableros)) 0)
     ;;(send dialogo-archivo delete-child elecciones-tableros)
     (send elecciones-tableros clear)
     (send (send canvas-archivador get-dc) draw-bitmap (read-bitmap "imagenes/empty.png") 0 0)
     (cambiar-bitmap-archivador! (read-bitmap "imagenes/empty.png"))
     )
    (else
     ;;(send dialogo-archivo add-child elecciones-tableros)
     (send elecciones-tableros clear)
     (send elecciones-tableros append "")
     (map (lambda (elemento) (send elecciones-tableros append (car (fichero->tablero elemento))))
          (obtener-rutas-ficheros-tableros ruta-archivador-tableros)
          )
     (dibujar-archivador-tableros ruta-archivador-tableros canvas-archivador 1200 0.6)
     (send canvas-archivador init-auto-scrollbars #f (send bitmap-archivador get-height) 0 0)
     )
    )

  (send dialogo-archivo center 'both)
  (send dialogo-archivo show #t)   
  
  )

(define (callback-boton-guardar-fichero b e)
  
  (send mensaje-informar-archivador set-color "Red")
  (let
      (
       (nombre-fichero (send texto-nombre-fichero get-value))
       (nombre-tablero (send texto-nombre-tablero get-value))
       (descripcion-tablero (send texto-descripcion-tablero get-value))
       )
    (cond
      ((or (not (non-empty-string? nombre-tablero)) (not (non-empty-string? nombre-fichero)) (not (non-empty-string? descripcion-tablero)))
       (send mensaje-informar-archivador set-label "Todos los campos son obligatorios")
       )
      ((file-exists? (build-path ruta-archivador-tableros nombre-fichero))
       (send mensaje-informar-archivador set-label "Ya existe un fichero con el mismo nombre")
       )
      (else
       (send mensaje-informar-archivador set-color "Dark Green")
       (send mensaje-informar-archivador set-label "Fichero con el tablero guardado correctamente")
       (send b enable #f)
       (tablero->fichero flota-barcos-jugador nombre-tablero descripcion-tablero (build-path ruta-archivador-tableros nombre-fichero))
       )
      )
    )

  )

(define (callback-boton-guardar-tablero b e)
  (send dialogo-guardar-tablero show #t)

  )


(define (callback-boton-disminuir b e)

  (aumentar/disminuir-interfaz -5)
  
  (if (or (= cell-width 30) (= cell-height 30))
      (send b enable #f)
      )
  
  (send boton-aumentar enable #t)

  (send mensaje-tamaño set-label (string-append "🔍" (number->string (/ (* cell-height 100) 50)) "%"))
  )



(define (callback-boton-aumentar b e)

  (aumentar/disminuir-interfaz 5)
  
  (if (or (= cell-width 70) (= cell-height 70))
      (send b enable #f)
      )
  
  (send boton-disminuir enable #t)

  (send mensaje-tamaño set-label (string-append "🔍" (number->string (/ (* cell-height 100) 50)) "%"))
  )


(define (callback-boton-anclar/desanclar-jugador b e)

  (let
      (
       ;; Se podria usar el argumento b pero no podria cargarse este modulo ni botones.rkt
       ;; en callbackVentanas.rkt debido a un cycle loading
       (label (send boton-anclar/desanclar-jugador get-label))
       )

    (cond
      ((string-ci=? label "📌")
       (send panel-vertical-principal-jugador reparent ventana-desacoplada-jugador) (send ventana-desacoplada-jugador show #t)
       (send boton-anclar/desanclar-jugador set-label "⚓")
       )
      ((string-ci=? label "⚓")
       (send panel-vertical-principal-jugador reparent panel-principal)
       (send panel-principal change-children reverse)
       (send ventana-desacoplada-jugador show #f)
       (send boton-anclar/desanclar-jugador set-label "📌")
       )
      )
    )
  )

(define (callback-boton-anclar/desanclar-CPU b e)

  (let
      (
       ;; Se podria usar el argumento b pero no podria cargarse este modulo ni botones.rkt
       ;; en callbackVentanas.rkt debido a un cycle loading
       (label (send boton-anclar/desanclar-CPU get-label))
       )

    (cond
      ((string-ci=? label "📌")
       (send panel-vertical-principal-CPU reparent ventana-desacoplada-CPU) (send ventana-desacoplada-CPU show #t)
       (send boton-anclar/desanclar-CPU set-label "⚓")
       )
      ((string-ci=? label "⚓")
       (send panel-vertical-principal-CPU reparent panel-principal)
       ;;(send panel-principal change-children reverse)
       (send ventana-desacoplada-CPU show #f)
       (send boton-anclar/desanclar-CPU set-label "📌")
       )
      )
    )
  )

(define (callback-boton-historial-jugador b e)
  (send ventana-historial-jugador refresh)
  (send ventana-historial-jugador show #t)
  )

(define (callback-boton-historial-CPU b e)
  (send ventana-historial-CPU refresh)
  (send ventana-historial-CPU show #t)
  )

(define (callback-boton-espera-inicial b e)

  (cambiar-espera-inicial! (send b get-value))

  )

(define (callback-boton-espera-disparos b e)

  (cambiar-espera-disparos! (send b get-value))

  )

(define (callback-boton-nueva-partida b e)

  (send dialogo-ganador show #f)

  ;; Se limpian los tableros:
  ;;   -- Se ponen a 0 las matrices de los tableros
  ;;   -- Se reinicia al valor por defecto las estructuras de los barcos
  ;;   -- Se redibujan los tableros con solo la cuadricula
  ;;   -- Se redibujan los estados de la flota
  (limpiar-tablero (send tablero-jugador get-dc) (send estado-barcos-jugador get-dc) flota-barcos-jugador barcos-plantilla)
  (limpiar-tablero (send tablero-CPU get-dc) (send estado-barcos-CPU get-dc) flota-barcos-CPU barcos-plantilla-CPU)

  (send tablero-jugador enable #t)

  ;; Reinicio de la habilitacion de tableros
  (send tablero-jugador enable #t)
  (send tablero-CPU enable #t)

  ;; Reiniciar la habilitacion de los tableros
  (send canvas-jugador-auxiliar show #f)
  (send canvas-CPU-auxiliar show #t)
  
  ;; Reinicio de las matrices de disparo
  (reiniciar-tablero! disparos-jugador)
  (reiniciar-tablero! disparos-CPU)

  ;; Reinicio de temporizadores
  (reiniciar-cronometro!)
  (reiniciar-cuenta-atras!)

  ;; Reseterar y borrar el mensaje del cronometro
  (send temporizador-cuenta-atras stop)
  (send mensaje-cronometro set-label "⏱ 0:00")
  (if (send mensaje-cronometro is-shown?)
  (send panel-estado delete-child mensaje-cronometro))

  ;; Volver a incluir los botones de generar, etc
  (send ventana-principal add-child panel-horizontal-pie)

  ;; Reiniciar el estado de los botones
  (send boton-confirmar-tablero enable #f)
  (send boton-guardar-tablero enable #f)
  (send boton-barco-aleatorio enable #t)
  
  ;; Se borran las estadisticas
  (send (send texto-estadisticas-jugador get-editor) erase)
  (send (send texto-estadisticas-CPU get-editor) erase)

  ;; Se borran los historiales de disparos
  (send (send texto-historial-jugador get-editor) erase)
  (send (send texto-historial-CPU get-editor) erase)
  
  ;; Se esconden los botones del historial y reiniciar
  (send boton-historial-jugador show #f)
  (send boton-historial-CPU show #f)
  (send boton-reiniciar show #f)

  ;; Se resetea el mensaje de estado con el mensaje inicial
  (send mensaje-estado set-label "Posicione sus barcos")

  ;; Reiniciar turno jugador
  (turno-jugador! 0)

  ;; Reiniciar mostrar tablero CPU
  (cambiar-mostrar-tablero-CPU! #f)
  (send boton-mostrar-tablero-CPU set-label "Mostrar tablero \n del contrincante")

  )

(define (callback-boton-reiniciar b e)

  (callback-boton-nueva-partida b e)

  )

(define (callback-boton-mostrar-tablero-CPU b e)

  (cond
    ((not mostrar-tablero-CPU)
     (send b set-label "Ocultar tablero \n del contrincante")
  (dibujar-cuadricula (send tablero-CPU get-dc))
  (dibujar-flota-barcos (send tablero-CPU get-dc) flota-barcos-CPU)
  (dibujar-flota-barcos-disparos (send tablero-CPU get-dc) disparos-jugador)

  (cambiar-mostrar-tablero-CPU! #t)
  )
    (else
     (send b set-label "Mostrar tablero \n del contrincante")
     
     (limpiar-canvas-tablero (send tablero-CPU get-dc))
     (dibujar-flota-barcos-disparos (send tablero-CPU get-dc) disparos-jugador)

     (cambiar-mostrar-tablero-CPU! #f)
     )
    )

  )
