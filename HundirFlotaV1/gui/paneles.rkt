#lang s-exp lang/plt-pretty-big

(provide panel-menu)
(provide panel-horizontal-disparos-jugador panel-horizontal-disparos-CPU)
(provide panel-vertical-secundario-jugador panel-vertical-secundario-CPU)
(provide panel-horizontal-ajustes-CPU panel-vertical-tiempos-espera)
(provide panel-encabezado panel-estado panel-principal)
(provide panel-vertical-principal-jugador panel-vertical-principal-CPU)
(provide panel-tablero-jugador panel-tablero-CPU)
(provide panel-horizontal-jugador panel-horizontal-CPU)
(provide panel-vertical-jugador panel-vertical-CPU)
(provide panel-horizontal-pie)
(provide conjunto-panel-CPU conjunto-panel-archivador conjunto-panel-generar conjunto-panel-opciones-archivador)
(provide panel-horizontal-botones-generar panel-horizontal-botones-opciones-archivador)

(require "ventana.rkt")
(require "dialogos.rkt")

(define panel-menu
  (new vertical-panel%
       [parent ventana-principal]
       [alignment '(center top)]
       [vert-margin 250]	
       [stretchable-width #t]	 
       [stretchable-height #t]
       )
  )

(define panel-encabezado
  (new horizontal-panel%
       [parent ventana-principal]
       [style '(deleted border)]
       [alignment '(left center)]
       [vert-margin 20]
       [horiz-margin 12]
       ;;[min-width 500]	 
       ;;[min-height 80]
       ;;[min-width 1000]	
       [stretchable-width #t]	 
       [stretchable-height #f]
       )
  )

(define panel-estado
  (new vertical-panel%
       [parent panel-encabezado]
       [style '(deleted)]
       [alignment '(center center)]
       [min-height 85]
       [stretchable-width #t]	 
       [stretchable-height #f]
       )
  )
       

(define panel-principal
  (new horizontal-panel%
       [parent ventana-principal]
       [style '(deleted)]
       [alignment '(center center)]
       [vert-margin 12]
       ;;[min-width (+ (* 2 anchura-tablero) 100)]	 
       ;;[min-height (+ altura-tablero 50)]
       [stretchable-width #t]	 ;; Permitimos que se expanda segun la pantalla
       [stretchable-height #f]
       )
  )

(define panel-vertical-principal-jugador
  (new vertical-panel% [parent panel-principal]
       [style '(deleted)]
       [alignment '(center center)]
       [horiz-margin 12]
       ;;[vert-margin 60]
       ;;[min-width 50]	 
       ;;[min-height altura-tablero]
       ;[stretchable-width #t]	 ;; Permitimos que se expanda segun la pantalla
       [stretchable-height #f]
       )
  )

(define panel-vertical-principal-CPU
  (new vertical-panel% [parent panel-principal]
       [style '(deleted)]
       [alignment '(center center)]
       [horiz-margin 12]
       ;;[min-width 50]	 
       ;;[min-height altura-tablero]
       ;;[stretchable-width #t]	 ;; Permitimos que se expanda segun la pantalla
       [stretchable-height #f]
       )
  )

(define panel-horizontal-disparos-jugador
  (new horizontal-panel%
       [parent panel-vertical-principal-CPU]
       [style '(deleted)]
       [alignment '(center center)]
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )

(define panel-horizontal-disparos-CPU
  (new horizontal-panel%
       [parent panel-vertical-principal-jugador]
       [style '(deleted)]
       [alignment '(center center)]
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )

(define panel-tablero-jugador
  (new panel%
       [parent panel-vertical-principal-jugador]
       [style '(deleted border)]
       [alignment '(right center)]
       [horiz-margin 0]
       ;;[min-width anchura-tablero]	 
       ;;[min-height altura-tablero]
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )

(define panel-horizontal-jugador
  (new horizontal-panel% [parent panel-tablero-jugador]
       [style '(deleted)]
       [alignment '(left top)]
       [horiz-margin 0]
       ;;[min-width anchura-tablero]	 
       ;;[min-height altura-tablero]
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )

(define panel-tablero-CPU
  (new panel% [parent panel-vertical-principal-CPU]
       [style '(deleted border)]
       [alignment '(left center)]
       [horiz-margin 0]
       ;;[min-width anchura-tablero]	 
       ;;[min-height altura-tablero]
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )

(define panel-horizontal-CPU
  (new horizontal-panel% [parent panel-tablero-CPU]
       [style '(deleted)]
       [alignment '(right top)]
       [horiz-margin 0]
       ;;[min-width anchura-tablero]	 
       ;;[min-height altura-tablero]
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )

(define panel-vertical-jugador
  (new vertical-panel% [parent panel-horizontal-jugador]
       [style '(deleted)]
       [alignment '(center center)]
       ;;[horiz-margin 50]
       ;;[min-width 50]	 
       ;;[min-height altura-tablero]
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )

(define panel-vertical-secundario-jugador
  (new vertical-panel%
       [parent panel-horizontal-jugador]
       [style '(deleted)]
       [alignment '(left top)]
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )

(define panel-vertical-secundario-CPU
  (new vertical-panel%
       [parent panel-horizontal-CPU]
       [style '(deleted)]
       [alignment '(right top)]
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )

(define panel-vertical-CPU
  (new vertical-panel% [parent panel-horizontal-CPU]
       [style '(deleted)]
       [alignment '(center center)]
       ;;[vert-margin 60]
       ;;[min-width 50]	 
       ;;[min-height altura-tablero]
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )

(define panel-horizontal-pie
  (new horizontal-panel% [parent ventana-principal]
       [style '(deleted)]
       [alignment '(left center)]

       [stretchable-height #f]
       [stretchable-width #t]
       )
  )




(define conjunto-panel-generar
  (new group-box-panel%
       [label "Generar aleatoriamente"]
       [parent panel-horizontal-pie]
       [alignment '(left center)]
       [style '(deleted)]
       [vert-margin 10]
       [horiz-margin 20]
       [stretchable-width #f]
       [stretchable-height #f]
       )
  )

(define conjunto-panel-opciones-archivador
  (new group-box-panel%
       [label "Guardar o cargar tablero"]
       [parent panel-horizontal-pie]
       [alignment '(left center)]
       [style '(deleted)]
       [vert-margin 10]
       [horiz-margin 20]
       [stretchable-width #f]
       [stretchable-height #f]
       )
  )

(define panel-horizontal-botones-generar
  (new horizontal-panel% [parent conjunto-panel-generar]
       [style '(deleted)]
       [alignment '(left center)]
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )

(define panel-horizontal-botones-opciones-archivador
  (new horizontal-panel% [parent conjunto-panel-opciones-archivador]
       [style '(deleted)]
       [alignment '(left center)]
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )


(define conjunto-panel-CPU
  (new group-box-panel%
       [label "Ajustes CPU"]
       [parent panel-horizontal-pie]
       [style '(deleted)]
       [horiz-margin 20]
       [stretchable-width #t]	 
       [stretchable-height #f]
       )
  )

(define panel-horizontal-ajustes-CPU
  (new horizontal-panel% [parent conjunto-panel-CPU]
       [alignment '(left center)]
       )
  )

(define panel-vertical-tiempos-espera
  (new vertical-panel% [parent panel-horizontal-ajustes-CPU]
       [alignment '(left center)]
       [style '(deleted)]
       )
  )


(define conjunto-panel-archivador
  (new group-box-panel%
       [label "Datos del tablero"]
       [parent dialogo-guardar-tablero]
       [vert-margin 10]
       [horiz-margin 10]
       [alignment '(left center)]
       )
  )