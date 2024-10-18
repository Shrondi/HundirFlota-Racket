#lang s-exp lang/plt-pretty-big

(provide dialogo-guardar-tablero)
(provide dialogo-archivo)
(provide dialogo-ganador)

(require racket/lazy-require)
(lazy-require ["funcionesCallback/callbackDialogos.rkt" (callback-on-close)])
(require "ventana.rkt")
(require "../macros.rkt")

(define dialog-class%
  (class dialog%	 
    (define/augment (on-close)
      (callback-on-close)
      )
    (super-new)
    )
  )

(define dialogo-guardar-tablero
  (new dialog-class%	 
       [label "Guardar tablero en archivador"]	 
       [parent ventana-principal]
       [alignment '(center center)]
       [min-width 400]	 
       [min-height 400]
       [spacing 5] 	 	  	 
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )




(define dialogo-archivo
  (new dialog%	 
       [label "Archivador de tableros"]	 
       [parent ventana-principal]
       [min-width 780]
       [min-height altura-tablero] 	 	 	 
       [stretchable-width #f]	 
       [stretchable-height #t]
       )
  )




(define dialogo-ganador
  (new dialog%	 
       [label "Partida finalizada"]	 
       [parent ventana-principal]
       [min-width 200]	 
       [min-height 200]
       [stretchable-width #f]	 
       [stretchable-height #f]
       )
  )
