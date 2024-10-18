#lang s-exp lang/plt-pretty-big

(provide temporizador-cuenta-atras)
(provide temporizador-cronometro)

(require racket/lazy-require)
(lazy-require ["funcionesCallback/callbackTemporizadores.rkt" (callback-temporizador-cuenta-atras
                                                               callback-temporizador-cronometro)])


(define temporizador-cuenta-atras
  (new timer%
       [interval #f] 
       [notify-callback callback-temporizador-cuenta-atras]
       )
  )

(define temporizador-cronometro
  (new timer%
       [interval #f]
       [notify-callback callback-temporizador-cronometro]
       )
  )

