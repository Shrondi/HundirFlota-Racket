#lang s-exp lang/plt-pretty-big


(provide cambiar-mostrar-tablero-CPU! mostrar-tablero-CPU)
(provide reiniciar-cronometro! reiniciar-cuenta-atras!)
(provide valor-cuenta-atras! valor-segundos! valor-minutos! valor-cuenta-atras minutos segundos)
(provide espera-inicial espera-disparos)
(provide cambiar-espera-inicial! cambiar-espera-disparos!)
(provide texto-disparos texto-disparos-agua texto-disparos-tocado texto-disparos-hundido)
(provide bitmap-archivador)
(provide cambiar-bitmap-archivador!)
(provide ruta-archivador-tableros)
(provide numero-filas numero-columnas)
(provide cell-width cell-height)
(provide anchura-tablero altura-tablero)
(provide turno-jugador)
(provide turno-jugador!)
(provide dificultad-CPU)
(provide cambiar-dificultad-CPU!)
(provide cambiar-tamaño!)
(provide letras)

(define valor-cuenta-atras 5)
(define-values (minutos segundos) (values 0 0))

(define (valor-cuenta-atras! valor)
  (set! valor-cuenta-atras valor)
  )

(define (valor-segundos! nuevo-valor)
(set! segundos nuevo-valor)
  )

(define (valor-minutos! nuevo-valor)
(set! minutos nuevo-valor)
  )

(define (reiniciar-cuenta-atras!)
(set! valor-cuenta-atras 5)
)

(define (reiniciar-cronometro!)
  (set! minutos 0)
  (set! segundos 0)
  )


(define espera-inicial 1)
(define espera-disparos 2)


(define (cambiar-espera-inicial! nuevo-valor)

  (set! espera-inicial nuevo-valor)
  )

(define (cambiar-espera-disparos! nuevo-valor)

  (set! espera-disparos nuevo-valor)
  )


(define ruta-archivador-tableros (build-path (current-directory) "archivo-tableros"))

(define letras (list 'A 'B 'C 'D 'E 'F 'G 'H 'I 'J 'K 'L 'M))

(define texto-disparos "Número disparos:")
(define texto-disparos-agua "\t¡AGUA!:") 
(define texto-disparos-tocado "\t¡TOCADO!:") 
(define texto-disparos-hundido "\t¡HUNDIDO!:")

(define numero-filas 10)
(define numero-columnas 10)

(define cell-width 50)
(define cell-height 50)

(define (cambiar-tamaño! nuevo-valor)

  (set! cell-width (+ cell-width nuevo-valor))
  (set! cell-height (+ cell-height nuevo-valor))
  
  (set! anchura-tablero (* numero-columnas cell-width))
  (set! altura-tablero (* numero-filas cell-height))
  )


(define anchura-tablero (* numero-columnas cell-width))
(define altura-tablero (* numero-filas cell-height))


(define bitmap-archivador 0)

(define (cambiar-bitmap-archivador! bitmap)
  (set! bitmap-archivador bitmap)
  )



;; 0 -> Turno sin decidir (no se ha empezado la partida)
;; Valor booleano -> #t o #f turno o no turno respectivamente
(define turno-jugador 0)

(define (turno-jugador! valor)
  (set! turno-jugador valor)
  )


(define dificultad-CPU 1)

(define (cambiar-dificultad-CPU! nuevo-valor)
  (set! dificultad-CPU nuevo-valor)
  )

(define mostrar-tablero-CPU #f)

(define (cambiar-mostrar-tablero-CPU! valor)
  (set! mostrar-tablero-CPU valor)
  )


