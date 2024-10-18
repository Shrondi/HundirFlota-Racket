#lang s-exp lang/plt-pretty-big

(provide principal-frame% player-frame% CPU-frame%)

(require racket/lazy-require)
(lazy-require ["callbackBotones.rkt" (callback-boton-anclar/desanclar-jugador
                                      callback-boton-anclar/desanclar-CPU)])


(define principal-frame%
  (class frame%
    (define/augment (on-close)
      (displayln "Saliendo...")
      (exit)
      )
    (super-new)
    )
  )

(define player-frame%
  (class frame%
    (define/augment (on-close)
      ;; Se pasa 'b ya que el argumento no sirve,
      ;; pero la libreria require que las funciones callback reciban dos argumentos
      (callback-boton-anclar/desanclar-jugador 'b e) 
      )
    (super-new)
    )
  )

(define CPU-frame%
  (class frame%
    (define/augment (on-close)
      (callback-boton-anclar/desanclar-CPU 'b e)
      )
    (super-new)
    )
  )