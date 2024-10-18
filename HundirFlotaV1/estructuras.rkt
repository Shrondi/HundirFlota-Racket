#lang s-exp lang/plt-pretty-big

(provide probabilidades)
(provide barcos-plantilla)
(provide barcos-plantilla-CPU)
(provide barcos-plantilla-defecto)
(provide disparos-jugador disparos-CPU)
(provide flota-barcos-jugador provide flota-barcos-CPU)
(provide cambiar-tablero-jugador!)

(define flota-barcos-jugador (vector
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)))


(define flota-barcos-CPU (vector
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)))


(define disparos-CPU (vector
                      (vector 0 0 0 0 0 0 0 0 0 0)
                      (vector 0 0 0 0 0 0 0 0 0 0)
                      (vector 0 0 0 0 0 0 0 0 0 0)
                      (vector 0 0 0 0 0 0 0 0 0 0)
                      (vector 0 0 0 0 0 0 0 0 0 0)
                      (vector 0 0 0 0 0 0 0 0 0 0)
                      (vector 0 0 0 0 0 0 0 0 0 0)
                      (vector 0 0 0 0 0 0 0 0 0 0)
                      (vector 0 0 0 0 0 0 0 0 0 0)
                      (vector 0 0 0 0 0 0 0 0 0 0)))


(define disparos-jugador (vector
                          (vector 0 0 0 0 0 0 0 0 0 0)
                          (vector 0 0 0 0 0 0 0 0 0 0)
                          (vector 0 0 0 0 0 0 0 0 0 0)
                          (vector 0 0 0 0 0 0 0 0 0 0)
                          (vector 0 0 0 0 0 0 0 0 0 0)
                          (vector 0 0 0 0 0 0 0 0 0 0)
                          (vector 0 0 0 0 0 0 0 0 0 0)
                          (vector 0 0 0 0 0 0 0 0 0 0)
                          (vector 0 0 0 0 0 0 0 0 0 0)
                          (vector 0 0 0 0 0 0 0 0 0 0)))


;; ID - NOMBRE - NUMERO BARCOS (SIN COLOCAR) - TAMAÑO POR BARCO - COLOR - BARCOS RESTANTES (SIN HUNDIR) - LISTA POR TAMAÑO
(define barcos-plantilla-defecto (vector
                          (vector 1 "Portaaviones" 1 5 "Steel Blue" 1 (list 5))
                          (vector 2 "Acorazado" 1 4 "Crimson" 1 (list 4))
                          (vector 3 "Crucero" 2 3 "Light Green" 2 (list 3 3))
                          (vector 4 "Destructor" 3 2 "Khaki" 3 (list 2 2 2))
                          (vector 5 "Submarino" 3 1 "Navy" 3 (list 1 1 1))))


(define barcos-plantilla (vector
                          (vector 1 "Portaaviones" 1 5 "Steel Blue" 1 (list 5))
                          (vector 2 "Acorazado" 1 4 "Crimson" 1 (list 4))
                          (vector 3 "Crucero" 2 3 "Light Green" 2 (list 3 3))
                          (vector 4 "Destructor" 3 2 "Khaki" 3 (list 2 2 2))
                          (vector 5 "Submarino" 3 1 "Navy" 3 (list 1 1 1))))

(define barcos-plantilla-CPU (vector
                              (vector 1 "Portaaviones" 1 5 "Steel Blue" 1 (list 5))
                              (vector 2 "Acorazado" 1 4 "Crimson" 1 (list 4))
                              (vector 3 "Crucero" 2 3 "Light Green" 2 (list 3 3))
                              (vector 4 "Destructor" 3 2 "Khaki" 3 (list 2 2 2))
                              (vector 5 "Submarino" 3 1 "Navy" 3 (list 1 1 1))))

(define probabilidades (vector
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)
                              (vector 0 0 0 0 0 0 0 0 0 0)))

(define (cambiar-tablero-jugador! nueva-matriz-tablero)

  (set! flota-barcos-jugador nueva-matriz-tablero)
  )
