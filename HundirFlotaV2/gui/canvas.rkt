#lang s-exp lang/plt-pretty-big

(provide canvas-archivador)
(provide tablero-jugador tablero-CPU)
(provide canvas-jugador-auxiliar canvas-CPU-auxiliar)
(provide numeros-fila-jugador numeros-fila-CPU)
(provide letras-columna-jugador letras-columna-CPU)
(provide estado-barcos-jugador estado-barcos-CPU)

(require racket/lazy-require)
(require "dialogos.rkt")
(require "paneles.rkt")
(require "../macros.rkt")
(lazy-require ["funcionesCallback/callbackCanvas.rkt" (callback-canvas-heatmap
                                                       callback-canvas-archivador
                                                       callback-tablero-jugador
                                                       callback-tablero-CPU
                                                       callback-canvas-auxiliar
                                                       callback-numeros-fila
                                                       callback-letras-columna
                                                       callback-estado-barcos-jugador
                                                       callback-estado-barcos-CPU
                                                       callback-on-event-jugador
                                                       callback-on-event-CPU)])


(define tablero-jugador-canvas%
  (class canvas% ; The base class is canvas%
    ; Define overriding method to handle mouse events
    (define/override (on-event evento)
      (callback-on-event-jugador evento)
      )
    ; Call the superclass init, passing on all init args
    (super-new)
    )
  )

(define tablero-CPU-canvas%
  (class canvas% ; The base class is canvas%
    ; Define overriding method to handle mouse events
    (define/override (on-event evento)
      (callback-on-event-CPU evento)
      )
    ; Call the superclass init, passing on all init args
    (super-new)
    )
  )



(define canvas-archivador
  (new canvas%
       [parent dialogo-archivo]
       [style '(vscroll no-autoclear)]
       [paint-callback callback-canvas-archivador]
       )
  )




(define tablero-jugador
  (new tablero-jugador-canvas%
       [style '(deleted)]                       
       [parent panel-vertical-jugador]
       [paint-callback callback-tablero-jugador]
       [min-width anchura-tablero]
       [min-height altura-tablero]
       ;;[stretchable-width #f]	 
       ;;[stretchable-height #f]
       ))




(define tablero-CPU
  (new tablero-CPU-canvas%
       [style '(deleted)]
       [parent panel-vertical-CPU]
       [paint-callback callback-tablero-CPU]
       [min-width anchura-tablero]
       [min-height altura-tablero]
       ;;[stretchable-width #f]	 
       ;;[stretchable-height #f]
       ))




(define canvas-jugador-auxiliar
  (new canvas%
       [style '(deleted no-autoclear transparent)]
       [parent panel-tablero-jugador]
       [enabled #f]
       [horiz-margin 0]
       [paint-callback callback-canvas-auxiliar]
       [min-width anchura-tablero]
       [min-height altura-tablero]
       [stretchable-width #f]	 
       [stretchable-height #f]
       ))




(define canvas-CPU-auxiliar
  (new canvas%
       [style '(deleted no-autoclear transparent)]
       [parent panel-tablero-CPU]
       [enabled #f]
       [horiz-margin 50]
       [paint-callback callback-canvas-auxiliar]
       [min-width anchura-tablero]
       [min-height altura-tablero]
       [stretchable-width #f]	 
       [stretchable-height #f]
       ))




(define numeros-fila-jugador
  (new canvas%
       [style '(deleted no-autoclear transparent)]                       
       [parent panel-horizontal-jugador]
       [min-width cell-width]
       [min-height (+ altura-tablero cell-height)]
       [paint-callback callback-numeros-fila]
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )




(define numeros-fila-CPU
  (new canvas%
       [style '(deleted no-autoclear transparent)]                       
       [parent panel-horizontal-CPU]
       [min-width cell-width]
       [min-height (+ altura-tablero cell-height)]
       [paint-callback callback-numeros-fila]
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )




(define letras-columna-jugador
  (new canvas%
       [style '(deleted no-autoclear transparent)]                       
       [parent panel-vertical-jugador]
       [min-width anchura-tablero]
       [min-height cell-height]
       [paint-callback callback-letras-columna]
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )




(define letras-columna-CPU
  (new canvas%
       [style '(deleted no-autoclear transparent)]                       
       [parent panel-vertical-CPU]
       [min-width anchura-tablero]
       [min-height cell-height]
       [paint-callback callback-letras-columna]
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )



(define estado-barcos-jugador
  (new canvas%
       [style '(deleted no-autoclear transparent)]                       
       [parent panel-vertical-secundario-jugador]
       [min-width 250]
       [min-height altura-tablero]
       [paint-callback callback-estado-barcos-jugador]
       )
  )




(define estado-barcos-CPU
  (new canvas%
       [style '(deleted no-autoclear transparent)]                       
       [parent panel-vertical-secundario-CPU]
       [min-width 250]
       [min-height altura-tablero]
       [paint-callback callback-estado-barcos-CPU]
       )
  )