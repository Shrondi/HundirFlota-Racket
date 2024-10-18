#lang s-exp lang/plt-pretty-big

(provide generar-flota-aleatoriamente generar-flota-aleatoriamente-CPU)
(provide generar-barco-aleatoriamente)

(require "funcionesLimpiar.rkt")
(require "macros.rkt")
(require "estructuras.rkt")
(require "funcionesColocar.rkt")
(require math/base)

(define (generar-flota-aleatoriamente dc dc-estado flota-barcos-jugador plantilla-barcos)

  (limpiar-tablero dc dc-estado flota-barcos-jugador plantilla-barcos)

  (let
      (
       (rango-maximo-x (* numero-columnas cell-width))
       (rango-maximo-y (* numero-filas cell-height))
       )
    
    (do
        (
         (posicion-x-aleatoria (random-integer 0 rango-maximo-x) (random-integer 0 rango-maximo-x))
         (posicion-y-aleatoria (random-integer 0 rango-maximo-y) (random-integer 0 rango-maximo-y))
         (orientacion-aleatoria (random-integer 0 2) (random-integer 0 2))
         )
    
      ((flota-colocada? barcos-plantilla))
      (colocar-barco-jugador posicion-x-aleatoria posicion-y-aleatoria #f dc dc-estado (if (= orientacion-aleatoria 0) #f #t) flota-barcos-jugador barcos-plantilla)
      )
    )
  )





(define (generar-barco-aleatoriamente dc dc-estado-flota flota-barcos-jugador plantilla-barcos)

  (let
      (
       (rango-maximo-x (* numero-columnas cell-width))
       (rango-maximo-y (* numero-filas cell-height))
       )
    (do
        (
         (posicion-x-aleatoria (random-integer 0 rango-maximo-x) (random-integer 0 rango-maximo-x))
         (posicion-y-aleatoria (random-integer 0 rango-maximo-y) (random-integer 0 rango-maximo-y))
         (orientacion-aleatoria (random-integer 0 2) (random-integer 0 2))
         )
    
      ((colocar-barco-jugador posicion-x-aleatoria posicion-y-aleatoria #t dc dc-estado-flota (if (= orientacion-aleatoria 0) #f #t) flota-barcos-jugador plantilla-barcos))
      )
    )
  
  )


(define (generar-flota-aleatoriamente-CPU)
  
  (do
      (
       (fila-aleatoria (random-integer 0 numero-filas) (random-integer 0 numero-filas))
       (columna-aleatoria (random-integer 0 numero-columnas) (random-integer 0 numero-columnas))
       (orientacion-aleatoria (random-integer 0 2) (random-integer 0 2))
       )
    
    ((flota-colocada? barcos-plantilla-CPU))
    (colocar-barco-CPU fila-aleatoria columna-aleatoria (if (= orientacion-aleatoria 0) #f #t) flota-barcos-CPU barcos-plantilla-CPU)
    )
  )