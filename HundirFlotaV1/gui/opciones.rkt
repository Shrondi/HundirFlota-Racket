#lang s-exp lang/plt-pretty-big

(provide elecciones-tableros
         elecciones-dificultad-CPU)

(require racket/lazy-require)

(require "dialogos.rkt")
(require "paneles.rkt")
(lazy-require ["funcionesCallback/callbackOpciones.rkt" (callback-elecciones-tableros
                                                         callback-elecciones-dificultad-CPU)])




(define elecciones-tableros 
  (new choice%
       [label "Elige un tablero para cargar "]
       [parent dialogo-archivo]
       [choices (list "")]
       [callback callback-elecciones-tableros]
       )
  )

(define elecciones-dificultad-CPU
  (new radio-box%
       [label "Algoritmo \n disparos"]
       [parent panel-horizontal-ajustes-CPU]
       [horiz-margin 20]
       [style '(vertical deleted)]
       [selection 1]
       [choices (list "Disparos aleatorios" "Algoritmo Hunt/Target" "Algoritmo Hunt/Target \n probabilístico")]
       [callback callback-elecciones-dificultad-CPU]
       )
  )
          


